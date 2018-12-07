<?php

session_start();
$errors = array();

/** POST adds a bid on the product and sends a 201 status, or sends a 409 with a message.
 * This is not exactly a REST WS as we use sessions.
 * It is useful to perform ajax calls.
 */
if (!isset($_SESSION["user"])) {
   header("HTTP/1.1 401 Unauthorized");
   die("Vous must log in to place a bid");
}
$product_id = filter_input(INPUT_GET, "id", FILTER_VALIDATE_INT);
if ($product_id == null // no value
        || $product_id === false) { // not an integer
   header("HTTP/1.1 400 Bad request");
   die("id parameter must be set and integer (eg: product-1-bids)");
}

$amount = filter_input(INPUT_POST, "amount", FILTER_VALIDATE_FLOAT);
if ($amount == null || $amount === false) {
   header("HTTP/1.1 400 Bad request");
   die("amount must be set and be a float");
}
// There is no error
// Call the model
require_once("../model/bid_model.php");
try {
   Bid::insert($amount, $_SESSION["user"]["member_id"], $product_id);
   header("HTTP/1.1 201 CREATED");
//      header("Location: product-$product_id");
} catch (PDOException $ex) {
   header("HTTP/1.1 409 Conflict");
//   foreach ($ex->errorInfo as $key=>$value) {
//      echo "$key : '$value'<br/>";
//   }
   echo $ex->errorInfo[1];
}
