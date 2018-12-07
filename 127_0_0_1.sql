-- phpMyAdmin SQL Dump
-- version 4.4.15.7
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Dec 07, 2018 at 02:29 PM
-- Server version: 5.6.37
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `auction`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `auction_reset`(v_datetime DATETIME)
BEGIN IF v_datetime IS NULL THEN 
SET 
	v_datetime = NOW(); END IF; -- Disable temporarily foreign key constraints
SET 
	FOREIGN_KEY_CHECKS = 0; TRUNCATE TABLE bid; TRUNCATE TABLE product; TRUNCATE TABLE member; TRUNCATE TABLE category; -- Enable again foreign key constraints
SET 
	FOREIGN_KEY_CHECKS = 1; START TRANSACTION; INSERT INTO category (category_id, label) 
VALUES 
	(1, 'Comics'), 
	(2, 'CD'); INSERT INTO member (
		member_id, email, password, name, first_name, 
		address, zip, city
	) 
VALUES 
	(
		1, 'haddock@moulinsart.be', 'capitaine', 
		'Haddock', 'Archibald', 'Chateau de Moulinsart', 
		'01234', 'Moulinsart'
	), 
	(
		2, 'bianca.castafiore@scala.it', 
		'ah je ris', 'Castafiore', 'Bianca', 
		'Théâtre de la Scala', '09876', 
		'Milan'
	), 
	(
		3, 'tournesol@moulinsart.be', 'un peu plus à l''ouest', 
		'Tournesol', 'Tryphon', 'Château de Moulinsart', 
		'01234', 'Moulinsart'
	), 
	(
		4, 'lampion@mondass.fr', 'Signez là', 
		'Lampion', 'Séraphin', '34 rue des jobards', 
		'01234', 'Moulinsart'
	), 
	(
		5, 'nestor@moulinsart.be', 'Loch Lomond', 
		'?', 'Nestor', 'Château de Moulinsart', 
		'01234', 'Moulinsart'
	); INSERT INTO product (
		product_id, description, floor_price, 
		deadline, auction_price, entry_date, 
		seller_id, category_id
	) 
VALUES 
	(
		1, 'Le temple du soleil', 10.0, v_datetime + INTERVAL 1 DAY, 
		8.0, v_datetime - INTERVAL 10 DAY, 1, 
		1
	), 
	(
		2, 'Les bijoux de la Castafiore', 
		12.0, v_datetime + INTERVAL 1 DAY, 10.0, 
		v_datetime - INTERVAL 6 DAY, 2, 1
	), 
	(
		3, 'Coke en stock', 11.0, v_datetime, 
		10.0, v_datetime - INTERVAL 5 DAY, 3, 
		1
	), 
	(
		4, 'Les picaros', 11.5, v_datetime - INTERVAL 1 DAY, 
		10.0, v_datetime - INTERVAL 5 DAY, 3, 
		1
	), 
	(
		5, 'Le tournoi des 3 licornes', 18.0, 
		v_datetime - INTERVAL 1 DAY, 15.0, v_datetime - INTERVAL 8 DAY, 
		1, 1
	), 
	(
		6, 'Mafalda', 12.0, v_datetime, 11.0, 
		v_datetime - INTERVAL 5 DAY, 3, 1
	), 
	(
		7, 'Köln concert', 12.0, v_datetime, 
		11.0, v_datetime - INTERVAL 4 DAY, 1, 
		2
	); INSERT INTO bid (
		bid_id, amount, effect_time, bidder_id, 
		product_id
	) 
