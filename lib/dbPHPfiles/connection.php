<?php 
// ini_set('display_errors', 1);
// ini_set('display_startup_errors', 1);
// error_reporting(E_ALL);

$serverName = 'localhost';
$userName = "dominicn2024_cinematch";
$password = "Nakita00!";
$dbName = "dominicn2024_cinematchDB";

$con = mysqli_connect($serverName, $userName, $password, $dbName);

if (!$con) {
    die(json_encode(['error' => true, 'message' => mysqli_connect_error()]));
}

// Check if the SQL command is provided in the request
if (isset($_POST['sql_command'])) {
    $sql = $_POST['sql_command'];

    // Execute the provided SQL command
    $result = mysqli_query($con, $sql);

    if ($result) {
        $data = array(); // Initialize an array to store the results

        // Fetch data as an associative array
        while ($row = mysqli_fetch_array($result, MYSQLI_ASSOC)) {
            $data[] = $row;
        }

        // Return the results as JSON
        echo json_encode(['success' => true, 'data' => $data]);
    } else {
        // Return an error message
        echo json_encode(['error' => mysqli_error($con)]);
    }
}

// Close connection
mysqli_close($con);
?>
