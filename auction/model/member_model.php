<?php
require_once("DB.php");

/** Access to the person table.
 * Put here the methods like getBySomeCriteriaSEarch */
class Member {

   /** Get member data for id $member_id
    * @param int $member_id id of the member to be retrieved
    * @return associative_array table row
    */
   public static function get($member_id) {
      $db = DB::getConnection();
      $sql = "SELECT *
              FROM member
              WHERE member_id = :member_id";
      $stmt = $db->prepare($sql);
      $stmt->bindValue(":member_id", $member_id);
      $ok = $stmt->execute();
      return $stmt->fetch(PDO::FETCH_ASSOC);
   }

   public static function getByLoginPassword($login, $password) {
      $db = DB::getConnection();
      // We should use an encoded password, like PASSWORD(password)
      // in the WHERE clause
      $sql = "SELECT *
            FROM member
            WHERE email = :email AND password = :password";
      $stmt = $db->prepare($sql);
      $stmt->bindValue(":email", $login);
      $stmt->bindValue(":password", $password);
      $ok = $stmt->execute();
      return $stmt->fetch(PDO::FETCH_ASSOC);
   }

}

?>