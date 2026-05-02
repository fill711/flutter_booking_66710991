<?php
include 'condb.php';
header('Content-Type: application/json');

$id = intval($_GET['ID']);

$stmt = $conn->prepare("DELETE FROM game WHERE ID = ?");
$result = $stmt->execute([$id]);

echo json_encode(["success" => $result]);

?>