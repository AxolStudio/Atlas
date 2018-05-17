<?php

  header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
  header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
  header("Cache-Control: post-check=0, pre-check=0", false);
  header("Pragma: no-cache");

  $response = array(
    "success" => false,
    "errors" => array(),
    "tiledata" => ""
  );

  $data = json_decode(file_get_contents('php://input'), true);

  $tileid = $data['tid'];

  if ($tileid == -1)
    $tileid = "empty";
  else if ($tileid == -2)
    $tileid = "editing";

  $filename = "../tiles/".$tileid.".png";
  $data = file_get_contents($filename);
  $base64 = base64_encode($data);
  
  $response['success'] = true;
  $response['tiledata'] = $base64;

  header("Access-Control-Allow-Origin: *");
  header("Access-Control-Allow-Methods: GET, POST");
  echo json_encode($response);
?>
