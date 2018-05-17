<?php

  require_once("db.php");

  $response = array(
    "success" => false,
    "errors" => array()
  );

  $tileID = isset($_POST['tileid']) ? trim($_POST['tileid']) : 0;
  $userID = isset($_POST['userid']) ? trim($_POST['userid']) : 0;
  $reason = isset($_POST['reason']) ? trim($_POST['reason']) : '';

  if ($tileID <= 0)
    $response["errors"]["tileid"] = "Invalid Tile ID";
  else if ($userID <= 0)
    $response["errors"]["userid"] = "Invalid User ID";
  else if ($reason == '')
    $response["errors"]["reason"] = "You must provide a reason";
  else {

    $query = "SELECT `flags` FROM `tiles` WHERE `id` = ? LIMIT 1";
    $stmt = $mysqli->stmt_init();
    if($stmt->prepare($query)) {
      $stmt->bind_param("i", $tileID);
      if($stmt->execute()) {
        $res = $stmt->get_result();
        if ($res->num_rows > 0) {
          $row = $res->fetch_assoc();
          $flags = $row['flags'];
        } else {
          $response["errors"]["tileid"] = "Unable to find tile";
        }
      }
    }
    $stmt->close();

    if (count($response["errors"]) == 0)
    {

      if ($flags === '')
        $newFlags = array();
      else
        $newFlags = json_decode($flags);

      $newFlags[] =array(
        "userid" => $userID,
        "date" => date('c'),
        "reason" => $reason
      );

      $newNewFlags = json_encode($newFlags);

      $query = "UPDATE `tiles` SET `flags` = ? WHERE `id` = ? LIMIT 1";
      $stmt = $mysqli->stmt_init();
      if($stmt->prepare($query)) {
        $stmt->bind_param("si", $newNewFlags, $tileID);
        if($stmt->execute()) {
          $response["success"] = true;
        } else {
          $response["errors"]["tileid"] = "Unable to update record";
        }
      }
    }
  }

  $mysqli->close();
  header("Content-Type: application/json; charset=UTF-8");
  header("Access-Control-Allow-Origin: *");
  header("Access-Control-Allow-Methods: GET, POST");
  echo json_encode($response);

?>
