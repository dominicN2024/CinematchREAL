<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$serverName = 'localhost';
$userName = "dominicn2024_cinematch";
$password = "Nakita00!";
$dbName = "dominicn2024_cinematchDB";

$con = mysqli_connect($serverName, $userName, $password, $dbName);

// Check connection
if (!$con) {
    die(json_encode(['error' => true, 'message' => mysqli_connect_error()]));
}

// Check if the required data is provided
if (isset($_POST['sql_command'])) {
    $sql = $_POST['sql_command'];

    $sql2 = preg_replace("/[{}]/", "", $sql);
    // echo $sql;
    // Execute the SQL command
    $result = mysqli_query($con, $sql2);

    if ($result) {
        echo json_encode(['success' => true, 'message' => 'Data inserted successfully']);
    } else {
        echo json_encode(['error' => true, 'message' => mysqli_error($con)]);
    }
} else {
    echo json_encode(['error' => true, 'message' => 'Missing data in the request']);
}

// Close connection
mysqli_close($con);
?>
