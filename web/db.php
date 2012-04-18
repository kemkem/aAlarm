<?php
require 'lib/simpleMysql2.class.php';

$username="aalarm";
$password="wont6Oc`";
$database="aalarm";

$db = new simpleMysql();
$db->connect("localhost", $database, $username, $password);
?>
