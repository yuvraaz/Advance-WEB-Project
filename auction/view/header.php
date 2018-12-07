<?php

/** Display error of key $key if there is one, in a $tag element
 * If $tag is not set, it defaults to span.
 */
function display_error($key, $tag = "span") {
   // Use the variable set outside the function
   global $errors;
   if (isset($errors[$key])) {
      print "<$tag class='error'>$errors[$key]</$tag>";
   }
}
?>
<nav>
   <a href="./">Home</a>
   <a href="products">Products</a>
   <a href="../doc/">Documentation</a>
   <?php
   if (isset($_SESSION["user"])) {
      // Connected => may disconnect
      ?>
      <form action="sign_out" method="POST" id="loginForm">
         <button type="submit">Disconnect
            <?= $_SESSION["user"]["email"] ?></button>
      </form>
      <?php
   } else {
      $login = filter_input(INPUT_POST, "login");
      // Not connected => login form, with the potential error message
      ?>
      <form action="sign_in" method="POST" id="loginForm">
         <input type="text" name="login" value="<?= $login ?>" placeholder="Your email" title="Your email"/>
         <input type = "password" name = "password" placeholder="Your password" title="Your password"/>
         <button type="submit">Connect</button>
         <?= display_error("login_form", "div") ?>
      </form>
      <?php
   }
   ?>
</nav>
<hr/>