<?php

  require_once("db.php");

  $userid = isset($_POST['uid']) ? trim($_POST['uid']) : -1;

  if ($userid <= 0) {
    $response["errors"]["userid"] = "User must be logged in";
  } else {

    $minx = 10000;
    $miny = 10000;
    $maxx = -10000;
    $maxy = -10000;

    $response = array(
      "success" => false,
      "errors" => array(),
      "tile" => array()
    );

    $query = "SELECT MIN(`x`) AS `minx`, MAX(`x`) AS `maxx`, MIN(`y`) AS `miny`, MAX(`y`) AS `maxy` FROM `tiles` WHERE `finished` = TRUE OR `lastedited` >= DATE_ADD(NOW(), INTERVAL -1 DAY)";
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

    $eligiblePicks = array();

    for ($x = $minx-1; $x <= $maxx+1; $x++)
    {
      for($y = $miny-1; $y <= $maxy+1; $y++)
      {
        if ($mapData[$x][$y] == -1) {
          $hasNeighbor = false;
          $hasUnfinishedNeighbor = false;
          if($x >= $minx)
          {
            if ($mapData[$x-1][$y] > -1)
              $hasNeighbor = true;
            else if ($mapData[$x-1][$y] == -2)
              $hasUnfinishedNeighbor = true;
          }
          if ($x <= $maxx)
          {
            if ($mapData[$x+1][$y] > -1)
              $hasNeighbor = true;
            else if ($mapData[$x+1][$y] == -2)
              $hasUnfinishedNeighbor = true;
          }
          if($y >= $miny)
          {
            if ($mapData[$x][$y-1] > -1)
              $hasNeighbor = true;
            else if ($mapData[$x][$y-1] == -2)
              $hasUnfinishedNeighbor = true;
          }
          if ($y <= $maxy)
          {
            if ($mapData[$x][$y+1] > -1)
              $hasNeighbor = true;
            else if ($mapData[$x][$y+1] == -2)
              $hasUnfinishedNeighbor = true;
          }
          if ($hasNeighbor && !$hasUnfinishedNeighbor) {
            $eligiblePicks[] = array(
              'x' => $x,
              'y' => $y
            );
          }
        }
      }
    }

    if (count($eligiblePicks) > 0) {
      $newTile = $eligiblePicks[array_rand($eligiblePicks)];
    } else {
      switch(rand(0,3)) {
          case 0:
            $newTile = array(
              'x' => $minx - rand(2,10),
              'y' => rand($miny-10, $maxy+10),
            );
          case 1:
            $newTile = array(
              'x' => $maxx + rand(2,10),
              'y' => rand($miny-10, $maxy+10)
            );
          case 2:
            $newTile = array(
              'x' => $miny - rand(2,10),
              'y' => rand($minx-10, $maxx+10)
            );
          case 3:
            $newTile = array(
              'x' => $maxy + rand(2,10),
              'y' => rand($minx-10, $maxx+10)
            );
      }
    }

    $query = "INSERT INTO `tiles` (`x`, `y`, `lastedited`, `editedby`, `finished`) VALUES (?, ?, NOW(), ?, FALSE)";
    $stmt = $mysqli->stmt_init();
    if ($stmt->prepare($query)) {
      $stmt->bind_param("iii", $newTile['x'], $newTile['y'], $userid);
      if ($stmt->execute()) {
        $response["success"] = true;
        $response["tile"]["id"] = $mysqli->insert_id;
        $response["tile"]["x"] = $newTile['x'];
        $response["tile"]["y"] = $newTile['y'];
      } else {
        $response["errors"]["db"] = "Could not query database: " . $mysqli->error;
      }
    } else {
      $response["errors"]["db"] = "Could not query database: " . $mysqli->error;
    }
  }

  $mysqli->close();
  header("Content-Type: application/json; charset=UTF-8");
  echo json_encode($response);

 ?>
