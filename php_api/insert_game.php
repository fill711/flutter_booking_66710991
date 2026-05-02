<?php
include 'condb.php';

header('Content-Type: application/json');

$NAME = $_POST['NAME'];
$INFO = $_POST['INFO'];
$CAPACITY = $_POST['CAPACITY'];

////////////////////////////////////////////////////////////
// ✅ รับรูปภาพ
////////////////////////////////////////////////////////////

$imageName = "";

if (isset($_FILES['image'])) {

    $targetDir = "images/";   // ✅ โฟลเดอร์เก็บรูป
    $imageName = time() . "_" . basename($_FILES["image"]["name"]);
    $targetFile = $targetDir . $imageName;

    if (!move_uploaded_file($_FILES["image"]["tmp_name"], $targetFile)) {
        echo json_encode([
            "success" => false,
            "error" => "Upload image failed"
        ]);
        exit;
    }
}

////////////////////////////////////////////////////////////
// ✅ Insert DB
////////////////////////////////////////////////////////////

try {

    $stmt = $conn->prepare("
        INSERT INTO game (NAME, INFO, CAPACITY, image)
        VALUES (:CAPACITY, :INFO, :CAPACITY, :image)
    ");

    $stmt->bindParam(":NAME", $NAME);
    $stmt->bindParam(":INFO", $INFO);
    $stmt->bindParam(":CAPACITY", $CAPACITY);
    $stmt->bindParam(":image", $imageName);

    if ($stmt->execute()) {
        echo json_encode(["success" => true]);
    } else {
        echo json_encode(["success" => false]);
    }

} catch (PDOException $e) {
    echo json_encode([
        "success" => false,
        "error" => $e->getMessage()
    ]);
}