<?php
	require "db.php";
?>
<!DOCTYPE html>

<html>
<head>
	<title>Date Axes</title>
    <link class="include" rel="stylesheet" type="text/css" href="css/jquery.jqplot.min.css" />
    <script class="include" type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
</head>
<body>
<div id="chart1" style="height:300px; width:650px;"></div>
<?php
	$strDateToday = date("Y-m-d H:i:s", time());
	$yesterday = strtotime('-1 day', time());
	$strDateYesterday = date("Y-m-d H:i:s", $yesterday);
	
	$reqStatusLast24H = "SELECT s.date as eDate, s.idRefLevelStatus as eStatus 
	FROM LevelStatus s 
	WHERE s.date BETWEEN '$strDateYesterday' AND '$strDateToday'";
	
	$results = $db->selectLinesObjects($reqStatusLast24H);
	
	$strLine1 = "[";
	if($db->getNbRows())
	{
		foreach($results as $item)
		{
			$strLine1 .= "['".$item->eDate."',".$item->eStatus."],";
		}
	}
	$strLine1 = substr($strLine1, 0, strlen($strLine1) - 1);
	$strLine1 .= "]";
?>

<script type="text/javascript">
$(document).ready(function(){


  var line1=<?php print $strLine1;?>;
  var plot1 = $.jqplot('chart1', [line1], {
    title:'Status Event - Last 24h',
    axes:{
        xaxis:{
			renderer:$.jqplot.BarRenderer
        }
    },
    series:[{lineWidth:4, markerOptions:{style:'square'}}]
  });
});
</script>
    <script class="include" type="text/javascript" src="js/jquery.jqplot.min.js"></script>
<script type="text/javascript" src="js/plugins/jqplot.barRenderer.min.js"></script>
<script type="text/javascript" src="js/plugins/jqplot.categoryAxisRenderer.min.js"></script>
<script type="text/javascript" src="js/plugins/jqplot.pointLabels.min.js"></script></body>
</html>
