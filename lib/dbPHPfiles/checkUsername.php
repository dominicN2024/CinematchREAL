<?php
// Database credentials
$serverName = 'localhost';
$userName = "dominicn2024_cinematch";
$password = "Nakita00!";
$dbName = "dominicn2024_cinematchDB";

// Connect to the database
$conn = mysqli_connect($host, $dbUsername, $dbPassword, $dbName);

// Check the connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Get the JSON POST body
$json = file_get_contents('php://input');
$data = json_decode($json, true);

// Check if sql is set
if (!isset($data['sql'])) {
    echo json_encode(['error' => 'No SQL command provided']);
    exit;
}

$sql = $data['sql'];

// Execute the SQL command
$result = mysqli_query($conn, $sql);

// Check for errors in SQL execution
if (!$result) {
    echo json_encode(['error' => mysqli_error($conn)]);
    exit;
}

// Process the result
// Assuming the result is a SELECT query
$rows = mysqli_fetch_all($result, MYSQLI_ASSOC);

// Return the result
echo json_encode($rows);

// Close connections
mysqli_free_result($result);
mysqli_close($conn);
?>