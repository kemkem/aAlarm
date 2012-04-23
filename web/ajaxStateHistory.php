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
	SELECT s.date as eDate, s.idRefSensorState as eStateNb, ref.state AS eState
	FROM SensorState s, RefSensorState ref
	WHERE s.idRefSensorState = ref.id";
	
	if ($statusDateTSStart != -1 && $statusDateTSEnd != -1)
	{
		$statusDateSQLStart = date("Y-m-d H:i:s", $statusDateTSStart / 1000);
		$statusDateSQLEnd = date("Y-m-d H:i:s", $statusDateTSEnd / 1000);
		$reqStatus .= "
		AND s.date BETWEEN '$statusDateSQLStart' AND '$statusDateSQLEnd'
		order by s.id desc";
	}
	else
	{
		$reqStatus .= "
		order by s.id desc
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
			$strTableLines .= "</td><td class=\"color_state".$item->eStateNb."\">";
			$strTableLines .= $item->eState;
			$strTableLines .= "</td></tr>";
		}
	}
?>
<table class="historyTable">
	<thead>
		<tr>
			<td>Date</td>
			<td>Event</td>
		</tr>
	</thead>
	<tbody>
		<?php print $strTableLines;?>
	</tbody>
</table>