<?php
	require "db.php";
?>
<?php
	//SENSOR STATE
	$reqCurrentState = 
	"SELECT e.date AS eDate, rs.state AS rsState, e.state as eState
	FROM Event e, RefSensorState rs
	WHERE e.state = rs.id
	AND e.sensorId = 1
	ORDER BY e.id DESC
	LIMIT 0 , 1";

	$currentState = "<span class=\"bgcolor_sensorStateU\">UNKNOWN</span>";
	$result = $db->selectLineObject($reqCurrentState);
	if($db->getNbRows())
	{
		$currentState = "<span class=\"statusLabel bgcolor_sensorState".$result->eState."\">".$result->rsState."</span>";
		//$currentState .= "<br/>since ".$result->eDate;
	}
	print $currentState;
?>
