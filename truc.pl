use AnyEvent;
use EV;

my $w = AnyEvent->timer (after => 2, cb => sub {
      warn "timeout\n";
	exit;
   });

EV::loop;
print "!!!\n";
