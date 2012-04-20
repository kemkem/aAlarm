<?php
	require "db.php";
?>
<?php
	$strDateToday = date("Y-m-d H:i:s", time());
	$yesterday = strtotime('-1 day', time());
	$strDateYesterday = date("Y-m-d H:i:s", $yesterday);
	
	//WHERE s.date BETWEEN '$strDateYesterday' AND '$strDateToday'	
	//AND s.idRefLevelStatus = ref.id
	$reqStatusLast24H = "SELECT s.date as eDate, s.idRefLevelStatus as eStatusNb, ref.status AS eStatus
	FROM LevelStatus s, RefLevelStatus ref
	WHERE s.idRefLevelStatus = ref.id
	order by s.id desc
	limit 0,10";
	
	$results = $db->selectLinesObjects($reqStatusLast24H);

	$strTableLines = "";
	if($db->getNbRows())
	{
		foreach($results as $item)
		{
			//print $item->eDate." - ".$item->eStatusNb." - ".$item->eStatus."<BR/>";
			//print "<span class=\"color_status".$item->eStatusNb."\">".$item->eStatus."</span><br/>";
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