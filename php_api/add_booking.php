<?php
header("Content-Type: application/json");
include 'condb.php';

// รองรับทั้ง POST และ JSON
$data = $_POST;
if (empty($data)) {
    $data = json_decode(file_get_contents("php://input"), true);
}

$room_id = $data['room_id'] ?? null;
$username = $data['user_name'] ?? null;
$booking_date = $data['booking_date'] ?? null;
$start_time = $data['start_time'] ?? null;
$end_time = $data['end_time'] ?? null;

// ✅ ตรวจข้อมูล
if (!$room_id || !$username || !$booking_date || !$start_time || !$end_time) {
    echo json_encode(["status"=>"error","message"=>"ข้อมูลไม่ครบ"]);
    exit;
}

// ✅ CHECK 2 ชั่วโมง
$start = strtotime($start_time);
$end = strtotime($end_time);

$diff = ($end - $start) / 3600;

if ($diff > 2) {
    echo json_encode(["status"=>"error","message"=>"จองได้ไม่เกิน 2 ชั่วโมง"]);
    exit;
}

// ✅ CHECK เวลาในวันเดียวกัน
$sql = "SELECT * FROM bookings 
        WHERE room_id = ?
        AND booking_date = ?
        AND NOT (end_time <= ? OR start_time >= ?)";

$stmt = $conn->prepare($sql);
$stmt->execute([$room_id, $booking_date, $start_time, $end_time]);

if ($stmt->rowCount() > 0) {
    echo json_encode(["status"=>"error","message"=>"ช่วงเวลานี้มีคนจองแล้ว"]);
    exit;
}

// ✅ INSERT
$sql = "INSERT INTO bookings 
        (room_id, user_name, booking_date, start_time, end_time)
        VALUES (?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);
$success = $stmt->execute([
    $room_id,
    $username,
    $booking_date,
    $start_time,
    $end_time
]);

if ($success) {
    echo json_encode(["status"=>"success","message"=>"จองสำเร็จ"]);
} else {
    echo json_encode(["status"=>"error","message"=>"จองไม่สำเร็จ"]);
}