#!/usr/bin/perl

use Device::SerialPort;
use MIME::Lite;
use Time::HiRes qw(usleep);
use DBI;

my $dbUrl = "DBI:mysql:database=aalarm;host=localhost";
my $dbLogin = "aalarm";
my $dbPasswd = "wont6Oc";
my $pathWebCommand = "/home/kemkem/AAlarm/web/command/command";
my $pathWebStatus = "/home/kemkem/AAlarm/web/state";
my $pathLog = "/home/kemkem/AAlarm/log";
my $portBase = "/dev/ttyACM";
my $portNumMin = 0;
my $portNumMax = 5;
#my $portNum = $portsScanMin;
my $reconnectTimeoutSecs = 5;

my $pathStartPlaylist = "/home/kemkem/aalarm/sh/startPlaylist.sh &";
my $pathStopPlaylist = "/home/kemkem/aalarm/sh/stopPlaylist.sh &";

my $tOnlineTimed;
my $tIntrusionWarning;
my $tIntrusionAlarm;

my $rate = 9600;
my $refreshMs = 200;

my $refresh = $refreshMs * 1000;

my $passwd = "4578";

my $globalState = 0;
my $nextCommand = "";

my @sensorsStates;

#my @timers;
my $timerNextId = 0;
my %timers = ();

my $useDb = 1;
my $sendAlertMails = 1;

#init sensors
dbSensorInit();

recordDisconnected();

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
			
				#my $sensorState;
				if ($sensorStatus =~ /CLOSE$/)
				{
					$sensorsStates[$sensorNb] = 0;
				}
				elsif ($sensorStatus =~ /OPEN$/)
				{
					$sensorsStates[$sensorNb] = 1;
				}
				#record sensor event
				recordEventSensor($sensorNb, $sensorsStates[$sensorNb]);
			
				#Manage alarms
				if ($globalState == 2)
				{
					if ($sensorsStates[$sensorNb] = 1)
					{
						print "[!]intrusion alert !\n";
						$tIntrusionWarning = setTimer(8, "ckbIntrusionWarning");
						$tIntrusionAlarm = setTimer(16, "ckbIntrusionAlarm");
						$globalState = 3;
						#record global state change
						#recordEvent($globalState, $sensorsStates[1]);
						recordEventGlobal($globalState);
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
				
					if($globalState == 0)
					{
						setOnline();				
					}
					elsif($globalState >= 1)
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

sub sendMail
{
	$globalStateName = shift;
	if($sendAlertMails == 1)
	{
		$strBody = "\"$globalStateName\" has been triggered at ".getCurDate();
	
		print "> Sending mail \"$globalStateName\"\n";
		$msg = MIME::Lite->new(
		             From     => 'arduino@kprod.net',
		             To       => 'marc@kprod.net',
		             Subject  => "AAlarm alert",
		             Data     => $strBody
		             );
		$msg->send;
	}
}

sub setOnline
{
	print "[!]online timed\n";
	$globalState = 1;
	#record global state change
	recordEventGlobal($globalState);
	$tOnlineTimed = setTimer(5, "ckbOnline");
}

sub setOffline
{
	removeTimer($tOnlineTimed);
	print "[!]offline\n";
	$globalState = 0;
	#record global state change
	recordEventGlobal($globalState);
	system($pathStopPlaylist);
	$nextCommand = "setLedGreen";
}

#
# timers callbacks
#
sub ckbOnline
{
	print "  >function online\n";
	$globalState = 2;
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
	setTimer(2, "ckbIntrusionWarningTimeout");
	$globalState = 4;
	#record global state change
	recordEventGlobal($globalState);
	sendMail("Intrusion Warning");
}

sub ckbIntrusionWarningTimeout
{
	print "  >function ckbIntrusionWarningTimeout\n";
}

sub ckbIntrusionAlarm
{
	print "  >function ckbIntrusionAlarm\n";
	setTimer(2, "ckbIntrusionAlarmTimeout");
	$globalState = 5;
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

sub recordDisconnected
{
	if ($useDb)
	{
		my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
	   	$dbh->do("insert into Event (date, stateType, sensorId, state) values (now(), 0, 0, 101)");
		$dbh->do("insert into Event (date, stateType, sensorId, state) values (now(), 1, 1, 101)");
	}
}

sub dbSensorInit
{
	if ($useDb)
	{
		my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
		$dbh->do("delete from Sensor");
	   	$dbh->do("insert into Sensor (id, name) values (1, 'Door sensor')");
	}
}

sub recordEventGlobal
{
	my $state = shift;
	
	if ($useDb)
	{
		my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
	   	$dbh->do("insert into Event (date, stateType, sensorId, state) values (now(), 0, 0, $state)");
	}
	else
	{
		print "insert into Event (date, stateType, sensorId, state) values (now(), 0, 0, $state)\n";
	}
}

sub recordEventSensor
{
	my $sensorId = shift;
	my $sensorState = shift;

	if ($useDb)
	{
		my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
	   	$eventId = $dbh->do("insert into Event (date, stateType, sensorId, state) values (now(), 1, $sensorId, $sensorState)");
	}
	else
	{
		print "insert into Event (date, stateType, sensorId, state) values (now(), 1, $sensorId, $sensorState)\n";
	}
}

#sub recordFailure
#{
#	my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
#        $dbh->do("insert into Event (date, status, sensor) values (now(), 1, 1)");
#}


sub getCommand
{
	my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
        my $prepare = $dbh->prepare("select c.command as command from Command c where c.completed  = 0 ORDER BY c.id DESC LIMIT 0 , 1");
	$prepare->execute() or die("cannot execute request\n");
	my $result = $prepare->fetchrow_hashref();
	if ($result)
	{
		my $command = $result->{command};
		#recordLog("C [".$command."]");

	    $dbh->do("update Command set completed=1 where completed=0");

		setOnline() if ($command =~ /setOnline/);
		setOffline() if ($command =~ /setOffline/);
	}
	
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
	delete $timers{$key}; 
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

