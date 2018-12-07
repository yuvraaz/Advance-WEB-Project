<?php

// Include class DB found in DB.php
require_once("DB.php");

class Product {

   /** Get the product of id $id as an associative array,
    *  or null if not found */
   public static function get($id) {
      // Get a db connection
      $db = DB::getConnection();
      // Parameterized SQL query
      $sql = "
		SELECT p.*, c.label AS category, m.name, m.first_name, m.email
		FROM 
			product p
				INNER JOIN
			category c ON p.category_id = c.category_id
            INNER JOIN
         member m ON p.seller_id = m.member_id
		WHERE p.product_id = :id";
      // Compile the request
      $stmt = $db->prepare($sql);
      // Set the parameter
      $stmt->bindValue(":id", $id);
      // Execute the request
      $stmt->execute();
      // Return the row as an associative array, or null if not found
      return $stmt->fetch(PDO::FETCH_ASSOC);
   }

   /** Get the bids on the product of id $id, as an array of associative arrays.
    * The result is empty if no bids are found, or if the product does not exist.
    * @param type $id
    * @return type
    */
   public static function getBidsByProductId($id) {
      $db = DB::getConnection();
      $sql = "
		SELECT b.*, m.first_name, m.name
		FROM 
         bid b
            INNER JOIN
         member m ON b.bidder_id = m.member_id
		WHERE product_id = :id
      ORDER BY effect_time DESC";
      $stmt = $db->prepare($sql);
      $stmt->bindValue(":id", $id);
      $stmt->execute();
      return $stmt->fetchAll(PDO::FETCH_ASSOC);
   }

   /** Products whose category_id is $category_id, whose current price is at most
    * $max_current_price and deadline is at most $deadline.
    * Get only the page number $pageIndex (10 rows at most are returned).
    */
   public static function getByFilter($category_id, $max_current_price, $deadline, $pageIndex) {
      $db = DB::getConnection();
      $where = array();
      if ($category_id != null) {
         array_push($where, "category_id=$category_id");
      }
      if ($max_current_price != null) {
         array_push($where, "current_price <= $max_current_price");
      }
      if ($deadline != null) {
         array_push($where, "deadline <= $deadline");
      }
      if (count($where) == 0) {
         $where_clause = "";
      } else {
         $where_clause = "WHERE " . join(" AND ", $where);
      }
      $offset = 10 * ($pageIndex - 1);
      $sql = "
		SELECT 
         p.product_id, p.description, p.deadline, p.category_id,
         MAX(b.amount) AS current_price, 
         c.label AS category
      FROM 
         product p
				INNER JOIN
         bid b ON p.product_id = b.product_id
            INNER JOIN
         category c ON p.category_id = c.category_id
      $where_clause
      GROUP BY 
         p.product_id, p.description, p.deadline,
         p.category_id, category
      LIMIT $offset, 10";
      $stmt = $db->prepare($sql);
      $stmt->execute();
      return $stmt->fetchAll(PDO::FETCH_ASSOC);
   }

}
