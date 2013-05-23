#!/usr/bin/perl

#use Device::SerialPort;
#use MIME::Lite;
use Time::HiRes qw(usleep);
use DBI;

#Load parameters from file
#my %hParameters = loadConfigFile("/home/kemkem/work/arduinoAlarm/conf/aalarm.conf");
my %hParameters = loadConfigFile("/home/kemkem/Work/arduinoAlarm/conf/aalarm.conf");

#TODO optional : iterate over hParameters to load settings in db

#TODO remove these variables with direct access
#Db
#my $dbUrl = configFromFile("dbUrl");
#my $dbLogin = configFromFile("dbLogin");
#my $dbPasswd = configFromFile("dbPasswd");

#Tables
#my $tableCommand = configFromFile("tableCommand");
#my $tableEvent = configFromFile("tableEvent");
#my $tableExecute = configFromFile("tableExecute");
my $tableParameter = configFromFile("tableParameter");
my $tableRefSensorType = configFromFile("tableRefSensorType");
#my $tableRefState = configFromFile("tableRefState");
#my $tableSensor = configFromFile("tableSensor");

#Log
my $pathLog = config("pathLog");

#Arduino Port Scan
my $portBase = config("portBase");
my $portNumMin = config("portNumMin");
my $portNumMax = config("portNumMax");
my $reconnectTimeoutSecs = config("reconnectTimeoutSecs");

#Music service scripts
my $pathStartPlaylist = config("pathStartPlaylist");
my $pathStopPlaylist = config("pathStopPlaylist");

#Zoneminder service scripts
my $pathStartZM = config("pathStartZM");
my $pathStopZM = config("pathStopZM");
my $pathZmLast = config("pathZmLast");

#Delays
my $delayOnlineTimed = config("delayOnlineTimed");
my $delayIntrusionWarning = config("delayIntrusionWarning");
my $delayIntrusionAlarm = config("delayIntrusionAlarm");
my $delayIntrusionWarningTimeout = config("delayIntrusionWarningTimeout");
my $delayIntrusionAlarmTimeout = config("delayIntrusionAlarmTimeout");

#USB config
my $rate = config("rate");
my $refreshMs = config("refreshMs");

#Alarm passwd
my $passwd = config("passwd");

#Sensors total
$sensorsNb = 1;

#Init

my $refresh = $refreshMs * 1000;

my $tOnlineTimed = -1;
my $tIntrusionWarning = -1;
my $tIntrusionAlarm = -1;

# 0 offline
# 1 timed
# 2 online
# 3 intrusion
# 4 warning
# 5 alarm
my $stateGlobalOffline = "offline";
my $stateGlobalTimed = "timed";
my $stateGlobalOnline = "online";
my $stateGlobalIntrusion = "intrusion";
my $stateGlobalWarning = "warning";
my $stateGlobalAlert = "alert";

my $nextCommand = "";

my @sensorsStates;
# 0 closed
# 1 open
my $stateSensorClosed = "closed";
my $stateSensorOpen = "open";

#my @timers;
my $timerNextId = 0;
my %timers = ();

my $sendAlertMails = 1;

#TODO wont be necessary anymore
#init sensors
#dbSensorInit();

#recordDisconnected();
#recordEventSensor("closed", 1);

#getCommand();
#recordEventGlobal($stateGlobalAlert);
#recordEventSensor($stateSensorOpen, 1);

#initial current state
my $globalState = $stateGlobalOffline;

exit;

print "started aAlarm\n";
print "delays :\n";
print "delayOnlineTimed : $delayOnlineTimed\n";
print "delayIntrusionWarning : $delayIntrusionWarning\n";
print "delayIntrusionAlarm : $delayIntrusionAlarm\n";
print "delayIntrusionWarningTimeout : $delayIntrusionWarningTimeout\n";
print "delayIntrusionAlarmTimeout : $delayIntrusionAlarmTimeout\n";

