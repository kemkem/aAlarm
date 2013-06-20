package TimerLite;

#
# Timer mini lib
#

sub setTimer
{
	my $delay = shift;
	my $function = shift;
	my $timer = time + $delay;
	#debug("New timer '$function' in $delay s (id $timerNextId)");
	$timers{$timerNextId} = $timer."|".$function;
	$timerNextId++;
	return $timerNextId - 1;
}

sub removeTimer
{
	$key = shift;
	debug("Remove timer $key");
	if($key>0)
	{
		delete $timers{$key}; 
	}
}

sub runTimers
{
	#print ">running timers\n";
	$curTime = time;
	my @newTimers;
	foreach my $key (keys %timers)
	{
		my $timerDef = $timers{$key};
		$timerDef =~ /(.*)\|(.*)/;

		my $timer = $1;
		my $function = $2;
		
		#print " >timer id ".$key." time ".$timer." function ".$function."\n";
		if($curTime >= $timer)
		{
			#print " >execute $function\n";
			delete $timers{$key}; 
			&{$function}();
		}
	}
	#@timers = @newTimers;
}

1;
