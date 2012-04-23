<?php
	require "db.php";
?>
<?php
	//SENSOR STATE
	$reqCurrentState = 
	"SELECT s.date AS eDate, ref.sensor AS eState, s.sensor as eStateNb
	FROM Event s, RefSensor ref
	WHERE s.sensor = ref.id
	ORDER BY s.id DESC
	LIMIT 0 , 1";

	$currentState = "<span class=\"bgcolor_state1\">UNKNOWN</span>";
	$result = $db->selectLineObject($reqCurrentState);
	if($db->getNbRows())
	{
		$currentState = "<span class=\"statusLabel bgcolor_state".$result->eStateNb."\">".$result->eState."</span>";
		//$currentState .= "<br/>since ".$result->eDate;
	}
	print $currentState;
?>
