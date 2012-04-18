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

