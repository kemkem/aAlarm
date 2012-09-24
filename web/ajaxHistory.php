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
	
	
	/*
	$reqStatus = "
	SELECT e.date as eDate, e.sensorId as sensorId, e.state as state, rg.state as rgState, rs.state as rsState
	FROM Event e, RefGlobalState rg, RefSensorState rs
	WHERE e.state = rg.id
	AND e.sensorId = rs.id
	";
	*/
	$reqStatus = "
	SELECT 
	e.date as eDate, e.id as eId, e.stateType as eType, e.sensorId as eSensorId, e.state as eState,
	s.state as sState
	FROM Event e, RefState s
	WHERE
	e.stateType = s.stateType AND e.state = s.id
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
			$strTableLines .= "<tr>";
			$strTableLines .= "<td>".$item->eDate."</td>";
		
			//$strTableLines .= "<td class=\"color_globalState".$item->state."\">";
			//$strTableLines .= $item->rgState;
			
			if($item->eType == 0)
			{
				$strTableLines .= "<td class=\"color_globalState".$item->eState."\">Global state ".$item->sState."</td>";
			}
			else
			{
				$strTableLines .= "<td class=\"color_sensorState".$item->eState."\">Sensor [".$item->eSensorId."] ".$item->sState."</td>";
				
			}
			/*
			$state = "";
			$sensor1 = "";
			switch($item->state)
			{
				case 0:
					$state = "OFFLINE";
					break;
				case 1:
					$state = "TIMED";
					break;
				case 2:
					$state = "ONLINE";
					break;
				case 3:
					$state = "INTRUSION";
					break;
				case 4:
					$state = "WARNING";
					break;
				case 5:
					$state = "ALARM";
					break;
					
			}
			switch($item->sensorId)
			{
				case 0:
					$sensor1 = "CLOSED";
					break;
				case 1:
					$sensor1 = "OPEN";
					break;
			}
			*/
			
			//$strTableLines .= "<td class=\"color_globalState".$item->state."\">".$item->eId."</td>";
			//$strTableLines .= "<td class=\"color_sensorState".$item->sensorId."\">".$item->eType."</td>";
			
			$strTableLines .= "</tr>";
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
<?
	}
	else
	{
		print "no data !!";
	}
?>
