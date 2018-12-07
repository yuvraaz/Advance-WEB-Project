<!DOCTYPE html>
<html>
   <head>
      <link rel="stylesheet" type="text/css" href="static/auction.css"/>
      <title>PHPDemo</title>
   </head>
   <body>
      <?php
      // Header shared by all pages
      require_once("header.php");
      ?>
      <h1>PHPDemo</h1>
      <p>Demo of an application developed in PHP, with form and session management. 
         Some key points</p>
      <h2>Url rewriting</h2>
      <p>We use <code>product-123</code> to display the product number 123,
         instead of <code>product.php?id=123</code>.
         <br/>This way, each product link may be indexed by
         search engines (the url with question mark are not).</p>
      <p>Actually, the first url is mapped to the second one. The <code>.htaccess</code> file,
         the Apache configuration file, defines these matchings. Have a look at it
         and adapt it to your project. The <code>RewriteRule</code> rules use for
         that regular expressions.</p>

      <h2>MVC architecture</h2>
      <p>All the http requests are managed by PHP files located in the <code>pages</code>
         directory. This is the controller part of the application.</p>
      <p>They use model files devoted to the DB part, and located in the 
         <code>model</code> directory, set variables to use in the 
         <code>view</code>, like <code>$errors</code>, and include finally the view, 
         which is located in the <code>view</code> directory.
         <br/>
         Only views send output to the browser.
      </p>
      <p>The model and view directories are not accessible from the Web, thanks
         to the <code>Deny from all</code> directive in their <code>.htaccess</code> file.</p>
      <p>
         We use a single array for errors: <code>$errors</code>. In the same way, we could
         use a single array <code>$data</code> for all the data to share with the view.
         In this case, we would access to the product in the product page through
         <code>$data["product"]</code> instead of directly <code>$product</code>.
         This could be more encapsulated.
      </p>

      <h2>Sessions</h2>
      <p>The user connected to the application is stored in <code>$_SESSION["user"]</code>.</p>
      <p>A common header for all files is included at the beginning of each view file.
         It displays at right a login form if not connected or else a disconnect button.</p>
      <p>In the product page (look at <code>view/product_view.php</code>), the
         form to place a bid is displayed only if connected (and not the product seller).</p>

      <h2>Ajax</h2>
      <p>In the product page, we use Ajax to place a bid.
         With Ajax, we control the bid in a lightweight way: we control only on the
         server side the insert in the db, and if there is an error, we just display it
         through javascript, which avoids to request again the product details and its
         associated bids.
         If it is a success, and only then, we reload the page to refresh the bids.
         This could be even lighter, in asking only the bids, without a complete reload
         of the page</p>
      
      <h2>JS library</h2>
      <p>We use here jquery. Its version is a very old one :-), as I had downloaded it
      many years ago to work offline, and use here only its part devoted to Ajax. 
      It will work with the current version, which you can download too,
      or you can use the online version, if you are sure to have network access.</p>

      <h2>Improvements</h2>
      <p>A search engine to filter products. Its values are already taken in account,
      but there is no form to allow the user to set then. This form could be 
      displayed in a popup accessible from the menu.</p>
      <p>The sign up has not been implemented, as this is an exercise in your
      project :-). However the sequence diagram is in the 
      <a href="../doc/">doc</a> directory.</p>
      <p>The member page has not been implemented. This may be done very easily
      by adapting the product page, which has a similar sequence (refer to the diagram).</p>