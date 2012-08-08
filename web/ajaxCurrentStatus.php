<?php
	require "db.php";
?>
<?php
	//CURRENT STATUS
	$reqCurrentSatuts = 
	"SELECT e.date AS eDate, rg.state AS rgState, e.globalState as eState
	FROM Event e, RefGlobalState rg
	WHERE e.globalState = rg.id
	ORDER BY e.id DESC
	LIMIT 0 , 1";

	$currentStatus = "<span class=\"bgcolor_status1\">UNKNOWN</span>";
	$result = $db->selectLineObject($reqCurrentSatuts);
	if($db->getNbRows())
	{
		$currentStatus = "<span class=\"statusLabel bgcolor_status".$result->eState."\">".$result->rgState."</span>";
	}
	print $currentStatus;
?>
