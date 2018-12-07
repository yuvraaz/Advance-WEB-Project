<?php
/** This page demonstrates the use of Ajax to place a bid on the displayed product.
 * With Ajax, we control the bid in a lightweight way: we control only on the
 * server side the insert in the db, and if there is an error, we just display it
 * through javascript, which avoids to request again the product details and its
 * associated bids.
 * If it is a success, and only then, we reload the page to refresh the bids.
 * This could be even lighter, in asking only the bids, without a complete reload
 * of the page.
 * The user experience could be improved by displaying the bids on a temporal layer
 * encompassing the entry date and the deadline. This would require a lot of additional
 * JS and CSS code. 
 */
// Product view
// Data : $product, $bids
require_once("../model/DB.php");
?>
<!DOCTYPE html>
<html>
   <head>
      <link rel="stylesheet" type="text/css" href="static/auction.css"/>
      <title>PHPDemo - <?= $product["description"] ?> (id <?= $product["product_id"] ?>)</title>
      <script src="static/jquery-1.11.2.min.js"></script>
      <script>
         // What to do when page loading is complete
         $(document).ready(function () {
            // Reaction to a click on the bidButton button
            $("#bidForm").submit(function (event) {
               $.ajax({
                  type: "POST",
                  url: "product-<?= $product["product_id"] ?>-bids",
                  // Body parameters to send
                  data: {
                     amount: $("#bidAmount").val()
                  },
                  // What to do in case of failure (400-599)
                  error: function (xhr, string) {
                     msg = null;
                     switch (xhr.responseText) {
                        case "<?= DB::BID_AFTER_DEADLINE ?>":
                           msg = "Bid after deadline";
                           break;
                        case "<?= DB::BID_BEFORE_ENTRY_DATE ?>":
                           msg = "Bid before entry date";
                           break;
                        case "<?= DB::BID_BY_THE_SELLER ?>": // Normally not possible
                           msg = "Bid by the seller himself";
                           break;
                        case "<?= DB::BID_GREATER_THAN_FOLLOWING_ONES ?>":
                           msg = "Bid greater then folllowing ones";
                           break;
                        case "<?= DB::BID_TOO_SMALL ?>":
                           msg = "Bid must be higher than the previous ones";
                           break;
                        default:
                           msg = "Erreur : " + xhr.responseText;
                     }
                     $("#bidMessage").html(msg).addClass("error");
                  },
                  // What to do if success (200-299)
                  success: function (data) {
                     // Reload the page from the server
                     location.reload(true);
                  }
               });
            });
         })
      </script>
   </head>
   <body>
      <?php
      // Header shared by all pages
      require_once("header.php");
      if (isset($errors["id"])) {
         ?>
         <h1><?= $errors["id"] ?></h1>
         <p>Usage example:
            <a href="product-1">product-1</a> (where 1 is the product id).
         </p>
         <?php
      } else {
         if ($product == null) {
            die("<h1>Produit not found</h1>");
         } else {
            ?>
            <h1><?= $product["description"] ?>
               (<?= $product["category"] ?>)</h1>
            <p>
               Proposed as <?= $product["auction_price"] ?> € 
               by <a href="member-<?= $product['seller_id'] ?>"><?= $product["first_name"] ?>
                  <?= strtoupper($product["name"]) ?></a>.
               <br/>
               From <?= date("d/m/Y H:i", strtotime($product["entry_date"])) ?>
               to <?= date("d/m/Y H:i", strtotime($product["deadline"])) ?>
            </p>

            <?php
            if (isset($_SESSION["user"])) {
               if ($_SESSION["user"]["member_id"] != $product["seller_id"]) { // Allow to bid
                  ?>
                  <form method="POST" action="javascript:" id="bidForm">
                     Amount: <input type="number" step="0.01" id="bidAmount" required="required"/>
                     <button type="submit" id="bidButton">Place a bid</button>
                     <div id="bidMessage"></div>
                  </form>
                  <?php
               } else {
                  ?>
                  <p>You are the owner of this product.</p>
                  <?php
               }
            } else {
               ?>
               <p>Sign in to place a bid</p>
               <?php
            }

            if (count($bids) == 0) {
               ?>	
               <h1>No bid on this product</h1>
               <?php
            } else {
               ?>
               <h2>Bids</h2>
               <table>
                  <tr>
                     <th>Amount</th>
                     <th>Date</th>
                     <th>Bidder</th>
                  </tr>
                  <?php
                  foreach ($bids as $bid) {
                     ?>
                     <tr>
                        <td><?= $bid["amount"] ?></td>
                        <td><?= $bid["effect_time"] ?></td>
                        <td>
                           <a href="member-<?= $bid['bidder_id'] ?>"><?= $bid["first_name"] ?>
                              <?= $bid["name"] ?></a>
                        </td>
                     </tr>
                     <?php
                  }
                  ?>
               </table>
               <?php
            }
         }
      }
