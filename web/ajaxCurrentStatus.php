<?php
	require "db.php";
?>
<?php
	//CURRENT STATUS
	$reqCurrentSatuts = 
	"SELECT e.date AS eDate, rg.state AS rgState, e.state as eState
	FROM Event e, RefGlobalState rg
	WHERE e.state = rg.id
	AND e.sensorId = 0
	ORDER BY e.id DESC
	LIMIT 0 , 1";

	$currentStatus = "<span class=\"bgcolor_globalStateU\">UNKNOWN</span>";
	$result = $db->selectLineObject($reqCurrentSatuts);
	if($db->getNbRows())
	{
		$currentStatus = "<span class=\"statusLabel bgcolor_globalState".$result->eState."\">".$result->rgState."</span>";
	}
	print $currentStatus;
?>
