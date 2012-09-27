#!/usr/bin/perl

use AnyEvent;
use EV;

while(1)
{
	my $c = 0;
	my $cv = AnyEvent->condvar;
	my $ev1 = AnyEvent->timer(after => 0.1, interval => 0.1, cb => sub { 

		print "ev1!\n";
		if($c > 5)
		{
			$cv->send;
		}
		$c++;

	});



	$cv->recv;
	print "loopin\n"	;
}
print "end\n";
exit;