VALUES 
	(
		1, 11.0, v_datetime - INTERVAL 8 DAY, 
		2, 1
	), 
	(
		2, 12.0, v_datetime - INTERVAL 7 DAY, 
		3, 1
	), 
	(
		3, 13.0, v_datetime - INTERVAL 7 DAY + INTERVAL 1 HOUR, 
		2, 1
	), 
	(
		4, 14.0, v_datetime - INTERVAL 6 DAY, 
		4, 1
	), 
	(
		5, 15.0, v_datetime - INTERVAL 4 DAY, 
		2, 1
	), 
	(
		6, 16.0, v_datetime - INTERVAL 2 DAY, 
		3, 1
	), 
	(
		7, 21.0, v_datetime - INTERVAL 5 DAY, 
		3, 2
	), 
	(
		8, 22.0, v_datetime - INTERVAL 4 DAY, 
		1, 2
	), 
	(
		9, 22.5, v_datetime - INTERVAL 3 DAY, 
		3, 2
	), 
	(
		10, 25.0, v_datetime - INTERVAL 2 DAY, 
		1, 2
	), 
	(
		11, 12.0, v_datetime - INTERVAL 4 DAY, 
		1, 3
	), 
	(
		12, 12.1, v_datetime - INTERVAL 3 DAY, 
		2, 3
	), 
	(
		13, 12.6, v_datetime - INTERVAL 2 DAY, 
		1, 3
	), 
	(
		14, 13.0, v_datetime - INTERVAL 2 DAY + INTERVAL 2 HOUR, 
		2, 3
	), 
	(
		15, 10.5, v_datetime - INTERVAL 4 DAY, 
		1, 4
	), 
	(
		16, 11.0, v_datetime - INTERVAL 3 DAY, 
		2, 4
	), 
	(
		17, 11.5, v_datetime - INTERVAL 2 DAY, 
		4, 4
	), 
	(
		18, 12.5, v_datetime - INTERVAL 2 DAY + INTERVAL 1 HOUR, 
		1, 4
	), 
	(
		19, 13.0, v_datetime - INTERVAL 1 DAY, 
		2, 4
	), 
	(
		20, 15.5, v_datetime - INTERVAL 7 DAY, 
		3, 5
	), 
	(
		21, 16.5, v_datetime - INTERVAL 6 DAY, 
		2, 5
	), 
	(
		22, 17.0, v_datetime - INTERVAL 5 DAY, 
		4, 5
	); COMMIT; END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `initcap`(p_string text) RETURNS text CHARSET utf8
    DETERMINISTIC
BEGIN DECLARE v_left, 
	v_right TEXT; 
SET 
	v_left = ''; 
SET 
	v_right = ''; WHILE p_string LIKE '% %' DO -- if it contains a space
SELECT 
	SUBSTRING_INDEX(p_string, ' ', 1) INTO v_left; 
SELECT 
	SUBSTRING(
		p_string, 
		LOCATE(' ', p_string) + 1
	) INTO p_string; 
SELECT 
	CONCAT(
		v_right, 
		' ', 
		CONCAT(
			UPPER(
				SUBSTRING(v_left, 1, 1)
			), 
			LOWER(
				SUBSTRING(v_left, 2)
			)
		)
	) INTO v_right; END WHILE; RETURN LTRIM(
		CONCAT(
			v_right, 
			' ', 
			CONCAT(
				UPPER(
					SUBSTRING(p_string, 1, 1)
				), 
				LOWER(
					SUBSTRING(p_string, 2)
				)
			)
		)
	); END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bid`
--

CREATE TABLE IF NOT EXISTS `bid` (
  `bid_id` int(11) NOT NULL,
  `amount` decimal(8,1) NOT NULL,
  `effect_time` datetime NOT NULL,
  `bidder_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `bid`
--

INSERT INTO `bid` (`bid_id`, `amount`, `effect_time`, `bidder_id`, `product_id`) VALUES
(1, 11.0, '2018-11-29 15:24:31', 2, 1),
(2, 12.0, '2018-11-30 15:24:31', 3, 1),
(3, 13.0, '2018-11-30 16:24:31', 2, 1),
(4, 14.0, '2018-12-01 15:24:31', 4, 1),
(5, 15.0, '2018-12-03 15:24:31', 2, 1),
(6, 16.0, '2018-12-05 15:24:31', 3, 1),
(7, 21.0, '2018-12-02 15:24:31', 3, 2),
(8, 22.0, '2018-12-03 15:24:31', 1, 2),
(9, 22.5, '2018-12-04 15:24:31', 3, 2),
(10, 25.0, '2018-12-05 15:24:31', 1, 2),
(11, 12.0, '2018-12-03 15:24:31', 1, 3),
(12, 12.1, '2018-12-04 15:24:31', 2, 3),
(13, 12.6, '2018-12-05 15:24:31', 1, 3),
(14, 13.0, '2018-12-05 17:24:31', 2, 3),
(15, 10.5, '2018-12-03 15:24:31', 1, 4),
(16, 11.0, '2018-12-04 15:24:31', 2, 4),
(17, 11.5, '2018-12-05 15:24:31', 4, 4),
(18, 12.5, '2018-12-05 16:24:31', 1, 4),
(19, 13.0, '2018-12-06 15:24:31', 2, 4),
(20, 15.5, '2018-11-30 15:24:31', 3, 5),
(21, 16.5, '2018-12-01 15:24:31', 2, 5),
(22, 17.0, '2018-12-02 15:24:31', 4, 5);

--
-- Triggers `bid`
--
DELIMITER $$
CREATE TRIGGER `bid_before_insert_trg` BEFORE INSERT ON `bid`
 FOR EACH ROW BEGIN DECLARE v_entry_date, 
	v_deadline DATETIME; DECLARE v_seller_id INT; DECLARE v_msg VARCHAR(128); DECLARE v_amount DECIMAL(8, 2); -- Check date constraints
