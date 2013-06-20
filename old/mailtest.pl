#!/usr/bin/perl

use Device::SerialPort;
use MIME::Lite;

$sendAlertMails = 1;

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
		             ) or die "cannot send mail";
		$msg->send;
	}
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

sendMail("truc");
