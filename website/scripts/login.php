<?php

  require_once("db.php");
  $email = isset($_POST['email']) ? strtolower(trim($_POST['email'])) : "";
  $password = isset($_POST['password']) ? $_POST['password'] : "";

  $response = array(
    "success" => false,
    "error" => "",
    "user" => array()
  );


  $query = "SELECT `id`, `username`, `email` FROM `users` WHERE `email` = ? AND `password` = ? AND `enabled` = TRUE LIMIT 1";
  $stmt = $mysqli->stmt_init();
  if ($stmt->prepare($query)) {
    $password = crypt($password, $pwsalt);
    $stmt->bind_param("ss", $email, $password);
    if ($stmt->execute()) {
      $res = $stmt->get_result();
      if ($res->num_rows > 0) {
        $row = $res->fetch_assoc();
        $response['success'] = true;
        $_SESSION['uid'] = $response['user']['id'] = $row['id'];
        $_SESSION['username'] = $response['user']['username'] = $row['username'];
        $_SESSION['email'] = $response['user']['email'] = $row['email'];

        $query = "UPDATE `users` SET `lastonline` = NOW() WHERE `id` = ? LIMIT 1";
        $stmt = $mysqli->stmt_init();
        if ($stmt->prepare($query)) {
          $stmt->bind_param("s", $row['id']);
          if ($stmt->execute()) {

          }
        }
      } else {
        $response["error"] = "Incorrect username or password";
      }
    } else {
      $response["error"] = "Could not execute query";
    }
  } else {
    $response['error'] = "Could not query database";
  }
  $stmt->close();
  $mysqli->close();
  header("Content-Type: application/json; charset=UTF-8");
  echo json_encode($response);

?>