SELECT 
	entry_date, 
	deadline into v_entry_date, 
	v_deadline 
FROM 
	product 
WHERE 
	product_id = NEW.product_id; IF v_entry_date > NEW.effect_time THEN 
SET 
	v_msg = concat(
		'Bid ', NEW.bid_id, ' before product entry date: ', 
		NEW.effect_time, ' < ', v_deadline
	); SIGNAL SQLSTATE '45000' 
SET 
	MESSAGE_TEXT = v_msg, 
	MYSQL_ERRNO = 3000; END IF; IF v_deadline < NEW.effect_time THEN 
SET 
	v_msg = concat(
		'Bid after deadline [product_id: ', 
		NEW.product_id, ', deadline: ', 
		v_deadline, ', effect_time: ', NEW.effect_time, 
		']'
	); SIGNAL SQLSTATE '45000' 
SET 
	MESSAGE_TEXT = v_msg, 
	MYSQL_ERRNO = 3001; END IF; -- Check seller may not bid on his products
SELECT 
	seller_id INTO v_seller_id 
FROM 
	product 
WHERE 
	product_id = NEW.product_id; IF v_seller_id = NEW.bidder_id THEN 
SET 
	v_msg = concat(
		'Bid ', NEW.bid_id, ' by the seller himself (', 
		v_seller_id, ')'
	); SIGNAL SQLSTATE '45000' 
SET 
	MESSAGE_TEXT = v_msg, 
	MYSQL_ERRNO = 3002; END IF; -- check previous bids on the same product are lesser
	-- => may raise a 'mutating table' exception on Oracle
SELECT 
	MAX(amount) INTO v_amount 
FROM 
	bid 
WHERE 
	product_id = NEW.product_id 
	AND effect_time < NEW.effect_time; IF v_amount >= NEW.amount THEN 
SET 
	v_msg = concat(
		'Bid ', NEW.bid_id, ' not enough on product ', 
		NEW.product_id, ': ', NEW.amount, 
		' < max=', v_amount
	); SIGNAL SQLSTATE '45000' 
SET 
	MESSAGE_TEXT = v_msg, 
	MYSQL_ERRNO = 3003; END IF; -- check following bids on the same product are greater
	-- => may raise a 'mutating table' exception on Oracle
SELECT 
	MIN(amount) INTO v_amount 
FROM 
	bid 
WHERE 
	product_id = NEW.product_id 
	AND effect_time > NEW.effect_time; IF v_amount <= NEW.amount THEN 
SET 
	v_msg = concat(
		'Bid ', NEW.bid_id, ' greater than following bids on product ', 
		NEW.product_id, ': ', NEW.amount, 
		' > smaller following =', v_amount
	); SIGNAL SQLSTATE '45000' 
SET 
	MESSAGE_TEXT = v_msg, 
	MYSQL_ERRNO = 3004; END IF; END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE IF NOT EXISTS `category` (
  `category_id` int(11) NOT NULL,
  `label` varchar(20) NOT NULL,
  `parent_id` int(11) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`category_id`, `label`, `parent_id`) VALUES
