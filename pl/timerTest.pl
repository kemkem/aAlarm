#!/usr/bin/perl

use TimerLite;

my $toremove=-1;

sub callback1
{
    print "callback1\n";
    TimerLite::removeTimer($toremove);
}

sub callback2
{
    print "callback2\n";
}

sub callback3
{
    print "callback3\n";
}

TimerLite::setTimer(2, \&callback1);
$toremove = TimerLite::setTimer(5, \&callback2);
TimerLite::setTimer(7, \&callback3);

$i = 0;
while(1)
{  
    print "$i\n";
    $i++;
    TimerLite::runTimers();
    sleep(1);
}
