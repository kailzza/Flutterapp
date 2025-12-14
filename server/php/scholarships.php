<?php
// Basic scholarships REST endpoint for XAMPP (development only)
// Place this file in: htdocs/api/scholarships.php

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
  http_response_code(204);
  exit;
}

$host = '127.0.0.1';
$db   = 'scholarship_db';
$user = 'root';
$pass = '';
$dsn  = "mysql:host=$host;dbname=$db;charset=utf8mb4";

try {
  $pdo = new PDO($dsn, $user, $pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);
} catch (PDOException $e) {
  http_response_code(500);
  echo json_encode(['error' => $e->getMessage()]);
  exit;
}

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'GET') {
  $stmt = $pdo->query('SELECT * FROM scholarships ORDER BY id DESC');
  $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
  echo json_encode($rows);
  exit;
}

if ($method === 'POST') {
  $data = json_decode(file_get_contents('php://input'), true);
  $stmt = $pdo->prepare('INSERT INTO scholarships (name, provider, deadline, status, notes, lat, lng) VALUES (?, ?, ?, ?, ?, ?, ?)');
  $stmt->execute([
    $data['name'] ?? '',
    $data['provider'] ?? '',
    $data['deadline'] ?? '',
    $data['status'] ?? 'pending',
    $data['notes'] ?? '',
    $data['lat'] ?? null,
    $data['lng'] ?? null,
  ]);
  echo json_encode(['id' => $pdo->lastInsertId()]);
  exit;
}

if ($method === 'PUT') {
  $id = basename($_SERVER['REQUEST_URI']);
  if (!$id || !is_numeric($id)) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing ID']);
    exit;
  }
  $data = json_decode(file_get_contents('php://input'), true);
  $stmt = $pdo->prepare('UPDATE scholarships SET name = ?, provider = ?, deadline = ?, status = ?, notes = ?, lat = ?, lng = ? WHERE id = ?');
  $stmt->execute([
    $data['name'] ?? '',
    $data['provider'] ?? '',
    $data['deadline'] ?? '',
    $data['status'] ?? 'pending',
    $data['notes'] ?? '',
    $data['lat'] ?? null,
    $data['lng'] ?? null,
    (int)$id,
  ]);
  echo json_encode(['id' => (int)$id]);
  exit;
}

if ($method === 'DELETE') {
  $id = basename($_SERVER['REQUEST_URI']);
  if (!$id || !is_numeric($id)) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing ID']);
    exit;
  }
  try {
    $stmt = $pdo->prepare('DELETE FROM scholarships WHERE id = ?');
    $stmt->execute([(int)$id]);
    echo json_encode(['id' => (int)$id]);
  } catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['error' => $e->getMessage()]);
  }
  exit;
}

http_response_code(405);
echo json_encode(['error' => 'Method not supported']);

?>