(1, 'Comics', NULL),
(2, 'CD', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `member`
--

CREATE TABLE IF NOT EXISTS `member` (
  `member_id` int(11) NOT NULL,
  `email` varchar(45) NOT NULL,
  `password` varchar(30) NOT NULL,
  `name` varchar(20) NOT NULL,
  `first_name` varchar(20) NOT NULL,
  `address` varchar(50) NOT NULL,
  `zip` varchar(5) NOT NULL,
  `city` varchar(30) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `member`
--

INSERT INTO `member` (`member_id`, `email`, `password`, `name`, `first_name`, `address`, `zip`, `city`) VALUES
(1, 'haddock@moulinsart.be', 'capitaine', 'HADDOCK', 'Archibald', 'Chateau de Moulinsart', '01234', 'Moulinsart'),
(2, 'bianca.castafiore@scala.it', 'ah je ris', 'CASTAFIORE', 'Bianca', 'Théâtre de la Scala', '09876', 'Milan'),
(3, 'tournesol@moulinsart.be', 'un peu plus à l''ouest', 'TOURNESOL', 'Tryphon', 'Château de Moulinsart', '01234', 'Moulinsart'),
(4, 'lampion@mondass.fr', 'Signez là', 'LAMPION', 'Séraphin', '34 rue des jobards', '01234', 'Moulinsart'),
(5, 'nestor@moulinsart.be', 'Loch Lomond', '?', 'Nestor', 'Château de Moulinsart', '01234', 'Moulinsart');

--
-- Triggers `member`
--
DELIMITER $$
CREATE TRIGGER `member_before_insert` BEFORE INSERT ON `member`
 FOR EACH ROW BEGIN 
SET 
	NEW.first_name = initcap(
		TRIM(NEW.first_name)
	); 
SET 
	NEW.name = UPPER(
		TRIM(NEW.name)
	); 
SET 
	NEW.city = initcap(
		trim(NEW.city)
	); END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE IF NOT EXISTS `product` (
  `product_id` int(11) NOT NULL,
  `description` varchar(60) NOT NULL,
  `floor_price` decimal(8,1) NOT NULL,
  `deadline` datetime NOT NULL,
  `auction_price` decimal(8,1) NOT NULL,
  `entry_date` datetime NOT NULL,
  `seller_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `product`
--

INSERT INTO `product` (`product_id`, `description`, `floor_price`, `deadline`, `auction_price`, `entry_date`, `seller_id`, `category_id`) VALUES
(1, 'Le temple du soleil', 10.0, '2018-12-08 15:24:31', 8.0, '2018-11-27 15:24:31', 1, 1),
(2, 'Les bijoux de la Castafiore', 12.0, '2018-12-08 15:24:31', 10.0, '2018-12-01 15:24:31', 2, 1),
(3, 'Coke en stock', 11.0, '2018-12-07 15:24:31', 10.0, '2018-12-02 15:24:31', 3, 1),
(4, 'Les picaros', 11.5, '2018-12-06 15:24:31', 10.0, '2018-12-02 15:24:31', 3, 1),
(5, 'Le tournoi des 3 licornes', 18.0, '2018-12-06 15:24:31', 15.0, '2018-11-29 15:24:31', 1, 1),
(6, 'Mafalda', 12.0, '2018-12-07 15:24:31', 11.0, '2018-12-02 15:24:31', 3, 1),
(7, 'Köln concert', 12.0, '2018-12-07 15:24:31', 11.0, '2018-12-03 15:24:31', 1, 2);

-- --------------------------------------------------------

--
-- Stand-in structure for view `sold_products`
--
CREATE TABLE IF NOT EXISTS `sold_products` (
`product_id` int(11)
,`auction_price` decimal(8,1)
,`deadline` datetime
,`seller_id` int(11)
,`sale_price` decimal(8,1)
,`sold_at` datetime
,`buyer_id` int(11)
);

-- --------------------------------------------------------

--
-- Structure for view `sold_products`
--
DROP TABLE IF EXISTS `sold_products`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `sold_products` AS select `product`.`product_id` AS `product_id`,`product`.`auction_price` AS `auction_price`,`product`.`deadline` AS `deadline`,`product`.`seller_id` AS `seller_id`,`bid`.`amount` AS `sale_price`,`bid`.`effect_time` AS `sold_at`,`bid`.`bidder_id` AS `buyer_id` from (`product` left join `bid` on((`product`.`product_id` = `bid`.`product_id`))) where (((`product`.`deadline` < now()) and (`bid`.`product_id`,`bid`.`effect_time`) in (select `bid`.`product_id`,max(`bid`.`effect_time`) from `bid` group by `bid`.`product_id`)) or isnull(`bid`.`bidder_id`));

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bid`
--
ALTER TABLE `bid`
  ADD PRIMARY KEY (`bid_id`),
  ADD UNIQUE KEY `bid_product_member_time_key` (`effect_time`,`bidder_id`,`product_id`),
  ADD KEY `fk_bid_bidder` (`bidder_id`),
  ADD KEY `fk_bid_product` (`product_id`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `UC_label` (`label`),
  ADD KEY `fk_category_subcategory` (`parent_id`);

--
-- Indexes for table `member`
--
ALTER TABLE `member`
  ADD PRIMARY KEY (`member_id`),
  ADD UNIQUE KEY `UC_email` (`email`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `fk_bid_category` (`category_id`),
  ADD KEY `fk_bid_seller` (`seller_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bid`
--
ALTER TABLE `bid`
  MODIFY `bid_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=23;
--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `member`
--
ALTER TABLE `member`
  MODIFY `member_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `bid`
--
ALTER TABLE `bid`
  ADD CONSTRAINT `fk_bid_bidder` FOREIGN KEY (`bidder_id`) REFERENCES `member` (`member_id`),
  ADD CONSTRAINT `fk_bid_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`);

--
-- Constraints for table `category`
--
ALTER TABLE `category`
  ADD CONSTRAINT `fk_category_subcategory` FOREIGN KEY (`parent_id`) REFERENCES `category` (`category_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `fk_bid_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`),
  ADD CONSTRAINT `fk_bid_seller` FOREIGN KEY (`seller_id`) REFERENCES `member` (`member_id`);
--
-- Database: `test`
--

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
