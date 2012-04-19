<?php
	require "db.php";
?>	
<html>
	<head>
		<title>AAlarm monitor</title>
		<script src="jquery-1.7.2.min.js"></script>
	</head>
	<body>
		<h1>AAlarm monitor</h1>

<script>
$(document).ready(function(){
	$('#result').load('state');
});
</script>
	<div id="result">
	</div>

<h2>CURRENT STATUS</h2>
<?php
	$reqCurrentSatuts = "SELECT s.date AS eDate, ref.status AS eStatus
	FROM LevelStatus s, RefLevelStatus ref
	WHERE s.idRefLevelStatus = ref.id
	ORDER BY s.id DESC
	LIMIT 0 , 1";
	
	$result = $db->selectLineObject($reqCurrentSatuts);
	if($db->getNbRows())
	{
		print $result->eStatus." since ".$result->eDate."<BR/>"; 
	}
?>
<h2>CURRENT DATE</h2>
<?php
print date("Y-m-d H:i:s", time())."<br>";
$yesterday = strtotime('-1 day', time());
print date("Y-m-d H:i:s", $yesterday)."<br>";
$lastweek = strtotime('-1 week', time());
print date("Y-m-d H:i:s", $lastweek)."<br>";

"SELECT * FROM LevelStatus s WHERE s.date BETWEEN '2012-04-18 00:00:00' AND '2012-04-18 23:59:59'";
?>
	<h2>STATUS EVENTS</h2>
<?php
	$reqStatusEvents = "select s.date as eDate, ref.status as eStatus from LevelStatus s, RefLevelStatus ref where s.idRefLevelStatus = ref.id";
	
	$results = $db->selectLinesObjects($reqStatusEvents);
	if($db->getNbRows())
	{
		foreach($results as $item)
		{
			print $item->eDate." - ".$item->eStatus."<BR/>";
		}
	}
?>
	<h2>SENSOR EVENTS</h2>
<?php
	$reqStatusEvents = "select s.date as eDate, ref.state as eState from SensorState s, RefSensorState ref where s.idRefSensorState = ref.id";
	
	$results = $db->selectLinesObjects($reqStatusEvents);
	if($db->getNbRows())
	{
		foreach($results as $item)
		{
			print $item->eDate." - ".$item->eState."<BR/>";
		}
	}
?>


	<form name="adminForm" action="index.php" method="GET">
		<input type="submit" name="setOnline" value="Online"/>
		<input type="submit" name="setOffline" value="Offline"/>
	</form>
<?php

	if(isset($_GET["setOnline"]))
	{
		print "Setting to online";
		$my_file = 'command/command';
		$handle = fopen($my_file, 'w') or die('Cannot open file:  '.$my_file);
		$data = 'setOnline';
		fwrite($handle, $data);
	}
	if(isset($_GET["setOffline"]))
	{
		print "Setting to offline";
		$my_file = 'command/command';
		$handle = fopen($my_file, 'w') or die('Cannot open file:  '.$my_file);
		$data = 'setOffline';
		fwrite($handle, $data);
	}

?>
	</body>
</html>

