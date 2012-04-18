#!/usr/bin/perl

use DBI;

my $dbh = DBI->connect("DBI:mysql:database=aalarm;host=localhost", "aalarm", "wont6Oc`", {'RaiseError' => 1});

sub recordLevelChange
{
        my $status = shift;
        $dbh->do("insert into LevelStatus (idRefLevelStatus, date) values ($status, now())");
}

sub recordSensorChange
{
        my $state = shift;
        $dbh->do("insert into SensorState (idRefSensorState, date) values ($state, now())");
}

recordLevelChange(1);
recordLevelChange(2);
recordLevelChange(3);
recordLevelChange(4);

recordSensorChange(1);
recordSensorChange(2);
recordSensorChange(1);


#`id` int(11) NOT NULL AUTO_INCREMENT,
#`date` datetime NOT NULL,
#`idRefLevelStatus` tinyint(4) NOT NULL,
#(1, 'UNKNOWN'),
#(2, 'OFFLINE'),
#(3, 'ONLINE'),
#(4, 'ONLINE_INTRUSION'),
#(5, 'ONLINE_INTRUSION_WARNING'),
#(6, 'ONLINE_INTRUSION_ALARM');

  
#`id` int(11) NOT NULL AUTO_INCREMENT,
#`date` datetime NOT NULL,
#`idRefSensorState` tinyint(4) NOT NULL,
#(1, 'UNKNOWN'),
#(2, 'CLOSE'),
#(3, 'OPEN');  
