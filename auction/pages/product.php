<?php
/** Controller for product of id specified in the url (product-{id}
 * GET displays the product. We should forbid other methods.
 */
session_start();
// Memorize the page to redirect to it if logging in
$_SESSION["page"] = $_SERVER["REQUEST_URI"];

// The product
$product = null;
// Bids of this product
$bids = null;
// Errors
$errors = array();


// Get id parameter
$product_id = filter_input(INPUT_GET, "id", FILTER_VALIDATE_INT);
if ($product_id === null // no value
	|| $product_id == false) { // not an integer
	$errors["id"] = "id parameter must be set and integer (eg: product-1)";
}
else {
	// Call the model
	require_once("../model/product_model.php");
	// Recuperer le produit de id demande
	$product = Product::get($product_id);
	if ($product != null) {
		$bids = Product::getBidsByProductId($product_id);
	}
}
// Sent to the view
require_once("../view/product_view.php");
