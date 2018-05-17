<?php

  require_once("db.php");
  $username = isset($_POST['username']) ? trim($_POST['username']) : "";
  $password = isset($_POST['password']) ? trim($_POST['password']) : "";
  $passwordAgain = isset($_POST['passwordAgain']) ? trim($_POST['passwordAgain']) : "";
  $email = isset($_POST['email']) ? strtolower(trim($_POST['email'])) : "";

  $response = array(
    "success" => false,
    "errors" => array(),
    "misc" => array()
  );

  function sendEmail($email, $username, $code) {
    $message = '
Someone has registered for an account for Atlas (https://atlas.axolstudio.com) using this email address.

If this was you, congratulations!

Your account has been created. You just need to verify your account by following the link below, or visiting https://atlas.axolstudio.com/verify and entering your verification code.

If this was NOT you, please disregard this email.

-------------------------------------------------------
Registered Username: '.$username.'
Verification Code:   '.$code.'
-------------------------------------------------------

Verification link: https://atlas.axolstudio.com/verify/?c='.$code.'

If you have any questions or concerns, please contact atlas@axolstudio.com

Thank you.';

    $headers="From:atlas@axolstudio.com\r\n";
    mail($email, "Atlas Registration Verification", $message, $headers);
    return true;
  }

  function validEmail($email) {
     $isValid = true;
     $atIndex = strrpos($email, "@");
     if (is_bool($atIndex) && !$atIndex)
     {
        $isValid = false;
     }
     else
     {
        $domain = substr($email, $atIndex+1);
        $local = substr($email, 0, $atIndex);
        $localLen = strlen($local);
        $domainLen = strlen($domain);
        if ($localLen < 1 || $localLen > 64)
        {
           // local part length exceeded
           $isValid = false;
        }
        else if ($domainLen < 1 || $domainLen > 255)
        {
           // domain part length exceeded
           $isValid = false;
        }
        else if ($local[0] == '.' || $local[$localLen-1] == '.')
        {
           // local part starts or ends with '.'
           $isValid = false;
        }
        else if (preg_match('/\\.\\./', $local))
        {
           // local part has two consecutive dots
           $isValid = false;
        }
        else if (!preg_match('/^[A-Za-z0-9\\-\\.]+$/', $domain))
        {
           // character not valid in domain part
           $isValid = false;
        }
        else if (preg_match('/\\.\\./', $domain))
        {
           // domain part has two consecutive dots
           $isValid = false;
        }
        else if (!preg_match('/^(\\\\.|[A-Za-z0-9!#%&`_=\\/$\'*+?^{}|~.-])+$/', str_replace("\\\\","",$local)))
        {
           // character not valid in local part unless
           // local part is quoted
           if (!preg_match('/^"(\\\\"|[^"])+"$/', str_replace("\\\\","",$local)))
           {
              $isValid = false;
           }
        }
        if ($isValid && !(checkdnsrr($domain.'.',"MX") ||  checkdnsrr($domain.'.',"A")))
        {
           // domain not found in DNS
           $isValid = false;
        }
     }
     return $isValid;
  }

  if (strlen($username) < 3 || strlen($username) > 32) {
    $response["errors"]["username"] = "Username must be between 3 and 32 characters in length";
  } else if (!validEmail($email)) {
    $response["errors"]["email"] = "Invalid email address";
  } else {
    $query = "SELECT `id`, `username`, `email` FROM `users` WHERE (LOWER(`username`) = LOWER(?) OR `email` = ?) AND (`enabled` = 1 OR `lastonline` >= DATE_ADD(NOW(), INTERVAL -1 DAY)) LIMIT 1";
    $stmt = $mysqli->stmt_init();
    if ($stmt->prepare($query)) {
      $stmt->bind_param("ss", $username, $email);
      if($stmt->execute()) {
        $res = $stmt->get_result();
        if($res->num_rows > 0) {
          $row = $res->fetch_assoc();
          if (strtolower($row["username"]) == strtolower($username)) {
            $response["errors"]["username"] = "Username has already been taken";
          } else {
            $response["errors"]["email"] = "Email is already in use";
          }
        }
      } else {
          $response["errors"]["username"] = "Could not execute query";
      }
    } else {
      $response["errors"]["username"] = "Could not query database for existing usernames: " . $mysqli->error;
    }

  }

  if (strlen($password) < 6 || strlen($password) > 32) {
    $response["errors"]["password"] = "Password must be between 6 and 32 characters in length";
  }
  if ($password != $passwordAgain) {
      $response["errors"]["passwordagain"] = "Passwords must match";
  }

  if (empty($response["errors"])) {
    $query = "INSERT INTO `users` (`username`, `password`, `email`, `code`) VALUES (?, ?, ?, ?)";
    $stmt = $mysqli->stmt_init();
    if ($stmt->prepare($query)) {
      $password = crypt($password, $pwsalt);
      $code = substr(md5(mt_rand()), 0,8);
      $stmt->bind_param("ssss", $username, $password, $email, $code);
      if ($stmt->execute()) {
        $stmt->close();
        // send registration email
        if (sendEmail($email, $username, $code)) {
          $response['success'] = true;
        } else {
          $response["errors"]["email"] = "Could not send confirmation email.";
        }
      } else {
          $response["errors"]["username"] = "Could not execute Query";
      }
    } else {
      $response["errors"]["username"] = "Could not insert new user, please try again";
    }
  }
  $mysqli->close();
  header("Content-Type: application/json; charset=UTF-8");
  echo json_encode($response);

 ?>
