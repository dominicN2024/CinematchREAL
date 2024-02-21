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
    if (mysqli_num_rows($result) > 0) {
        while($row = mysqli_fetch_assoc($result)) {
            $data[] = array('user_id' => $row['user_id']);
        }
        // foreach ($data as $item) {
        //     echo $item['duration'] . "<br>"; // Print title with a line break
        // }
        echo json_encode(['success' => true, 'data' => $data]);
        if (json_last_error() != JSON_ERROR_NONE) {
            file_put_contents("php_debug.log", json_last_error_msg(), FILE_APPEND);
        } else {
            // Log data for debugging
            file_put_contents("php_debug.log", print_r($data, true), FILE_APPEND);
        }
    } else {
        echo json_encode(['success' => true, 'data' => []]);
    }
} else {
    echo json_encode(['error' => true, 'message' => $con->error]);
}

$con->close();
exit(); 
?>
