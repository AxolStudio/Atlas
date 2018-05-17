<?php
  require_once("db.php");
  $code = isset($_POST['code']) ? trim($_POST['code']) : "";
  $response = array(
    "success" => false,
    "errors" => array()
  );

  if($code == '') {
    $response['errors']['code'] = "You must provide a code!";
  } else {
    $query = "SELECT `id`, `lastonline`, `enabled` FROM `users` WHERE LOWER(`code`) = LOWER(?) LIMIT 1";
    $stmt = $mysqli->stmt_init();
    if ($stmt->prepare($query)) {
      $stmt->bind_param("s", $code);
      if($stmt->execute()) {
        $res = $stmt->get_result();
        if($res->num_rows > 0) {
          $row = $res->fetch_assoc();
          if ($row['enabled']) {
            $response["errors"]["code"] = "This code has already been verified.";
          } else if (strtotime($row['lastonline']) < strtotime('-1 day'))  {
            $response["errors"]["code"] = "This code has expired";
          } else {
            $id = $row['id'];
            $query = "UPDATE `users` SET `enabled` = 1, `code` = '' WHERE `id` = ? LIMIT 1";
            $stmt = $mysqli->stmt_init();
            if ($stmt->prepare($query)) {
              $stmt->bind_param("i", $id);
              if ($stmt->execute()) {
                $stmt->close();
                $response['success'] = true;
              } else {
                $response["errors"]["username"] = "Could not execute query: " . $mysqli->error;
              }
            } else {
              $response["errors"]["username"] = "Could not query database: " . $mysqli->error;
            }
          }
        } else {
          $response["errors"]["username"] = "Invalid code. ";
        }
      } else {
          $response["errors"]["username"] = "Could not execute query: " . $mysqli->error;
      }
    } else {
      $response["errors"]["username"] = "Could not query database: " . $mysqli->error;
    }
  }
  $mysqli->close();
  header("Content-Type: application/json; charset=UTF-8");
  echo json_encode($response);
?>
