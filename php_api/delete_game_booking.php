<?php
include "condb.php";

$id = $_GET['id'];

$sql = "DELETE FROM game_booking WHERE id = :id";
$stmt = $conn->prepare($sql);
$stmt->execute([":id"=>$id]);

echo json_encode(["success"=>true]);
?>