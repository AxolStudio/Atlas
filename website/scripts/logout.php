<?php

  session_start();
  $response = array(
    "success" => false,
    "error" => ""
  );

  if (isset($_SESSION['uid']) && isset($_SESSION['username'])) {
    $_SESSION = array();
    session_destroy();
    $response["success"] = true;
  } else {
    $response["error"] = "Not logged in";
  }
  header("Content-Type: application/json; charset=UTF-8");
  echo json_encode($response);

 ?>
