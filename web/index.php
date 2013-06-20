<!DOCTYPE html>
<?php
	require "db.php";
?>
<html lang="en"><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <title>AAlarm</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <link href="css/bootstrap.css" rel="stylesheet">
	<link href="css/jqueryUi/jquery-ui-1.8.19.custom.css" rel="stylesheet">
	<link href="css/aalarm.css" rel="stylesheet">
	<link href="css/colors.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
    </style>
    <link href="css/bootstrap-responsive.css" rel="stylesheet">

    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <link rel="shortcut icon" href="http://twitter.github.com/bootstrap/assets/ico/favicon.ico">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="http://twitter.github.com/bootstrap/assets/ico/apple-touch-icon-114-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="72x72" href="http://twitter.github.com/bootstrap/assets/ico/apple-touch-icon-72-precomposed.png">
    <link rel="apple-touch-icon-precomposed" href="http://twitter.github.com/bootstrap/assets/ico/apple-touch-icon-57-precomposed.png">
  </head>

  
  <body>

    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="#">AAlarm</a>
          <div class="nav-collapse">
            <ul class="nav">
              <li class="active"><a href="#">Main</a></li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <div class="container">

      <div class="hero-unit">
        <h1>AAlarm Monitor</h1>
		
		<div class="row">
			<div class="span3">
				<p>Current Status</p>
				<div id="idTargetStatus" class="statusBlock"></div>
			</div>
			<div class="span3">
				<p>Sensor 1 State</p>
				<div id="idTargetSensor" class="statusBlock"></div>
			</div>
		</div>

		<div class="row">
			<div class="span3">
				<input id="btSetOnline" class="btn btn-success btn-large" type="button" value="Set Online">
			</div>
			<div class="span3">
				<input id="btSetOffline" class="btn btn-danger btn-large" type="button" value="Set Offline">
			</div>
			<div class="span3">
				<input id="btRefresh" class="btn btn-large" type="button" value="Refresh">
			</div>
		</div>
      </div>

	<div class="row">
		<div class="span12">
			<h2>Latest events</h2>	
		</div>
	</div>
	
	  
	  <div class="row">
        <div class="span2">
		  <input type="text" id="statusDateStart" class="input-small"/><input type="hidden" id="statusDateTSStart" />
		</div>
		<div class="span2">
		  <input type="text" id="statusDateEnd" class="input-small"/><input type="hidden" id="statusDateTSEnd" />
		</div>
		<div class="span2">
		    <div class="btn-group">
				<button id="btChangePeriod" class="btn">Change Period</button>
				<button class="btn dropdown-toggle" data-toggle="dropdown">
				<span class="caret"></span>
				</button>
				<ul class="dropdown-menu">
					<li><a href="#" id="btShowLast">Last 10 events</a></li>
					<li><a href="#" id="btShowLast24h">Last 24h</a></li>
					<li><a href="#" id="btShowLastWeek">Last Week</a></li>
					<li><a href="#" id="btShowLastMonth">Last Month</a></li>
					<li><a href="#" id="btShowLastYear">Last Year</a></li>
				</ul>
			</div>
		</div>
	  </div>

	<div class="row">
		<div class="span8">
		  <div id="idTargetTableHistory">
		  </div>
		</div>
	  </div>
	  
	  
      <hr>

      <footer>
        <p>© kProd.net 2012</p>
      </footer>

    </div>

    <script src="js/jquery-1.7.2.min.js"></script>
	<script src="js/jquery-ui-1.8.19.custom.min.js"></script>
    <script src="js/bootstrap/bootstrap-transition.js"></script>
    <script src="js/bootstrap/bootstrap-alert.js"></script>
    <script src="js/bootstrap/bootstrap-modal.js"></script>
    <script src="js/bootstrap/bootstrap-dropdown.js"></script>
    <script src="js/bootstrap/bootstrap-scrollspy.js"></script>
    <script src="js/bootstrap/bootstrap-tab.js"></script>
    <script src="js/bootstrap/bootstrap-tooltip.js"></script>
    <script src="js/bootstrap/bootstrap-popover.js"></script>
    <script src="js/bootstrap/bootstrap-button.js"></script>
    <script src="js/bootstrap/bootstrap-collapse.js"></script>
    <script src="js/bootstrap/bootstrap-carousel.js"></script>
    <script src="js/bootstrap/bootstrap-typeahead.js"></script>
	
