<?php
// php/index.php

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?? '/';
$base = '/php';

// normalize: /php -> /php/
if ($path === $base) {
  header('Location: ' . $base . '/', true, 301);
  exit;
}

// strip base prefix
if (str_starts_with($path, $base . '/')) {
  $path = substr($path, strlen($base));
} else {
  http_response_code(404);
  echo "Not Found\n";
  exit;
}

if ($path === '/' || $path === '') {
  header('Content-Type: text/html; charset=utf-8');
  echo <<<HTML
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Howdy from PHP</title>
</head>
<body>
  <h1>Howdy, World!</h1>
</body>
</html>
HTML;
  exit;
}

// FUTURE: Add health check
// if ($path === '/health') {
//   header('Content-Type: text/plain; charset=utf-8');
//   echo "ok\n";
//   exit;
// }

// FUTURE: Add 404 handler
// http_response_code(404);
// header('Content-Type: text/plain; charset=utf-8');
// echo "Not Found\n";
