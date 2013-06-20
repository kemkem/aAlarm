<?php
	require "db.php";
?>
<?php
	//CURRENT STATUS
	$reqCurrentSatuts = 
	"SELECT 
	e.date as eDate, e.id as eId, e.stateType as eType, e.sensorId as eSensorId, e.state as eState,
	s.state as sState
	FROM Event e, RefState s
	WHERE
	e.stateType = s.stateType AND e.state = s.id
	AND e.stateType = 0
	ORDER BY e.id DESC
	LIMIT 0 , 1";

	$currentStatus = "<span class=\"bgcolor_globalStateU\">UNKNOWN</span>";
	$result = $db->selectLineObject($reqCurrentSatuts);
	if($db->getNbRows())
	{
		$currentStatus = "<span class=\"statusLabel bgcolor_globalState".$result->eState."\">".$result->sState."</span>";
	}
	print $currentStatus;
?>
