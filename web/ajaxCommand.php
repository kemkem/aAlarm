<?php
	require "db.php";
?>
<?php
	if(isset($_POST["command"]))
	{
		$command = $_POST["command"];
	}

	//if ($command)
	$reqInsertCommand = "
	insert into Command
	(date, completed, command)
	values (now(), 0, '$command')";

	$res = $db->exec($reqInsertCommand);
	print $res;
?>