while (1)
{
for(my $portNum = $portNumMin; $portNum <= $portNumMax; $portNum++)
{
	my $connectPort = $portBase.$portNum;
	print ">Trying to connect to $connectPort\n";
	#if ($port = Device::SerialPort->new("/dev/ttyACM0"))
	if (my $port = Device::SerialPort->new($connectPort))
	{
		print ">Connected\n";
		$port->databits(8);
		$port->baudrate($rate);
		$port->parity("none");
		$port->stopbits(1);

		#record global state init
		recordEventGlobal($globalState);


		my $count = 0;
		#my $connection = 5;

		while (1) {
		    my $response = $port->lookfor();
		
		    if ($response) {
		    	$nextCommand = "";
			chop $response;
			#$connection++;
			print "R [".$response."]\n";
		
			#received sensors update				
			if($response =~ /sensor(\d+):(.*)/)
			{
				my $sensorNb = $1 + 1;
				my $sensorStatus = $2;
				print("sensor $sensorNb [$sensorStatus]\n");
			
				if ($sensorStatus =~ /CLOSE$/)
				{
					#$sensorsStates[$sensorNb] = 0;
					$sensorsStates[$sensorNb] = $stateSensorClosed;
				}
				elsif ($sensorStatus =~ /OPEN$/)
				{
					#$sensorsStates[$sensorNb] = 1;
					$sensorsStates[$sensorNb] = $stateSensorOpen;
				}

				#record sensor event
				recordEventSensor($sensorsStates[$sensorNb], $sensorNb);
			
				#Manage alarms
				if ($globalState eq $stateGlobalOnline)
				{
					if ($sensorsStates[$sensorNb] = 1)
					{
						print "[!]intrusion alert !\n";
						$tIntrusionWarning = setTimer($delayIntrusionWarning, "ckbIntrusionWarning");
						$tIntrusionAlarm = setTimer($delayIntrusionAlarm, "ckbIntrusionAlarm");
						$globalState = $stateGlobalIntrusion;
						#record global state change
						recordEventGlobal($globalState);
						system($pathStopPlaylist);
					}
				}
			}
		
			#key '*' pressed
			elsif($response =~ /keys:(.*)/)
			{
				my $keys = $1;
				print("keys [$keys]\n");
			
				#passwd entered
				if($keys =~ /$passwd\*$/)
				{
				
					if($globalState eq $stateGlobalOffline)
					{
						setOnline();				
					}
					elsif($globalState ne $stateGlobalOffline)
					{
						setOffline();	
					}
				}
				#passwd change
				elsif($keys =~ /$passwd\#(\d+)\*$/)
				{
					print "pwd changed to $1\n";
					$passwd = $1;
				}
			}
			
			
			
		    } 
		    else 
		    {
			usleep($refresh);
			
			getCommand();
						
			$send = $nextCommand;
			$port->write($send."\n");
			#print "S [".$send."]\n";
			#$connection--;
		    }
		    runTimers();						
		}
		print "Connection has been lost!\n";
		#print "last state was $status\n";
		recordDisconnected();
	}
	else
	{
		print ">Cannot connect, retrying in $reconnectTimeoutSecs second...\n";
		sleep($reconnectTimeoutSecs);
	}
}#for
}#while

#sub sendMail
#{
#	$globalStateName = shift;
#	if($sendAlertMails == 1)
#	{
#		$strBody = "\"$globalStateName\" has been triggered at ".getCurDate();
#	
#		print "> Sending mail \"$globalStateName\"\n";
#		$msg = MIME::Lite->new(
#		             From     => 'arduino@kprod.net',
#		             To       => config("emailAlerts"),
#		             Subject  => "AAlarm alert",
#		             Data     => $strBody
#		             );
#		$msg->send;
#	}
#}

sub setOnline
{
	print "[!]online timed\n";
	$globalState = $stateGlobalOnline;
	#record global state change
	recordEventGlobal($globalState);
	$tOnlineTimed = setTimer($delayOnlineTimed, "ckbOnline");
	system($pathStartZM);
}

sub setOffline
{
	removeTimer($tOnlineTimed);
	removeTimer($tIntrusionWarning);
	removeTimer($tIntrusionAlarm);
	$tOnlineTimed = -1;
	$tIntrusionWarning = -1;
	$tIntrusionAlarm = -1;
	print "[!]offline\n";
	$globalState = $stateGlobalOffline;
	#record global state change
	recordEventGlobal($globalState);
	system($pathStopZM);
	$nextCommand = "setLedGreen";
}

#
# timers callbacks
#
sub ckbOnline
{
	print "  >function online\n";
	$globalState = $stateGlobalOnline;
	#record global state change
	recordEventGlobal($globalState);
	setTimer(2, "ckbOnlineTimeout");
	system($pathStartPlaylist);
	$nextCommand = "setLedGreenBuzzer";
}

sub ckbOnlineTimeout
{
	print "  >function onlineTimeout\n";
	$nextCommand = "setLedRed";
}

sub ckbIntrusionWarning
{
	print "  >function ckbIntrusionWarning\n";
	setTimer($delayIntrusionWarningTimeout, "ckbIntrusionWarningTimeout");
	$globalState = $stateGlobalWarning;
	#record global state change
	recordEventGlobal($globalState);
	sendMail("Intrusion Warning");
	system($pathZmLast);
}

sub ckbIntrusionWarningTimeout
{
	print "  >function ckbIntrusionWarningTimeout\n";
}

sub ckbIntrusionAlarm
{
	print "  >function ckbIntrusionAlarm\n";
	setTimer($delayIntrusionAlarmTimeout, "ckbIntrusionAlarmTimeout");
	$globalState = $stateGlobalAlert;
	#record global state change
	recordEventGlobal($globalState);
	sendMail("Intrusion Alarm");
}

sub ckbIntrusionAlarmTimeout
{
	print "  >function ckbIntrusionAlarmTimeout\n";
}

#
# DB
#

#TODO rename to InitEvent ?
#sub recordDisconnected
#{
#	my $dbh = getDbConnection();
#   	#$dbh->do("insert into Event (date, stateType, sensorId, state) values (now(), 0, 0, 101)");
#	#$dbh->do("insert into Event (date, stateType, sensorId, state) values (now(), 1, 1, 101)");
#	recordEventGlobal("offline");
#	#TODO init sensors ?
#}

#TODO remove this
#sub dbSensorInit
#{
#	my $dbh = getDbConnection();
#	$dbh->do("delete from Sensor");
#   	$dbh->do("insert into Sensor (id, name) values (1, 'Door sensor')");
#}

sub getIdRefState
{
	my $state = shift;
	my $dbh = getDbConnection();
	my $tableRefState = configFromFile("tableRefState");
	
	my $prepare = $dbh->prepare("select r.id from $tableRefState r where r.state = '$state'");
	$prepare->execute() or die("cannot execute request\n");
	my $result = $prepare->fetchrow_hashref();
	if ($result)
	{
		my $idRefState = $result->{id};
        print "idRefState $idRefState\n";
		return $idRefState;
	}
}

sub getIdSensor
{
	my $sensorPin = shift; #pin 0 is global
	my $dbh = getDbConnection();
	my $tableSensor = configFromFile("tableSensor");

	my $prepare = $dbh->prepare("select s.id from $tableSensor s where s.pin = '$sensorPin'");
	$prepare->execute() or die("cannot execute request\n");
	my $result = $prepare->fetchrow_hashref();
	if ($result)
	{
		my $idSensor = $result->{id};
		return $idSensor;
	}
}

sub recordEventGlobal
{
	my $state = shift;
	my $dbh = getDbConnection();
	my $tableEvent = configFromFile("tableEvent");
	
   	my $idState = getIdRefState($state);
    print "idState $idState\n";
   	my $idSensor = getIdSensor(0);
    print "(global) insert into $tableEvent (date, sensor_id, state_id) values (now(), $idSensor, $idState)\n";
   	$dbh->do("insert into $tableEvent (date, sensor_id, state_id) values (now(), $idSensor, $idState)");
}

sub recordEventSensor
{
	my $sensorState = shift;
	my $sensorPin = shift;
   	my $dbh = getDbConnection();
    my $tableEvent = configFromFile("tableEvent");

   	#$eventId = $dbh->do("insert into Event (date, stateType, sensorId, state) values (now(), 1, $sensorId, $sensorState)");
   	my $idState = getIdRefState($sensorState);
   	my $idSensor = getIdSensor($sensorPin);
    print "insert into $tableEvent (date, sensor_id, state_id) values (now(), $idSensor, $idState)\n";
   	$dbh->do("insert into $tableEvent (date, sensor_id, state_id) values (now(), $idSensor, $idState)");
}

#sub recordFailure
#{
#	my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
#        $dbh->do("insert into Event (date, status, sensor) values (now(), 1, 1)");
#}


#TODO rename to execute ?
sub getCommand
{
	my $dbh = getDbConnection();
	my $tableCommand = configFromFile("tableCommand");
	my $tableExecute = configFromFile("tableExecute");
	
    #my $prepare = $dbh->prepare("select c.command as command from Command c where c.completed  = 0 ORDER BY c.id DESC LIMIT 0 , 1");
    #TODO foreign key name
    my $prepare = $dbh->prepare("select c.command, e.id from $tableCommand c, $tableExecute e where e.completed = 0 and e.command_id = c.id ORDER BY e.id DESC LIMIT 0 , 1");
	$prepare->execute() or die("cannot execute request\n");
	my $result = $prepare->fetchrow_hashref();
	if ($result)
	{
		my $command = $result->{command};
		my $idExecute = $result->{id};
		#recordLog("C [".$command."]");

		#TODO complete when called command has been executed
	    $dbh->do("update $tableExecute e set e.completed=1 where e.id = $idExecute");

		setOnline() if ($command =~ /setOnline/);
		setOffline() if ($command =~ /setOffline/);
	}
	
}

sub getDbConnection
{
	my $dbUrl = configFromFile("dbUrl");
	my $dbLogin = configFromFile("dbLogin");
	my $dbPasswd = configFromFile("dbPasswd");
		
	my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
	return $dbh;
}

#
# Timer
#

sub setTimer
{
	my $delay = shift;
	my $function = shift;
	my $timer = time + $delay;
	print ">new timer id $timerNextId in $delay s\n";
	$timers{$timerNextId} = $timer."|".$function;
	$timerNextId++;
	return $timerNextId - 1;
}

sub removeTimer
{
	$key = shift;
	print ">remove timer $key\n";
	if($key>0)
	{
		delete $timers{$key}; 
	}
}

sub runTimers
{
	#print ">running timers\n";
	$curTime = time;
	my @newTimers;
	foreach my $key (keys %timers)
	{
		my $timerDef = $timers{$key};
		$timerDef =~ /(.*)\|(.*)/;

		my $timer = $1;
		my $function = $2;
		
		#print " >timer id ".$key." time ".$timer." function ".$function."\n";
		if($curTime >= $timer)
		{
			#print " >execute $function\n";
			delete $timers{$key}; 
			&{$function}();
		}
	}
	#@timers = @newTimers;
}

#
# Utils
#
sub getCurDate
{
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$mon = sprintf("%02d", $mon);
	$mday = sprintf("%02d", $mday);
	$year = sprintf("%02d", $year % 100);
	$hour = sprintf("%02d", $hour);
	$min = sprintf("%02d", $min);
	$sec = sprintf("%02d", $sec);
	#$year += 1900;
	return $mon."/".$mday."/".$year." ".$hour.":".$min.":".$sec;
}

sub recordLog
{
	my $log = shift;
	open LOG, ">>".$pathLog;
	print LOG getCurDate()." ".$log."\n";
	close LOG;
}

#get param from config file
sub configFromFile()
{
	my $key = shift;
	return $hParameters{$key};
}

#load config file in hash
sub loadConfigFile()
{
	$path = shift;
	my %hashParameters;
	open IN, $path;
	while (<IN>)
	{
		chomp();
		next if /$\#/;
		if(/(.*?)\s*=\s*(.*)/)
		{
			#($key,$value) = split("=");
			#print $1."|".$2."|\n";
			$hashParameters{$1} = $2;
		}
	}
	close IN;

	return %hashParameters;
}

#get settings by key
sub config()
{
	my $key = shift;
	my $dbParameter = getDbParameter($key);
	if($dbParameter ne "UNK")
	{
		return $dbParameter;
	}
	else
	{
		if(exists($hParameters{$key}))
		{
			my $value = $hParameters{$key};
			setDbParameter($key, $value);
			return $value;
		}
		else
		{
			die "$key parameter not exists in config file\n";
		}
	}
}


# 
# Get/Set Settings in db
# not exist in db -> put in db
# if exist in db -> get from db
#

sub getDbParameter
{
	my $key = shift;
	my $value = "UNK";
    my $dbh = getDbConnection();
	#my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
    my $prepare = $dbh->prepare("select p.value from " . $tableParameter . " p where p.key = '".$key."'");
	$prepare->execute() or die("cannot execute request\n");
	my $result = $prepare->fetchrow_hashref();
	if ($result)
	{
		$value = $result->{value};
	}
	return $value;
}

sub setDbParameter
{
	my $key = shift;
	my $value = shift;
	my $dbh = getDbConnection();
	$dbh->do("insert into " . $tableParameter . " (`key`, `value`) values ('".$key."', '".$value."')");
}
