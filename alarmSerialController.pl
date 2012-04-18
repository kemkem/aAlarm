#!/usr/bin/perl

use Device::SerialPort;
use MIME::Lite;
use Time::HiRes qw(usleep);
use DBI;

my $port;
my $status = "OFFLINE";
my $sensor = "CLOSE";
my $lastStatus = "NONE";
my $ready = 0;
my $dbUrl = "DBI:mysql:database=aalarm;host=localhost";
my $dbLogin = "aalarm";
my $dbPasswd = "wont6Oc`";
my $statusLevel = 1;
my $sensorState = 1;
my $lastStatusLevel = 1;
my $lastSensorState = 1;
my $pathWebCommand = "/home/kemkem/AAlarm/web/command/command";
my $pathWebStatus = "/home/kemkem/AAlarm/web/state";
my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});

sub recordLevelChange
{
        my $status = shift;
        $dbh->do("insert into LevelStatus (idRefLevelStatus, date) values ($status, now())");
}

sub recordSensorChange
{
        my $state = shift;
        $dbh->do("insert into SensorState (idRefSensorState, date) values ($state, now())");
}


while (1)
{
	print ">Trying to connect...\n";
	if ($port = Device::SerialPort->new("/dev/ttyACM0"))
	{
		print ">Success\n";
		$port->databits(8);	
		$port->baudrate(9600);
		$port->parity("none");
		$port->stopbits(1);

		my $count = 0;
		my $connection = 5;

		while ($connection > 1) {
		    my $response = $port->lookfor();

		    if ($response) {
			chop $response;
			$connection++;
			print "R [".$response."]\n";
			if($response =~ /READY/)
			{
				$ready = 1;
			}
			else
			{
				$response =~ /STATUS:(.*)\|(.*)/;
				open FILE, ">".$pathWebStatus;
				print FILE $response;
				close FILE;
				$status = $1;
				$sensor = $2;
				$statusLevel = 1;
				$sensorState = 1;
				#record status in db
				if ($status =~ /OFFLINE$/)
				{
					$statusLevel = 1;
				}
				elsif ($status =~ /ONLINE$/)
				{
					$statusLevel = 2;
				}
				elsif ($status =~ /ONLINE_TIMED$/)
				{
					$statusLevel = 6;
				}
				elsif ($status =~ /INTRUSION$/)
				{
					$statusLevel = 3;
				}
				elsif ($status =~ /INTRUSION_WARNING/)
				{
					$statusLevel = 4;
				}
				elsif ($status =~ /INTRUSION_ALARM/)
				{
					$statusLevel = 5;
				}
				#record sensor in db
				if ($sensor =~ /CLOSE$/)
				{
					$sensorState = 2;
				}
				elsif ($sensor =~ /OPEN$/)
				{
					$sensorState = 3;
				}
				
				if ($lastStatusLevel != $statusLevel)
				{
					recordLevelChange($statusLevel);
				}
				if ($lastSensorState != $sensorState)
				{
					recordSensorChange($sensorState);
				}
				$lastStatusLevel = $statusLevel;
				$lastSensorState = $sensorState;
				
			}
		    } else {
			sleep(1);

			$nextCommand = "status";
			if(-f $pathWebCommand)
			{
				print "C [reading command]\n";
				open COMMAND_FILE, $pathWebCommand;
				while(<COMMAND_FILE>)
				{
					$nextCommand = "setOnline" if (/setOnline/);
					$nextCommand = "setOffline" if (/setOffline/);
				}
				close COMMAND_FILE;
				unlink $pathWebCommand or die "Error : cannot delete command file\n";
			}
			

			if ($lastStatus =~ /ONLINE$/ && $ready == 1)
			{
				$send = "setOnline";
				$lastStatus = "NONE";
			}
			elsif ($lastStatus =~ /ONLINE_TIMED$/ && $ready == 1)
			{
				$send = "setOnlineTimed";
				$lastStatus = "NONE";
			}
			elsif ($lastStatus =~ /INTRUSION$/ && $ready == 1)
			{
				$send = "setOnlineIntrusion";
				$lastStatus = "NONE";
			}
			elsif ($lastStatus =~ /INTRUSION_WARNING/ && $ready == 1)
			{
				$send = "setOnlineWarning";
				$lastStatus = "NONE";
			}
			elsif ($lastStatus =~ /INTRUSION_ALARM/ && $ready == 1)
			{
				$send = "setOnlineAlarm";
				$lastStatus = "NONE";
			}
			else
			{
				$send = $nextCommand;
			}
			$port->write($send."\n");
			print "S [".$send."]\n";
			$connection--;
		    }						
		}
		print "Connection has been lost!\n";
		print "last state was $status\n";
		$lastStatus = $status;
		$ready = 0;
	}
	else
	{
		print ">Cannot connect, retrying in 1 second...\n";
		sleep(1);
	}

}

