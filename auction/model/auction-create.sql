DELIMITER $$
DROP SCHEMA IF EXISTS auction $$
CREATE SCHEMA IF NOT EXISTS auction 
DEFAULT CHARACTER SET utf8 $$
USE auction $$

CREATE TABLE IF NOT EXISTS member (
  member_id INT(11) NOT NULL AUTO_INCREMENT,
  email VARCHAR(45) NOT NULL,
  password VARCHAR(30) NOT NULL,
  name VARCHAR(20) NOT NULL,
  first_name VARCHAR(20) NOT NULL,
  address VARCHAR(50) NOT NULL,
  zip VARCHAR(5) NOT NULL,
  city VARCHAR(30) NOT NULL,
  PRIMARY KEY (member_id),
  UNIQUE INDEX UC_email (email ASC))
ENGINE = InnoDB $$


CREATE TABLE IF NOT EXISTS category (
  category_id INT(11) NOT NULL AUTO_INCREMENT,
  label VARCHAR(20) NOT NULL,
  parent_id INT(11) NULL,
  PRIMARY KEY (category_id),
  UNIQUE INDEX UC_label (label ASC),
  INDEX fk_category_subcategory (parent_id ASC),
  CONSTRAINT fk_category_subcategory
    FOREIGN KEY (parent_id)
    REFERENCES category (category_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB $$


CREATE TABLE IF NOT EXISTS product (
  product_id INT(11) NOT NULL AUTO_INCREMENT,
  description VARCHAR(60) NOT NULL,
  floor_price DECIMAL(8,1) NOT NULL,
  deadline DATETIME NOT NULL,
  auction_price DECIMAL(8,1) NOT NULL,
  entry_date DATETIME NOT NULL,
  seller_id INT(11) NOT NULL,
  category_id INT(11) NOT NULL,
  PRIMARY KEY (product_id),
  INDEX fk_bid_category (category_id ASC),
  INDEX fk_bid_seller (seller_id ASC),
  CONSTRAINT fk_bid_category
    FOREIGN KEY (category_id)
    REFERENCES category (category_id),
  CONSTRAINT fk_bid_seller
    FOREIGN KEY (seller_id)
    REFERENCES member (member_id))
ENGINE = InnoDB $$


CREATE TABLE IF NOT EXISTS bid (
  bid_id INT(11) NOT NULL AUTO_INCREMENT,
  amount DECIMAL(8,1) NOT NULL,
  effect_time DATETIME NOT NULL,
  bidder_id INT(11) NOT NULL,
  product_id INT(11) NOT NULL,
  PRIMARY KEY (bid_id),
  UNIQUE INDEX bid_product_member_time_key (effect_time ASC, bidder_id ASC, product_id ASC),
  INDEX fk_bid_bidder (bidder_id ASC),
  INDEX fk_bid_product (product_id ASC),
  CONSTRAINT fk_bid_bidder
    FOREIGN KEY (bidder_id)
    REFERENCES member (member_id),
  CONSTRAINT fk_bid_product
    FOREIGN KEY (product_id)
    REFERENCES product (product_id))
ENGINE = InnoDB $$


CREATE OR REPLACE VIEW sold_products AS 
SELECT 
	product.product_id AS product_id,
	product.auction_price AS auction_price,
	product.deadline AS deadline,
	product.seller_id AS seller_id,
	bid.amount AS sale_price,
	bid.effect_time AS sold_at,
	bid.bidder_id AS buyer_id
FROM 
	product 
		LEFT OUTER JOIN 
	bid ON product.product_id = bid.product_id
WHERE
	(product.deadline < now()
	AND (bid.product_id, bid.effect_time) IN 
	(
		SELECT bid.product_id, MAX(bid.effect_time) 
		FROM bid 
		GROUP BY bid.product_id
	)) 
	OR ISNULL(bid.bidder_id)$$



-- Capitalize a string (used in the member_before_insert trigger)
-- DROP FUNCTION IF EXISTS initcap$$
CREATE FUNCTION initcap(p_string text) RETURNS text CHARSET utf8 DETERMINISTIC
BEGIN
  DECLARE v_left, v_right TEXT;
  SET v_left='';
  SET v_right ='';
  WHILE p_string LIKE '% %' DO -- if it contains a space
    SELECT SUBSTRING_INDEX(p_string, ' ', 1) INTO v_left;
    SELECT SUBSTRING(p_string, LOCATE(' ', p_string) + 1) INTO p_string;
    SELECT CONCAT(v_right, ' ', 
      CONCAT(UPPER(SUBSTRING(v_left, 1, 1)), 
      LOWER(SUBSTRING(v_left, 2)))) INTO v_right;
  END WHILE;
  RETURN LTRIM(CONCAT(v_right, ' ', CONCAT(UPPER(SUBSTRING(p_string,1,1)), LOWER(SUBSTRING(p_string, 2)))));
END$$

-- Normalize the member name and first_name
-- DROP TRIGGER IF EXISTS member_before_insert$$
CREATE TRIGGER member_before_insert
BEFORE INSERT ON member
FOR EACH ROW
BEGIN
	SET NEW.first_name = initcap(TRIM(NEW.first_name));
  SET NEW.name = UPPER(TRIM(NEW.name));
  SET NEW.city = initcap(trim(NEW.city));
END$$

-- Perform many checks before inserting a bid and raises exceptions if
-- business rules are not satisfied
-- DROP TRIGGER IF EXISTS bid_before_insert_trg$$
CREATE TRIGGER bid_before_insert_trg
BEFORE INSERT ON bid
FOR EACH ROW
BEGIN
	DECLARE v_entry_date, v_deadline DATETIME;
	DECLARE v_seller_id INT;
	DECLARE v_msg VARCHAR(128);
	DECLARE v_amount DECIMAL(8,2);
	-- Check date constraints
	SELECT entry_date, deadline into v_entry_date, v_deadline 
	FROM product WHERE product_id = NEW.product_id;
	IF v_entry_date > NEW.effect_time THEN
		SET v_msg = concat('Bid ', NEW.bid_id, ' before product entry date: ', NEW.effect_time,
			' < ', v_deadline);
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT=v_msg, MYSQL_ERRNO=3000;
	END IF;
	IF v_deadline < NEW.effect_time THEN
		SET v_msg = concat('Bid after deadline [product_id: ', NEW.product_id, 
			', deadline: ', v_deadline, ', effect_time: ', NEW.effect_time, ']' );
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT=v_msg, MYSQL_ERRNO=3001;
	END IF;
	-- Check seller may not bid on his products
	SELECT seller_id INTO v_seller_id FROM product WHERE product_id = NEW.product_id;
	IF v_seller_id = NEW.bidder_id THEN
		SET v_msg = concat('Bid ', NEW.bid_id, ' by the seller himself (', v_seller_id, ')');
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT=v_msg, MYSQL_ERRNO=3002;
	END IF;
	-- check previous bids on the same product are lesser
	-- => may raise a 'mutating table' exception on Oracle
	SELECT MAX(amount) INTO v_amount FROM bid 
	WHERE product_id = NEW.product_id AND effect_time < NEW.effect_time;
	IF v_amount >= NEW.amount THEN
		SET v_msg = concat('Bid ', NEW.bid_id, ' not enough on product ', NEW.product_id,
			': ', NEW.amount, ' < max=', v_amount);
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT=v_msg, MYSQL_ERRNO=3003;
	END IF;
	-- check following bids on the same product are greater
	-- => may raise a 'mutating table' exception on Oracle
	SELECT MIN(amount) INTO v_amount FROM bid 
	WHERE product_id = NEW.product_id AND effect_time > NEW.effect_time;
	IF v_amount <= NEW.amount THEN
		SET v_msg = concat('Bid ', NEW.bid_id, ' greater than following bids on product ', NEW.product_id,
			': ', NEW.amount, ' > smaller following =', v_amount);
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT=v_msg, MYSQL_ERRNO=3004;
	END IF;
END$$

	
-- Reset database content. Dates are based on a v_datetime parameter
-- (NOW() by default)	
CREATE PROCEDURE auction_reset(v_datetime DATETIME)
BEGIN
	IF v_datetime IS NULL THEN
		SET v_datetime = NOW();
	END IF;
	-- Disable temporarily foreign key constraints
	SET FOREIGN_KEY_CHECKS=0;
	TRUNCATE TABLE bid;
	TRUNCATE TABLE product;
	TRUNCATE TABLE member;
	TRUNCATE TABLE category;
	-- Enable again foreign key constraints
	SET FOREIGN_KEY_CHECKS=1;

	START TRANSACTION;
	INSERT INTO category (category_id, label) VALUES
	(1, 'Comics'),
	(2, 'CD');

	INSERT INTO member (member_id, email, password, name, first_name, address, zip, city) VALUES
	(1, 'haddock@moulinsart.be', 'capitaine', 'Haddock', 'Archibald', 'Chateau de Moulinsart', '01234', 'Moulinsart'),
	(2, 'bianca.castafiore@scala.it', 'ah je ris', 'Castafiore', 'Bianca', 'Théâtre de la Scala', '09876', 'Milan'),
	(3, 'tournesol@moulinsart.be', 'un peu plus à l''ouest', 'Tournesol', 'Tryphon', 'Château de Moulinsart', '01234', 'Moulinsart'),
	(4, 'lampion@mondass.fr', 'Signez là', 'Lampion', 'Séraphin', '34 rue des jobards', '01234', 'Moulinsart'),
	(5, 'nestor@moulinsart.be', 'Loch Lomond', '?', 'Nestor', 'Château de Moulinsart', '01234', 'Moulinsart');


	INSERT INTO product (product_id, description, floor_price, deadline, auction_price, entry_date, 
	seller_id, category_id) VALUES
	(1, 'Le temple du soleil', 10.0, v_datetime + INTERVAL 1 DAY, 8.0, v_datetime - INTERVAL 10 DAY, 1, 1),
	(2, 'Les bijoux de la Castafiore', 12.0, v_datetime + INTERVAL 1 DAY, 10.0, v_datetime - INTERVAL 6 DAY, 2, 1),
	(3, 'Coke en stock', 11.0, v_datetime, 10.0, v_datetime - INTERVAL 5 DAY, 3, 1),
	(4, 'Les picaros', 11.5, v_datetime - INTERVAL 1 DAY, 10.0, v_datetime - INTERVAL 5 DAY, 3, 1),
	(5, 'Le tournoi des 3 licornes', 18.0, v_datetime - INTERVAL 1 DAY, 15.0, v_datetime - INTERVAL 8 DAY, 1, 1),
	(6, 'Mafalda', 12.0, v_datetime, 11.0, v_datetime - INTERVAL 5 DAY, 3, 1),
	(7, 'Köln concert', 12.0, v_datetime, 11.0, v_datetime - INTERVAL 4 DAY, 1, 2);

	INSERT INTO bid (bid_id, amount, effect_time, bidder_id, product_id) VALUES
	(1, 11.0, v_datetime - INTERVAL 8 DAY, 2, 1),
	(2, 12.0, v_datetime - INTERVAL 7 DAY, 3, 1),
	(3, 13.0, v_datetime - INTERVAL 7 DAY + INTERVAL 1 HOUR, 2, 1),
	(4, 14.0, v_datetime - INTERVAL 6 DAY, 4, 1),
	(5, 15.0, v_datetime - INTERVAL 4 DAY, 2, 1),
	(6, 16.0, v_datetime - INTERVAL 2 DAY, 3, 1),

	(7, 21.0, v_datetime - INTERVAL 5 DAY, 3, 2),
	(8, 22.0, v_datetime - INTERVAL 4 DAY, 1, 2),
	(9, 22.5, v_datetime - INTERVAL 3 DAY, 3, 2),
	(10, 25.0, v_datetime - INTERVAL 2 DAY, 1, 2),

	(11, 12.0, v_datetime - INTERVAL 4 DAY, 1, 3),
	(12, 12.1, v_datetime - INTERVAL 3 DAY, 2, 3),
	(13, 12.6, v_datetime - INTERVAL 2 DAY, 1, 3),
	(14, 13.0, v_datetime - INTERVAL 2 DAY + INTERVAL 2 HOUR, 2, 3),

	(15, 10.5, v_datetime - INTERVAL 4 DAY, 1, 4),
	(16, 11.0, v_datetime - INTERVAL 3 DAY, 2, 4),
	(17, 11.5, v_datetime - INTERVAL 2 DAY, 4, 4),
	(18, 12.5, v_datetime - INTERVAL 2 DAY + INTERVAL 1 HOUR, 1, 4),
	(19, 13.0, v_datetime - INTERVAL 1 DAY, 2, 4),

	(20, 15.5, v_datetime - INTERVAL 7 DAY, 3, 5),
	(21, 16.5, v_datetime - INTERVAL 6 DAY, 2, 5),
	(22, 17.0, v_datetime - INTERVAL 5 DAY, 4, 5);

	COMMIT;
END$$

CALL auction_reset(NOW()) $$

-- THIS HAS TO BE DONE ONLY ONCE
-- If you have Mysql 8, you can write CREATE USER IF NOT EXISTS and so on
CREATE USER 'user_auction'@'localhost' IDENTIFIED BY 'pwd_auction'$$
GRANT ALL ON auction.* TO 'user_auction'@'localhost'$$
GRANT SELECT ON mysql.proc TO 'user_auction'@'localhost'$$
