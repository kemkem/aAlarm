#!/usr/bin/perl

use Device::SerialPort;
use MIME::Lite;
use Time::HiRes qw(usleep);
use DBI;

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





while (1)
{
	print ">Trying to connect...\n";
	if ($port = Device::SerialPort->new("/dev/ttyACM0"))
	{
		print ">Success";
		$port->databits(8);	
		$port->baudrate(9600);
		$port->parity("none");
		$port->stopbits(1);

		my $count = 0;
		#my $connection = 5;

		while (1) {
		    my $response = $port->lookfor();

		    if ($response) {
				chop $response;
				#$connection++;
				print "R [".$response."]\n";
				
			} 
		    else 
		    {
			usleep($refresh);

			$nextCommand = "getStatus";#getCommand();

			$send = $nextCommand;
			$port->write($send."\n");
			#print "S [".$send."]\n";
			#$connection--;
		    }						
		}
		print "Connection has been lost!\n";
		print "last state was $status\n";
		#recordFailure();
		$statusLevel = 1;
		$sensorState = 1;
		$lastStatusLevel = 1;
		$lastSensorState = 1;
		#$status = "UNK";
		#$sensor = "UNK";
		$lastStatus = $status;
		$ready = 0;
	}
	else
	{
		print ">Cannot connect, retrying in $reconnectTimeout second...\n";
		sleep($reconnectTimeout);
	}

}



exit;
while (1)
{
	print ">Trying to connect...\n";
	if ($port = Device::SerialPort->new($port))
	{
		print ">Success\n";
		$port->databits(8);	
		$port->baudrate($rate);
		$port->parity("none");
		$port->stopbits(1);

		my $count = 0;
		my $connection = 5;

		while ($connection > 1) {
		    my $response = $port->lookfor();

		    if ($response) {
				chop $response;
				#$connection++;
				print "R [".$response."]\n";
				#$response =~ /(.*)\|(.*)/;
				#my $keys = $1;
				#my $sensors = $2;
				#print "keys [$keys] sensors [$sensors]\n";
		    }
			usleep($refresh);
			
			$send = "getStatus";
			$port->write($send."\n");
			print "send $send\n";
			#$connection--;
		    						
		}
	}
	else
	{
		print ">Cannot connect, retrying in $reconnectTimeout second...\n";
		sleep($reconnectTimeout);
	}

}