<?php

  require_once("db.php");

  $response = array(
    "success" => false,
    "errors" => array()
  );

  $data = json_decode(file_get_contents('php://input'), true);


  $query = "SELECT `id` FROM `tiles` WHERE `id` = ? AND `lastedited` >= DATE_ADD(NOW(), INTERVAL -1 DAY)";
  $stmt = $mysqli->stmt_init();
  if($stmt->prepare($query)) {
    $stmt->bind_param("i", $data['tid']);
    if($stmt->execute()) {
      $res = $stmt->get_result();
      if ($res->num_rows == 0) {
        $response["errors"]['id'] = "This tile has expired!\n\nYou must submit your tile within 24 hours.";
      }
    }
  }
  if (count($response["errors"]) ==0)
  {
    $im = imagecreatetruecolor(64,64);

    $colors = [];
    $color[1] = imagecolorallocate($im, 102, 204, 0);
    $color[2] = imagecolorallocate($im, 0, 102, 0);
    $color[3] = imagecolorallocate($im, 153, 153, 102);
    $color[4] = imagecolorallocate($im, 251, 242, 54);
    $color[5] = imagecolorallocate($im, 109, 194, 202);
    $color[6] = imagecolorallocate($im, 51, 51, 255);
    $color[7] = imagecolorallocate($im, 138, 111, 48);
    $color[8] = imagecolorallocate($im, 153, 0, 0);
    $color[9] = imagecolorallocate($im, 255, 255, 255);

    for ($i = 0; $i < count($data['tdata']); $i++) {
      imagesetpixel($im, $i % 64, floor($i / 64), $color[$data['tdata'][$i]]);
    }

    if (!imagepng($im, "../tiles/".$data['tid'].".png", 0)) {
      $response['errors']['id'] = "Could not save file.";
    }

    if (count($response['errors']) <= 0)
    {
      $query = "UPDATE `tiles` SET `finished` = 1, `lastedited` = NOW() WHERE `id` = ? AND `finished` = 0 LIMIT 1";
      $stmt = $mysqli->stmt_init();
      if($stmt->prepare($query)) {
        $stmt->bind_param("i", $data['tid']);
        if($stmt->execute()) {
          $response["success"] = true;
        } else {
          $response["errors"]["id"] = "Unable to update record";
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
