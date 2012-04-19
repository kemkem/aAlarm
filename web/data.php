<?php
	require "db.php";
?>
<!DOCTYPE html>

<html>
<head>
	<title>Data</title>
	<link class="include" rel="stylesheet" type="text/css" href="css/data.css" />
    <script class="include" type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
</head>
<body>


<?php
	$strDateToday = date("Y-m-d H:i:s", time());
	$yesterday = strtotime('-1 day', time());
	$strDateYesterday = date("Y-m-d H:i:s", $yesterday);
	
	
	$reqStatusLast24H = "SELECT s.date as eDate, s.idRefLevelStatus as eStatusNb, ref.status AS eStatus
	FROM LevelStatus s, RefLevelStatus ref
	WHERE s.date BETWEEN '$strDateYesterday' AND '$strDateToday'
	AND s.idRefLevelStatus = ref.id";
	
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
<table>
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

	
</body>
</html>
