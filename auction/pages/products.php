<?php
session_start();
// Memorize the page to redirect to it if logging in
$_SESSION["page"] = $_SERVER["REQUEST_URI"];

/*
  Get products with 3 optional filters
 * $products and $errors are shared with model and view
 */
// Control the parameters
$category_id = filter_input(INPUT_GET, "category_id", FILTER_VALIDATE_INT);
$max_current_price = filter_input(INPUT_GET, "max_current_price", FILTER_VALIDATE_FLOAT);
$deadline = filter_input(INPUT_GET, "deadline");
$pageIndex = filter_input(INPUT_GET, "page");

$errors = array();
if ($category_id === false) {
   array_push($errors, "category_id must be integer");
}
if ($max_current_price === false) {
   array_push($errors, "max_current_price must be a decimal number");
}
if ($deadline !== null && 
        (!preg_match("/^(\d{2})-(\d{2})-(\d{4})$/", $deadline, $eles) 
        || !checkdate($eles[2], $eles[1], $eles[3]))) {
   $deadline = false;
   array_push($errors, "deadline must conform to the format dd-mm-yyyy");
}
if ($pageIndex === false) {
   array_push($errors, "page must be a positive integer");
} else if ($pageIndex == null) {
   $pageIndex = 1; // By default
}
$products = array();
if (count($errors) == 0) {
   require_once ("../model/product_model.php");
   $products = Product::getByFilter($category_id, $max_current_price, $deadline, $pageIndex);
}
require_once("../view/products_view.php");
