<?php
	require "db.php";
?>
<?php
	$statusDateTSStart = -1;
	$statusDateTSEnd = -1;
	if(isset($_POST["statusDateTSStart"]))
	{
		$statusDateTSStart = $_POST["statusDateTSStart"];
	}
	if(isset($_POST["statusDateTSEnd"]))
	{
		$statusDateTSEnd = $_POST["statusDateTSEnd"];
	}
	
	$reqStatus = "
	SELECT e.date as eDate, e.status as eStatusNb, refStatus.status as eStatus, e.sensor as eSensorNb, refSensor.sensor as eSensor
	FROM Event e, RefStatus refStatus, RefSensor refSensor
	WHERE e.status = refStatus.id
	AND e.sensor = refSensor.id
	";
	
	if ($statusDateTSStart != -1 && $statusDateTSEnd != -1)
	{
		$statusDateSQLStart = date("Y-m-d H:i:s", $statusDateTSStart / 1000);
		$statusDateSQLEnd = date("Y-m-d H:i:s", $statusDateTSEnd / 1000);
		$reqStatus .= "
		AND e.date BETWEEN '$statusDateSQLStart' AND '$statusDateSQLEnd'
		";
	}
	else
	{
		$reqStatus .= "
		limit 0,10";
	}
	$results = $db->selectLinesObjects($reqStatus);

	$strTableLines = "";
	if($db->getNbRows())
	{
		foreach($results as $item)
		{
			$strTableLines .= "<tr><td>";
			$strTableLines .= $item->eDate;
			$strTableLines .= "</td><td class=\"color_status".$item->eStatusNb."\">";
			$strTableLines .= $item->eStatus;
			$strTableLines .= "</td><td class=\"color_state".$item->eSensorNb."\">";
			$strTableLines .= $item->eSensor;
			$strTableLines .= "</td></tr>";
		}

?>
<table class="historyTable">
	<thead>
		<tr>
			<td>Date</td>
			<td>Status</td>
			<td>Sensor</td>
		</tr>
	</thead>
	<tbody>
		<?php print $strTableLines;?>
	</tbody>
</table>
<?
	}
	else
	{
		print "no data !!";
	}
?>