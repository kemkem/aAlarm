<?php
	require "db.php";
?>
<?php
	//SENSOR STATE
	$reqCurrentState = 
	"SELECT e.date AS eDate, rs.state AS rsState, e.sensorState as eState
	FROM Event e, RefSensorState rs
	WHERE e.sensorState = rs.id
	ORDER BY e.id DESC
	LIMIT 0 , 1";

	$currentState = "<span class=\"bgcolor_state1\">UNKNOWN</span>";
	$result = $db->selectLineObject($reqCurrentState);
	if($db->getNbRows())
	{
		$currentState = "<span class=\"statusLabel bgcolor_state".$result->eState."\">".$result->rsState."</span>";
		//$currentState .= "<br/>since ".$result->eDate;
	}
	print $currentState;
?>
