<!DOCTYPE html>

<html lang="en">

  <head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    {% asset style.css %}

    <link rel="shortcut icon" href="{{ site.baseurl }}/favicon.ico" type="image/x-icon">
    <link rel="icon" href="{{ site.baseurl }}/favicon.ico" type="image/x-icon">

    <title>{{ site.title }} - Registration Verification</title>

    <link rel="canonical" href="{{ page.url | replace:'index.html','' | prepend: site.baseurl | prepend: site.url }}">

    <meta name="description" content="{% if page.excerpt %}{{ page.excerpt | strip_html | strip_newlines | truncate: 160 }}{% else %}{{ site.description }}{% endif %}">
    <meta name="keywords" content="{{ site.keywords }}">
    <meta name="author" content="{{ site.author }}">

    <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.0.10/css/all.css" integrity="sha384-KwxQKNj2D0XKEW5O/Y6haRH39PE/xry8SAoLbpbCMraqlX7kUP6KHOnrlrtvuJLR" crossorigin="anonymous">
  </head>

  <body role="document" class="verify">
    <form id="form-verify">
      <div class="text-center mb-4">
        <h1 class="h3 mb-3 font-weight-normal">Atlas Registration Verification</h1>
      </div>
      <div class="form-label-group">

        <input type="text" id="verify-code" class="form-control" placeholder="Verification Code" required autofocus maxlength="8" value="<?php
          echo isset($_GET['c']) ? trim($_GET['c']) : '';
        ?>" />
        <label for="inputCode">Verification Code</label>
      </div>
      <button id="verify-button" class="btn btn-lg btn-primary btn-block" type="submit">Verify</button>
    </form>
    <div id="wait" style="display:none;">
      <div class="text-center mb-4">
        <span class="mb-4"><i class="fas fa-user-circle fa-fw fa-4x"></i></span>
        <h1 class="h3 mb-3 font-weight-normal" id="loginModalLabel">Please wait...</h1>
        <span class="mb-4"><i class="fas fa-spinner fa-pulse"></i></span>
      </div>
    </div>
    <div id="verify-success" style="display:none;">
      <span class="mb-4"><i class="fas fa-user-circle fa-fw fa-4x"></i></span>
      <h1 class="h3 mb-3 font-weight-normal" id="loginModalLabel">Registration Verification successful!</h1>
      <p>You may now return to <a href="https://atlas.axolstudio.com/">https://atlas.axolstudio.com/</a> and log in with your username and password.</p>
    </div>

    <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>

    {% asset verify.js %}


  </body>
</html>
