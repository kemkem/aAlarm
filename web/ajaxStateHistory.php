<?php
	require "db.php";
?>
<?php
	$strDateToday = date("Y-m-d H:i:s", time());
	$yesterday = strtotime('-1 day', time());
	$strDateYesterday = date("Y-m-d H:i:s", $yesterday);
	
	//WHERE s.date BETWEEN '$strDateYesterday' AND '$strDateToday'	
	//AND s.idRefLevelStatus = ref.id
	$reqStateLast24H = "
	SELECT s.date as eDate, s.idRefSensorState as eStateNb, ref.state AS eState
	FROM SensorState s, RefSensorState ref
	WHERE s.idRefSensorState = ref.id
	order by s.id desc
	limit 0,10";
	
	$results = $db->selectLinesObjects($reqStateLast24H);

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