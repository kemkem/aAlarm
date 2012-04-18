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
while (1) {
    # Poll to see if any data is coming in
    my $char = $port->lookfor();

    # If we get data, then print it
    # Send a number to the arduino
    if ($char) {
       print "State [" . $char . "]\n";
	if($char =~ /alarm triggered/ && $maildone == 0)
{
print "Send a mail\n";

$msg = MIME::Lite->new(
             From     => 'arduino@kprod.net',
             To       => 'marc@kprod.net',
             Subject  => "alert !",
             Data     => "Alarm has been triggered from your door!"
             );

    $msg->send;


$maildone = 1;
}
    } else {
        sleep(1);
        $count++;
        $port->write("$count\n");
        #print "polling: $count \n";
    }
}


