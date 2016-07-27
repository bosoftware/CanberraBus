<?

$query = $_POST["query"];


$dir = 'sqlite:canberra.db';

// Instantiate PDO connection object and failure msg //
$dbh = new PDO($dir) or die("cannot open database");

foreach ($dbh->query($query) as $row) {
        $flag[] = $row;
}
print(json_encode($flag));
?>
