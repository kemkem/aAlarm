#!/usr/bin/perl

use Device::SerialPort;
use MIME::Lite;

# Set up the serial port
# 19200, 81N on the USB ftdi driver
my $port = Device::SerialPort->new("/dev/ttyACM0") or die "cannot create port";
$port->databits(8);
$port->baudrate(19200);
$port->parity("none");
$port->stopbits(1);

my $count = 0;
my $maildone = 0;
my $currentState = "";
my $lastState = "";

while (1) {
    # Poll to see if any data is coming in
    my $char = $port->lookfor();

    # If we get data, then print it
    # Send a number to the arduino
    if ($char) {
       #print "State [" . $char . "]\n";
	if($char =~ /online/)
	{
		$currentState = "online";
	}
	elsif($char =~ /offline/)
	{
		$currentState = "offline";
	}
	elsif($char =~ /door has been opened/)
	{
		$currentState = "door has been opened";
	}
	elsif($char =~ /warning has been triggered/)
	{
		$currentState = "warning has been triggered";
	}
	elsif($char =~ /alarm triggered/)
	{
		$currentState = "alarm triggered";
	}

	if($lastState ne $currentState)
	{
		($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
		$mon = sprintf("%02d", $mon);
		$mday = sprintf("%02d", $mday);
		$year = sprintf("%02d", $year % 100);
		$hour = sprintf("%02d", $hour);
		$min = sprintf("%02d", $min);
		$sec = sprintf("%02d", $sec);
		#$year += 1900;
		$curDate = $mon."/".$mday."/".$year." ".$hour.":".$min.":".$sec;
		print $curDate." - changed to state ".$currentState."\n";
		open LOG, ">>/home/marc/alarm.log";
		print LOG $curDate." - changed to state ".$currentState."\n";
		close LOG;
	}
	$lastState = $currentState;
	
    } else {
	sleep(1);
	$count++;
	$port->write("$count\n");
	#print "polling: $count \n";
    }
}


