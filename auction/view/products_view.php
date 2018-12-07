<?php
// Product view
// Data : $products
?>
<!DOCTYPE html>
<html>
   <head>
      <link rel="stylesheet" type="text/css" href="static/auction.css"/>
      <title>Search results</title>
   </head>
   <body>
      <?php
      // Header shared by all pages
      require_once("header.php");
      if (count($products) == 0) {
         ?>
         <h1>No product found</h1>
         <p>Examples</p>
         <ul>
            <li><a href="<?= $_SERVER['PHP_SELF'] ?>?category_id=1&max_current_price=100&deadline=2018"><?= $_SERVER['PHP_SELF'] ?>?category_id=1&max_current_price=100&deadline=2018</a></li>
         </ul>
         <?php
      } else {
         ?>
         <h1>Results</h1>
         <table>
            <tr>
               <th>Description</th>
               <th>Category</th>
               <th>Current price</th>
               <th>Deadline</th>
            </tr>
            <?php
            foreach ($products as $product) {
               ?>
               <tr>
                  <td><a href="product-<?= $product['product_id'] ?>"><?= $product["description"] ?></a></td>
                  <td><?= $product["category"] ?></td>
                  <td><?= $product["current_price"] ?></td>
                  <td><?= date("d/m/Y H:i", strtotime($product["deadline"])) ?></td>
               </tr>
               <?php
            }
            ?>
         </table>
         <?php
      }
      