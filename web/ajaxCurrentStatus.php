<?php
	require "db.php";
?>
<?php
	//CURRENT STATUS
	$reqCurrentSatuts = 
	"SELECT s.date AS eDate, ref.status AS eStatus, s.status as eStatusNb
	FROM Event s, RefStatus ref
	WHERE s.status = ref.id
	ORDER BY s.id DESC
	LIMIT 0 , 1";

	$currentStatus = "<span class=\"bgcolor_status1\">UNKNOWN</span>";
	$result = $db->selectLineObject($reqCurrentSatuts);
	if($db->getNbRows())
	{
		$currentStatus = "<span class=\"statusLabel bgcolor_status".$result->eStatusNb."\">".$result->eStatus."</span>";
	}
	print $currentStatus;
?>
