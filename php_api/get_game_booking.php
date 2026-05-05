<?php
include "condb.php";

$sql = "SELECT gb.*, g.NAME 
        FROM game_booking gb
        JOIN game g ON gb.game_id = g.ID
        ORDER BY gb.id DESC";

$stmt = $conn->prepare($sql);
$stmt->execute();

$result = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($result);
?>