<?php

$response = array(
  "success" => false,
  "error" => "",
  "timezone_name" => ""
);

  if (isset($_POST['timezone_offset_minutes'])) {
    $timezone_name = timezone_name_from_abbr("",$_POST['timezone_offset_minutes']*60, false);
    date_default_timezone_set($timezone_name);
    session_start();
    $_SESSION['tz'] = $timezone_name;
    $_SESSION['tz-off'] = $_POST['timezone_offset_minutes'];
    $response['success']  = true;
    $response['timezone_name'] = $timezone_name;
  }

  header("Content-Type: application/json; charset=UTF-8");
  echo json_encode($response);

?>
