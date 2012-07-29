#!/usr/bin/perl

use Device::SerialPort;
use MIME::Lite;
use Time::HiRes qw(usleep);
use DBI;
use AnyEvent;

my $port;
my $dbUrl = "DBI:mysql:database=aalarm;host=localhost";
my $dbLogin = "aalarm";
my $dbPasswd = "wont6Oc`";
my $pathWebCommand = "/home/kemkem/AAlarm/web/command/command";
my $pathWebStatus = "/home/kemkem/AAlarm/web/state";
my $pathLog = "/home/kemkem/AAlarm/log";
my $port = "/dev/ttyACM0";

sub recordEvent
{
	my $status = shift;
	my $state = shift;
	my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
        $dbh->do("insert into Event (date, status, sensor) values (now(), $status, $state)");
}

sub recordFailure
{
	my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
        $dbh->do("insert into Event (date, status, sensor) values (now(), 1, 1)");
}

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

sub getCommand
{
	my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
        my $prepare = $dbh->prepare("
	select c.command as command
	from Commands c
	where c.completed  = 0
	ORDER BY c.id DESC
	LIMIT 0 , 1");
	$prepare->execute() or die("cannot execute request\n");
	my $result = $prepare->fetchrow_hashref();
	if ($result)
	{
		my $command = $result->{command};
		recordLog("C [".$command."]");

	        $dbh->do("update Commands set completed=1 where completed=0");

		return "setOnline" if ($command =~ /setOnline/);
		return "setOffline" if ($command =~ /setOffline/);
	}
	else
	{
		return "status";
	}
	
}
my $rate = 9600;
my $refreshMs = 200;

my $refresh = $refreshMs * 1000;

my $passwd = "4578";

my $currentState = 0;
my $nextCommand = "";



while (1)
{
	print ">Trying to connect...\n";
	if ($port = Device::SerialPort->new("/dev/ttyACM0"))
	{
		print ">Connected\n";
		$port->databits(8);	
		$port->baudrate(9600);
		$port->parity("none");
		$port->stopbits(1);

		my $count = 0;
		#my $connection = 5;

		while (1) {
		    my $response = $port->lookfor();

			
		    if ($response) {
		    	$nextCommand = "";
				chop $response;
				#$connection++;
				#print "R [".$response."]\n";
				
				if($response =~ /sensor(\d+):(.*)/)
				{
					my $sensorNb = $1;
					my $sensorStatus = $2;
					print("sensor $sensorNb [$sensorStatus]\n");
				}
				
				if($response =~ /keys:(.*)/)
				{
					my $keys = $1;
					print("keys [$keys]\n");
					
					if($keys =~ /$passwd\*$/)
					{
						
						if($currentState == 0)
						{
							$timestampOnlineTimed = time;
							print "online timed @ $timestampOnlineTimed\n";
							$currentState = 1;
							
							$nextCommand = "setLedRed";
						}
						else
						{	
							print "offline\n";
							$currentState = 0;
							$nextCommand = "setLedGreen";
						}
					}
					
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

			$send = $nextCommand;
			$port->write($send."\n");
			#print "S [".$send."]\n";
			#$connection--;
		    }						
		}
		print "Connection has been lost!\n";
		print "last state was $status\n";
	}
	else
	{
		print ">Cannot connect, retrying in $reconnectTimeout second...\n";
		sleep($reconnectTimeout);
	}

}

