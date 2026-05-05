<?php
header("Content-Type: application/json");
include "condb.php";

// รับค่า
$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';
$first_name = $_POST['first_name'] ?? '';
$last_name = $_POST['last_name'] ?? '';

// เช็คค่าว่าง
if(empty($username) || empty($password) || empty($first_name) || empty($last_name)){
    echo json_encode([
        "status" => "error",
        "message" => "Please fill all fields"
    ]);
    exit;
}

// ✅ เช็ค username ซ้ำ
$check = $conn->prepare("SELECT * FROM employees WHERE username = :username");
$check->bindParam(':username', $username);
$check->execute();

if($check->rowCount() > 0){
    echo json_encode([
        "status" => "error",
        "message" => "Username already exists"
    ]);
    exit;
}

// ✅ เพิ่มข้อมูล
$sql = "INSERT INTO employees (username, password, first_name, last_name)
        VALUES (:username, :password, :first_name, :last_name)";

$stmt = $conn->prepare($sql);

$stmt->bindParam(':username', $username);
$stmt->bindParam(':password', $password);
$stmt->bindParam(':first_name', $first_name);
$stmt->bindParam(':last_name', $last_name);

if($stmt->execute()){
    echo json_encode([
        "status" => "success",
        "message" => "Register success"
    ]);
}else{
    echo json_encode([
        "status" => "error",
        "message" => "Register failed"
    ]);
}
?>