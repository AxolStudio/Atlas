<?php
  session_start();
  error_reporting(E_ALL);
  ini_set('display_errors', 1);
  ini_set('display_startup_errors', 1);
  if (isset($_SESSION['tz'])) {
    date_default_timezone_set($_SESSION['tz']);
  }
  $time_off = isset($_SESSION['tz-off']) ? $_SESSION['tz-off'] : 0;

  require_once('credentials.php');

  $mysqli = new mysqli(
    $creds['db']['host'],
    $creds['db']['user'],
    $creds['db']['pass'],
    $creds['db']['db']
  );

  if ($mysqli->connect_errno) {
    die("Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error);
  }
  $pwsalt = $creds['password']['salt'];

  function getTileID($X, $Y)
  {
    global $mysqli;
    $tileID = -1;
    $query = "SELECT `id`, `finished` FROM `tiles` WHERE `x` = ? AND `y` = ? AND (`finished` = TRUE OR `lastedited` >= DATE_ADD(NOW(), INTERVAL -1 DAY)) ORDER BY `finished` DESC, `lastedited` DESC LIMIT 1";
    $stmt = $mysqli->stmt_init();
    if($stmt->prepare($query)) {
      $stmt->bind_param("ii", $X, $Y);
      if($stmt->execute()) {
        $res = $stmt->get_result();
        if($res->num_rows > 0) {
          $row = $res->fetch_assoc();
          if ($row['finished'] == 0)
            $tileID = -2;
          else
            $tileID = $row['id'];
        }
      }
    }
    $stmt->close();
    return $tileID;
  }

 ?>
