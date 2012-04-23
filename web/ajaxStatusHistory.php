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
	SELECT s.date as eDate, s.idRefLevelStatus as eStatusNb, ref.status AS eStatus
	FROM LevelStatus s, RefLevelStatus ref
	WHERE s.idRefLevelStatus = ref.id";
	
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
			$strTableLines .= "</td><td class=\"color_status".$item->eStatusNb."\">";
			$strTableLines .= $item->eStatus;
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