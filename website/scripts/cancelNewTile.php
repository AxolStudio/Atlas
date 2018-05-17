<?php

  require_once("db.php");

  $response = array(
    "success" => false,
    "errors" => array()
  );

  $tileID = isset($_POST['id']) ? trim($_POST['id']) : 0;

  if ($tileID <= 0)
    $response["errors"]["id"] = "Invalid ID";
  else {
    $query = "DELETE FROM `tiles` WHERE `id` = ? AND `finished` = 0 LIMIT 1";
    $stmt = $mysqli->stmt_init();
    if($stmt->prepare($query)) {
      $stmt->bind_param("s", $tileID);
      if($stmt->execute()) {
        $response["success"] = true;
      } else {
        $response["errors"]["id"] = "Unable to delete record: " . $mysqli->error;
      }
    } else {
      $response["errors"]["id"] = "Unable to delete record: " . $mysqli->error;
    }
  }

  $mysqli->close();
  header("Content-Type: application/json; charset=UTF-8");
  header("Access-Control-Allow-Origin: *");
  header("Access-Control-Allow-Methods: GET, POST");
  echo json_encode($response);


?>
