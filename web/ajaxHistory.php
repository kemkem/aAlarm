<?php
	require "db.php";
?>
<?php
	$statusDateTSStart = -1;
	$statusDateTSEnd = -1;
	$factor = 1;
	if(isset($_POST["statusDateTSStart"]))
	{
		$statusDateTSStart = $_POST["statusDateTSStart"];
	}
	if(isset($_POST["statusDateTSEnd"]))
	{
		$statusDateTSEnd = $_POST["statusDateTSEnd"];
	}
	else
	{
		$statusDateTSEnd = time();
	}
	if(isset($_POST["ms"]))
	{
		$factor = 1000;
	}
	
	
	$reqStatus = "
	SELECT e.date as eDate, e.status as eStatusNb, refStatus.status as eStatus, e.sensor as eSensorNb, refSensor.sensor as eSensor
	FROM Event e, RefStatus refStatus, RefSensor refSensor
	WHERE e.status = refStatus.id
	AND e.sensor = refSensor.id
	";
	
	if ($statusDateTSStart != -1)
	{
		print "from ".date("Y-m-d H:i:s", $statusDateTSStart / $factor);
		print " to ".date("Y-m-d H:i:s", $statusDateTSEnd / $factor);
		$statusDateSQLStart = date("Y-m-d H:i:s", $statusDateTSStart / $factor);
		$statusDateSQLEnd = date("Y-m-d H:i:s", $statusDateTSEnd / $factor);
		$reqStatus .= "
		AND e.date BETWEEN '$statusDateSQLStart' AND '$statusDateSQLEnd'
		ORDER BY e.id DESC
		";
	}
	else
	{
		$reqStatus .= "
		ORDER BY e.id DESC
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
