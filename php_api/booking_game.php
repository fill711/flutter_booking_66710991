<?php
header("Content-Type: application/json");
include 'condb.php';

$game_id = $_POST['game_id'];
$username = $_POST['username'];
$start_time = $_POST['start_time'];
$end_time = $_POST['end_time'];

////////////////////////////////////////////////////////////
// ✅ CHECK 2 HOURS
////////////////////////////////////////////////////////////

$start = strtotime($start_time);
$end = strtotime($end_time);

$diff = ($end - $start) / 3600;

if ($diff > 2) {
    echo json_encode([
        "status" => "error",
        "message" => "จองได้ไม่เกิน 2 ชั่วโมง"
    ]);
    exit;
}

////////////////////////////////////////////////////////////
// ✅ CHECK TIME OVERLAP
////////////////////////////////////////////////////////////

$sql = "SELECT * FROM game_booking 
        WHERE game_id = ?
        AND (start_time < ? AND end_time > ?)";

$stmt = $conn->prepare($sql);
$stmt->execute([$game_id, $end_time, $start_time]);

if ($stmt->rowCount() > 0) {
    echo json_encode([
        "status" => "error",
        "message" => "ช่วงเวลานี้มีคนจองแล้ว"
    ]);
    exit;
}

////////////////////////////////////////////////////////////
// ✅ INSERT
////////////////////////////////////////////////////////////

$sql = "INSERT INTO game_booking 
        (game_id, username, start_time, end_time)
        VALUES (?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$success = $stmt->execute([
    $game_id,
    $username,
    $start_time,
    $end_time
]);

if ($success) {
    echo json_encode([
        "status" => "success",
        "message" => "จองสำเร็จ"
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "จองไม่สำเร็จ"
    ]);
}