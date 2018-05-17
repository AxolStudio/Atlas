<?php

  require_once("db.php");

  $response = array(
    "success" => false,
    "errors" => array(),
    "mapData" => array(),
    "startX" => 0,
    "startY" => 0,
    "endX" => 0,
    "endY" => 0
  );

  $data = json_decode(file_get_contents('php://input'), true);

  $baseX = 0;
  $baseY = 0;

  $query = "SELECT `x`, `y` FROM `tiles` WHERE `id` = ? LIMIT 1";
  $stmt = $mysqli->stmt_init();
  if($stmt->prepare($query)) {
    $stmt->bind_param("s", $data['tid']);
    if($stmt->execute()) {
      $res = $stmt->get_result();
      //if($res->num_rows > 0) {
        $row = $res->fetch_assoc();
        $baseX = $row['x'];
        $baseY = $row['y'];
    } else {
      $response["errors"]["db"] = "Could not query database: " . $mysqli->error;
    }
  } else {
    $response["errors"]["db"] = "Could not query database: " . $mysqli->error;
  }
  $stmt->close();

  if (count($response['errors']) == 0) {

    $mapData= array();
    for ($x = $baseX-1; $x <= $baseX+1; $x++)
    {
      $mapData[$x] = array();
      for($y = $baseY-1; $y <= $baseY+1; $y++)
      {
        $mapData[$x][$y] = getTileID($x, $y);
      }
    }

    $response["success"] = true;
    $response["mapData"] = $mapData;
    $response["startX"] = $baseX-1;
    $response["endX"] = $baseX+1;
    $response["startY"] = $baseY-1;
    $response["endY"] = $baseY+1;
  }

  $mysqli->close();
  header("Content-Type: application/json; charset=UTF-8");
  header("Access-Control-Allow-Origin: *");
  header("Access-Control-Allow-Methods: GET, POST");
  echo json_encode($response);

?>
