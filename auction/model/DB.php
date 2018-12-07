<?php

/** <p>Provide connections to the auction database,
 * and encapsulate in constants common MySql error codes (related to integrity 
 * constraints) and developer defined error codes that triggers may raise.</p>
 * <p>Typical use:<pre>
 * catch (PDOException exc) {
 *   $errorCode = $exc->getCode();
 *   if ($errorCode == DB::ROW_IS_REFERENCED) {
 *     //...
 * </pre>
 * 
 */
class DB {

   // Prefedined MySql integrity exceptions
   const DUPLICATE_ENTRY = 1062;
   const ROW_IS_REFERENCED = 1451;
   const REFERENCED_ROW_NOT_FOUND = 1452;
   // Auction defined exceptions, raised by triggers
   const BID_BEFORE_ENTRY_DATE = 3000;
   const BID_AFTER_DEADLINE = 3001;
   const BID_BY_THE_SELLER = 3002;
   const BID_TOO_SMALL = 3003;
   const BID_GREATER_THAN_FOLLOWING_ONES = 3004;

   /** Get a connection to the DB, in UTF-8 */
   public static function getConnection() {
      // DB configuration
      $db = "auction";
      $dsn = "mysql:dbname=$db;host=localhost;charset=utf8";
      $user = "user_auction";
      $password = "pwd_auction"; // root avec MAMP et XAMPP
      // Get a DB connection with PDO library
      $bdd = new PDO($dsn, $user, $password);
      // Set communication in utf-8
      $bdd->exec("SET character_set_client = 'utf8'");
      // Throw the SQL exception
      $bdd->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
      return $bdd;
   }

}
