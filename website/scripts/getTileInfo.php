<?php

  require_once("db.php");

  $response = array(
    "success" => false,
    "errors" => array(),
    "tile" => ""
  );


  $tileid = isset($_POST['tileID']) ? trim($_POST['tileID']) : "";

  if ($tileid === "") {
    $response["errors"]["tileid"] = "Must be a valid Tile ID";
  } else {
    $query = "SELECT `tiles`.`lastedited`, `users`.`username` FROM `users`, `tiles` WHERE `tiles`.`id` = ? AND `users`.`id` = `tiles`.`editedby`";
    $stmt = $mysqli->stmt_init();
    if ($stmt->prepare($query)) {
      $stmt->bind_param("s", $tileid);
      if ($stmt->execute()) {
        $res = $stmt->get_result();
        if ($res->num_rows > 0) {
          $row = $res->fetch_assoc();

          $response['success'] = true;

          $dt = new DateTime($row['lastedited'], new DateTimeZone('UTC'));
          $dt->modify($time_off.' minutes');
          
          $response['tile']['modified'] = $dt->format('m/d/Y g:ia');
          //$response['tile']['stars'] = $row['stars'];
          $response['tile']['username'] = $row['username'];

        }
      }
    }
    $stmt->close();

  }




  $mysqli->close();
  header("Content-Type: application/json; charset=UTF-8");
  header("Access-Control-Allow-Origin: *");
  header("Access-Control-Allow-Methods: GET, POST");
  echo json_encode($response);
?>
