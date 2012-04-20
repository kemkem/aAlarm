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
			<div class="span4">
				<p>Current Status </p>
				<div id="idTargetStatus"></div>
			</div>
			<div class="span4">
				<p>Sensor State </p>
				<div id="idTargetSensor"></div>
			</div>
		</div>
      </div>
		
	<div class="row">
		<div class="span1">
			<input class="btn btn-success" type="button" value="Set Offline">
		</div>
		<div class="span1">
			<input class="btn btn-danger" type="button" value="Set Online">
		</div>
	</div>

      <!-- Example row of columns -->
      <div class="row">
        <div class="span5">
          <h2>Lastest status changes</h2>
		  <div id="idTargetTableStatus"></div>
          <p><a class="btn" href="#">Change period »</a></p>
        </div>
        <div class="span6">
          <h2>Lastest sensor activity</h2>
		  <div id="idTargetTableState"></div>
          <p><a class="btn" href="#">Change period »</a></p>
       </div>
      </div>

      <hr>

      <footer>
        <p>© kProd.net 2012</p>
      </footer>

    </div>

    <script src="js/jquery-1.7.2.min.js"></script>
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

	<script type="text/javascript">
	$(document).ready(function(){
		$("#idTargetStatus").load("ajaxCurrentStatus.php");
		$("#idTargetSensor").load("ajaxSensorState.php");
		$("#idTargetTableStatus").load("ajaxStatusHistory.php");
		$("#idTargetTableState").load("ajaxStateHistory.php");
		
	});
	</script>

</body></html>