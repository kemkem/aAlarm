#!/usr/bin/perl

use Device::SerialPort;
use MIME::Lite;
use Time::HiRes qw(usleep);

my $port;
my $status = "OFFLINE";
my $sensor = "CLOSE";
my $lastStatus = "NONE";
my $ready = 0;

while (1)
{
	print ">Trying to connect...\n";
	if ($port = Device::SerialPort->new("/dev/ttyACM0"))
	{
		print ">Success\n";
		$port->databits(8);	
		$port->baudrate(9600);
		#$port->baudrate(19200);
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
				open FILE, ">/home/kemkem/Work/arduino/web/state";
				print FILE $response;
				close FILE;
				$status = $1;
				$sensor = $2;
			}
		    } else {
			sleep(1);
			#usleep(50000);

			$nextCommand = "status";
			open COMMAND_FILE, "/home/kemkem/Work/arduino/web/command/command";
			while(<COMMAND_FILE>)
			{
				$nextCommand = "setOnline" if (/setOnline/);
			}
			close COMMAND_FILE;
			unlink "/home/kemkem/Work/arduino/web/command/command" or print "cannot delete\n";
			

			if ($lastStatus =~ /ONLINE/ && $ready == 1)
			{
				$send = "setOnline";
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

