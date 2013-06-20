<?php
	require "db.php";
?>
<?php
	//SENSOR STATE
	$reqCurrentState = 
	"SELECT 
	e.date as eDate, e.id as eId, e.stateType as eType, e.sensorId as eSensorId, e.state as eState,
	s.state as sState
	FROM Event e, RefState s
	WHERE
	e.stateType = s.stateType AND e.state = s.id
	AND e.stateType = 1
	ORDER BY e.id DESC
	LIMIT 0 , 1";

	$currentState = "<span class=\"bgcolor_sensorStateU\">UNKNOWN</span>";
	$result = $db->selectLineObject($reqCurrentState);
	if($db->getNbRows())
	{
		$currentState = "<span class=\"statusLabel bgcolor_sensorState".$result->eState."\">".$result->sState."</span>";
		//$currentState .= "<br/>since ".$result->eDate;
	}
	print $currentState;
?>
