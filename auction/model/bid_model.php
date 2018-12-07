<?php

// Include class DB found in DB.php
require_once("DB.php");

class Bid {

   /** May raise a PDOException with the code among Bid constants or standard integrity violations */
   public static function insert($amount, $bidder_id, $product_id, $effect_time = null) {
      $db = DB::getConnection();
      // Parameterized SQL query
      if ($effect_time == null) {
         $effect_time = "NOW()";
      }
      $sql = "
		INSERT INTO bid(amount, bidder_id, product_id, effect_time)
      VALUES(:amount, :bidder_id, :product_id, $effect_time)";
      // Compile the request
      $stmt = $db->prepare($sql);
      // Set the parameter
      $stmt->bindValue(":amount", $amount);
      $stmt->bindValue(":bidder_id", $bidder_id, PDO::PARAM_INT);
      $stmt->bindValue(":product_id", $product_id, PDO::PARAM_INT);
      // Execute the request
      $stmt->execute();
   }

}
