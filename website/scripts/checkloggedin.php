<?php

  require_once("db.php");
  $response = array(
    "success" => false,
    "error" => "",
    "user" => array()
  );

  if(isset($_SESSION['uid']) && isset($_SESSION['email']) && isset($_SESSION['username'])) {
    if ($_SESSION['uid'] !== "" && $_SESSION['email'] !== "" && $_SESSION['username'] !== "" ) {
      $response['success'] = true;
      $response['user']['id'] = $_SESSION['uid'];
      $response['user']['username'] = $_SESSION['username'];
      $response['user']['email'] = $_SESSION['email'];
    }
  }
  header("Content-Type: application/json; charset=UTF-8");
  echo json_encode($response);

 ?>
