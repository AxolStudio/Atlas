<?php

  require_once("db.php");

  $response = array(
    "success" => false,
    "errors" => array(),
    "minmax" => array(),
    "mapData" => array()
  );

  $minx = 10000;
  $miny = 10000;
  $maxx = -10000;
  $maxy = -10000;

  $query = "SELECT MIN(`x`) AS `minx`, MAX(`x`) AS `maxx`, MIN(`y`) AS `miny`, MAX(`y`) AS `maxy` FROM `tiles` WHERE `finished` = TRUE OR `lastedited` < DATE_ADD(NOW(), INTERVAL -1 DAY)";
  $stmt = $mysqli->stmt_init();
  if ($stmt->prepare($query)) {
    if ($stmt->execute()) {
      $res = $stmt->get_result();
      if ($res->num_rows > 0) {
        $row = $res->fetch_assoc();
        $minx = $row['minx'];
        $miny = $row['miny'];
        $maxx = $row['maxx'];
        $maxy = $row['maxy'];
      }
    }
  }
  $stmt->close();

  $mapData= array();
  for ($x = $minx-1; $x <= $maxx+1; $x++)
  {
    $mapData[$x] = array();
    for($y = $miny-1; $y <= $maxy+1; $y++)
    {
      $mapData[$x][$y] = getTileID($x, $y);
    }
  }

  $response['success'] = true;
  $response["minmax"] = array(
    "minx" => $minx,
    "miny" => $miny,
    "maxx" => $maxx,
    "maxy" => $maxy
  );
  $response["mapData"] = $mapData;

  $mysqli->close();
  header("Content-Type: application/json; charset=UTF-8");
  header("Access-Control-Allow-Origin: *");
  header("Access-Control-Allow-Methods: GET, POST");
  echo json_encode($response);

 ?>