<?php
	$strDateNow = time();
	$last24h = strtotime('-1 day', time());
	$lastWeek = strtotime('-1 week', time());
	$lastMonth = strtotime('-1 month', time());
	$lastYear = strtotime('-1 year', time());
?>
	
	<script type="text/javascript">
	var lastHistory = "last";
	function showPeriodMs(statusDateTSStart, statusDateTSEnd)
	{
		$.post("ajaxHistory.php", { statusDateTSStart: statusDateTSStart, statusDateTSEnd: statusDateTSEnd, ms: "true" },
			function(data) {
			$("#idTargetTableHistory").html(data);
		});	
	}
	
	function showPeriodToNow(statusDateTSStart)
	{
		$.post("ajaxHistory.php", { statusDateTSStart: statusDateTSStart},
			function(data) {
			$("#idTargetTableHistory").html(data);
		});	
	}
	
	function refresh()
	{
		$("#idTargetStatus").load("ajaxCurrentStatus.php");
		$("#idTargetSensor").load("ajaxSensorState.php");
		if(lastHistory == "last")
		{
			$("#btShowLast").trigger('click');
		}
		else if (lastHistory == "24h")
		{
			$("#btShowLast24h").trigger('click');
		}
		else if (lastHistory == "week")
		{
			$("#btShowLastWeek").trigger('click');
		}
		else if (lastHistory == "month")
		{
			$("#btShowLastMonth").trigger('click');
		}
		else if (lastHistory == "year")
		{
			$("#btShowLastYear").trigger('click');
		}
		else if (lastHistory == "custom")
		{
			$("#btChangePeriod").trigger('click');
		}
	}
	
	$(document).ready(function(){
		$("#statusDateStart").datepicker({
			altField: "#statusDateTSStart",
			altFormat: "@"
		});
		$("#statusDateEnd").datepicker({
			altField: "#statusDateTSEnd",
			altFormat: "@"
		});
		
		$("#btChangePeriod").click(function(){
			lastHistory = "custom";
			var statusDateTSStart = $("#statusDateTSStart").val();
			var statusDateTSEnd = $("#statusDateTSEnd").val();
			showPeriodMs(statusDateTSStart, statusDateTSEnd);
		});
		
		$("#btShowLast").click(function(){
			lastHistory = "last";
			$("#idTargetTableHistory").load("ajaxHistory.php");
		});
		
		$("#btShowLast24h").click(function(){
			var statusDateTSStart = <?php print $last24h;?>;
			//var statusDateTSEnd = <?php print $strDateNow;?>;
			lastHistory = "24h";
			showPeriodToNow(statusDateTSStart);
		});
		
		$("#btShowLastWeek").click(function(){
			var statusDateTSStart = <?php print $lastWeek;?>;
			//var statusDateTSEnd = <?php print $strDateNow;?>;
			lastHistory = "week";
			showPeriodToNow(statusDateTSStart);
		});
		$("#btShowLastMonth").click(function(){
			var statusDateTSStart = <?php print $lastMonth;?>;
			//var statusDateTSEnd = <?php print $strDateNow;?>;
			lastHistory = "month";
			showPeriodToNow(statusDateTSStart);
		});
		$("#btShowLastYear").click(function(){
			var statusDateTSStart = <?php print $lastYear;?>;
			//var statusDateTSEnd = <?php print $strDateNow;?>;
			lastHistory = "year";
			showPeriodToNow(statusDateTSStart);
		});
		
		$("#btRefresh").click(function(){
			refresh();
		});
	
		$("#btSetOnline").click(function(){
			$.post("ajaxCommand.php", { command: "setOnline"},
			function(data) {
				//alert("command "+data);
			});
		});
		$("#btSetOffline").click(function(){
			$.post("ajaxCommand.php", { command: "setOffline"},
			function(data) {
				//alert("command "+data);
			});
		});
		
		
		refresh();
		setInterval(refresh, 5000);
		
	});
	</script>

</body></html>
