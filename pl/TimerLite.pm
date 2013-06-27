package TimerLite;

#
# Timer mini lib
#

my $timerNextId = 0;
my %timers = ();

sub setTimer
{
	my $delay = shift;
	my $function = shift;
	my $timer = time + $delay;

	#print "New timer '$function' in $delay s (id $timerNextId)\n";
    $timersFunctions{$timerNextId} = $function;
    $timersTimer{$timerNextId} = $timer;
	$timerNextId++;
	return $timerNextId - 1;
}

sub removeTimer
{
	$key = shift;
    delete $timersFunctions{$key}; 
    delete $timersTimer{$key};
}

sub runTimers
{
	$curTime = time;
	foreach my $key (keys %timersTimer)
	{
		my $timer = $timersTimer{$key};
		my $function = $timersFunctions{$key};
		
		#print " >timer id ".$key." time ".$timer." function ".$function."\n";
		if($curTime >= $timer)
		{
            removeTimer($key);
            $function->();
		}
	}
}

1;
