<?php 

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
header('Content-Type: application/json');

$serverName = 'localhost';
$userName = "dominicn2024_cinematch";
$password = "Nakita00!";
$dbName = "dominicn2024_cinematchDB";

$con = new mysqli($serverName, $userName, $password, $dbName);

if ($con->connect_error) {
    die(json_encode(['error' => true, 'message' => $con->connect_error]));
}

$sql = isset($_POST['sql']) ? $_POST['sql'] : '';

if (empty($sql) || !is_string($sql)) {
    die(json_encode(['error' => true, 'message' => 'Invalid SQL command']));
}

$result = $con->query($sql);

if ($result) {
    $data = [];
    if ($result instanceof mysqli_result) {
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
    }

    // Log data for debugging
    file_put_contents("php_debug.log", print_r($data, true), FILE_APPEND);
    echo json_encode(['success' => true, 'data' => $data]);
} else {
    echo json_encode(['error' => true, 'message' => $con->error]);
}

$con->close();

?>
