#!/usr/bin/perl

use Device::SerialPort;
use MIME::Lite;
use Time::HiRes qw(usleep);

# Set up the serial port
# 19200, 81N on the USB ftdi driver
my $port = Device::SerialPort->new("/dev/ttyACM0") or die "cannot create port";
$port->databits(8);
#$port->baudrate(19200);
$port->baudrate(9600);
$port->parity("none");
$port->stopbits(1);

my $count = 0;
my $maildone = 0;
my $currentState = "";
my $lastState = "";

while (1) {
    # Poll to see if any data is coming in
    my $response = $port->lookfor();

    # If we get data, then print it
    # Send a number to the arduino
    if ($response) {
	chop $response;
       print "R [" . $response . "]\n";

	
    } else {
	sleep(1);
	#usleep(50000);
	if ($count == 0)
	{
		$count = 1;
		$send = "LEDOn";
	}
	elsif ($count == 1)
	{
		$count = 2;
		$send = "STATUS";
	}
	else
	{
		$count = 0;
		$send = "LEDOff";
	}
	$port->write($send."\n");
	print "S [".$send."]\n";
    }
}


