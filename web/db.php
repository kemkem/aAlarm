<?php
require 'lib/simpleMysql2.class.php';

$username="aalarm";
$password="wont6Oc";
$database="aalarm";

$db = new simpleMysql();
$state = $db->connect("localhost", $database, $username, $password);
if($state == -1)
{
	print "Database connect failed !";
}

?>
