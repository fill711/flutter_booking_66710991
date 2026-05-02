<?php
include "condb.php";

$first_name = $_POST['first_name'];
$last_name = $_POST['last_name'];
$phone = $_POST['phone'];
$username = $_POST['username'];
$password = $_POST['password'];

// เช็ค username ซ้ำ
$check = mysqli_query($conn, "SELECT * FROM employees WHERE username='$username'");

if(mysqli_num_rows($check) > 0){
    echo json_encode(["success" => false, "message" => "Username already exists"]);
} else {
    $sql = "INSERT INTO employees (first_name, last_name, phone, username, password)
            VALUES ('$first_name','$last_name','$phone','$username','$password')";

    if(mysqli_query($conn, $sql)){
        echo json_encode(["success" => true]);
    } else {
        echo json_encode(["success" => false]);
    }
}
?>