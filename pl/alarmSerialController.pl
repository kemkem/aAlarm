#!/usr/bin/perl

#Modules
use File::Basename;
use Device::SerialPort;
use MIME::Lite;
use Time::HiRes qw(usleep);
use DBI;

#AAlarm Modules
use TimerLite;

my $pathConfigFile = $ENV{AALARM_PATH_FOLDER_CONFIG}."/aalarm.conf";

# Simple line parameters
# write logfile
my $logInFile = 0;
# diplay debug
my $debug = 0;
# display db debug
my $dbdebug = 0;
# init db table parameters
my $initDb = 0;
#verbosity level
my $verbose = 0;

foreach $argnum (0 .. $#ARGV) {
    my $parameter = $ARGV[$argnum];
    if ($parameter eq "help")
    {
        print "./alarmSerialController.pl [debug] [logfile]  [dbdebug] [initdb]\n";
        print "debug : Display debug messages\n";
        print "logfile : Log debug messages in log (path in config file)\n";
        print "dbdebug : Display / Log DB requests\n";
        print "initdb : Init db table parameters (ERASE db parameters ! Required at every config file change)\n";
        exit();
    }
    if ($parameter eq "logfile")
    {
        $logInFile = 1;
    }
    if ($parameter eq "debug")
    {
        $debug = 1;
    }
    if ($parameter eq "dbdebug")
    {
        $dbdebug = 1;
    }
    if ($parameter eq "verbose")
    {
        $verbose = 1;
    }
    if ($parameter eq "initdb")
    {
        $initDb = true;
    }
}

my $originalDebug = $debug;
my $originalDbDebug = $dbdebug;

my $initDbAfterLoadedParameters = 0;

my %hParameters = loadConfigFile($pathConfigFile);

#init db if necessary
if($initDb)
{
    $initDbAfterLoadedParameters = 1;
    debug("Reset table parameters");
    my $tableParameter = configFromFile("tableParameter");
    dbExecute("delete from $tableParameter");
    #reload from file to init db
    loadConfigFile($pathConfigFile);
}

#if($initDb)
#{
#    my $dbh = getDbConnection();
#    my $tableParameter = configFromFile("tableParameter");
#
#    dbExecute("delete from $tableParameter");
#    foreach my $key (keys %hParameters)
#    {
#        debug("InitDb key: $key, value: $hParameters{$key}");
#        initDbParameter($key);
#    }
#}

#Log
#my $pathLog = configFromFile("pathLog");

#Arduino Port Scan
my $portBase = config("portBase");
my $portNumMin = config("portNumMin");
my $portNumMax = config("portNumMax");
my $reconnectTimeoutSecs = config("reconnectTimeoutSecs");

#Services
my $enableZoneMinder = config("zoneMinderEnable");
my $enableMusicPlaylist = config("musicPlaylistEnable");
my $enableZoneMinderLastIntrusion = config("zoneMinderLastIntrusionEnable");

#Buzzer
my $enabledBuzzer = config("buzzerEnable");
#Siren
my $enabledSiren = config("sirenEnable");
my $useBuzzerAsSiren = config("buzzerAsSiren");

#Music service scripts
my $pathStartPlaylist = config("pathStartPlaylist");
my $pathStopPlaylist = config("pathStopPlaylist");

#Zoneminder service scripts
my $pathStartZM = config("pathStartZM");
my $pathStopZM = config("pathStopZM");
my $pathZmLast = config("pathZmLast");
my $pathZmLastTarget = config("pathZmLastTarget");

#Motion service scripts
my $pathStartMotion = config("pathStartMotion");
my $pathStopMotion = config("pathStopMotion");
my $pathStatusMotion = config("pathStatusMotion");

#Delays
my $delayOnlineTimed = config("delayOnlineTimed");
my $delayIntrusionWarning = config("delayIntrusionWarning");
my $delayIntrusionAlarm = config("delayIntrusionAlarm");
my $delayIntrusionWarningTimeout = config("delayIntrusionWarningTimeout");
my $delayIntrusionAlarmTimeout = config("delayIntrusionAlarmTimeout");

#USB config
my $rate = config("rate");
my $refreshMs = config("refreshMs");

#Alarm passwd
my $passwd = config("passwd");

#Sensors total
$sensorsNb = config("sensorsNb");

#Init

my $refresh = $refreshMs * 1000;

my $tOnlineTimed = -1;
my $tIntrusionWarning = -1;
my $tIntrusionAlarm = -1;

# 0 offline
# 1 timed
# 2 online
# 3 intrusion
# 4 warning
# 5 alarm
my $stateGlobalOffline = "offline";
my $stateGlobalTimed = "timed";
my $stateGlobalOnline = "online";
my $stateGlobalIntrusion = "intrusion";
my $stateGlobalWarning = "warning";
my $stateGlobalAlert = "alert";

my $nextCommand = "";

my @sensorsStates;
# 0 closed
# 1 open
my $stateSensorClosed = "closed";
my $stateSensorOpen = "open";

#my $timerNextId = 0;
#my %timers = ();

my $sendAlertMails = config("sendEmailAlerts");

#initial current state
my $globalState = $stateGlobalOffline;

debug("Started aAlarm");
debug("Delays :");
debug("DelayOnlineTimed : $delayOnlineTimed");
debug("DelayIntrusionWarning : $delayIntrusionWarning");
debug("DelayIntrusionAlarm : $delayIntrusionAlarm");
debug("DelayIntrusionWarningTimeout : $delayIntrusionWarningTimeout");
debug("DelayIntrusionAlarmTimeout : $delayIntrusionAlarmTimeout");

#update services status every 5 secs
TimerLite::setTimer(5, \&updateMusicPlaylistStatusInDB) if $enableMusicPlaylist;
TimerLite::setTimer(5, \&updateZMStatusInDB) if $enableZoneMinder;

my $port;

#send command to arduino
sub sendCommand
{
    my $pPort = shift;
    my $command = shift;
    #$pPort->write($command."\n");
    $nextCommand = $command;
}

while (1)
{
for(my $portNum = $portNumMin; $portNum <= $portNumMax; $portNum++)
{
	my $connectPort = $portBase.$portNum;
	debug("Trying to connect to $connectPort");
	if ($port = Device::SerialPort->new($connectPort))
	{
		debug("Connected");
		$port->databits(8);
		$port->baudrate($rate);
		$port->parity("none");
		$port->stopbits(1);

		#record global state init
		recordEventGlobal($globalState);

        debug("Waiting board for 'ready' response");
        my $response = "";
        while ($response eq "ready") 
        {
		    my $response = $port->lookfor();
        }

        debug("Set sensors nb to $sensorsNb");
        sendCommand($port, "setSensorsNb $sensorsNb");

		while (1)
        {
		    my $response = $port->lookfor();
		
		    if ($response) 
            {
		    	$nextCommand = "";
			    chop $response;
			    debug("Board Response [".$response."]");
		
			    #received sensors update				
			    if($response =~ /sensor(\d+):(.*)/)
			    {
				    my $sensorNb = $1 + 1;
				    my $sensorStatus = $2;
				    debug("Sensor $sensorNb status [$sensorStatus]");
			
				    if ($sensorStatus =~ /CLOSE$/)
				    {
					    $sensorsStates[$sensorNb] = $stateSensorClosed;
				    }
				    elsif ($sensorStatus =~ /OPEN$/)
				    {
					    $sensorsStates[$sensorNb] = $stateSensorOpen;
				    }

				    #record sensor event
				    recordEventSensor($sensorsStates[$sensorNb], $sensorNb);
			
				    #Manage alarms
				    if ($globalState eq $stateGlobalOnline)
				    {
					    if ($sensorsStates[$sensorNb] = 1)
					    {
                            intrusion();
					    }
				    }
			    }
		
			    #key '*' pressed
			    elsif($response =~ /keys:(.*)/)
			    {
				    my $keys = $1;
				    debug("Keys [$keys]");
			
				    #passwd entered
				    if($keys =~ /$passwd\*$/)
				    {
				
					    if($globalState eq $stateGlobalOffline)
					    {
						    setOnline();				
					    }
					    elsif($globalState ne $stateGlobalOffline)
					    {
						    setOffline();	
					    }
				    }
				    #passwd change
				    elsif($keys =~ /$passwd\#(\d+)\*$/)
				    {
					    debug("KeyPad Passwd changed to [$1]");
                        #TODO record in db
					    $passwd = $1;
				    }
			    }
			
	        } 
	        else 
	        {
		    usleep($refresh);
		    executeCommand();
		    $send = $nextCommand;
		    $port->write($send."\n");
	        }
	        TimerLite::runTimers();						
		}
		debug("Connection to board has been lost!");
        #TODO record in db
		#recordDisconnected();
	}
	else
	{
		debug("Cannot connect, retrying in $reconnectTimeoutSecs second...");
        #TODO record in db
		sleep($reconnectTimeoutSecs);
	}
}#for end
}#while end

# setOnline (from keypad or command) (state offline -> timed)
sub setOnline
{
	debug("SetOnline called");
    actionsSetOnline();

	$globalState = $stateGlobalTimed;
	#record global state change
	recordEventGlobal($globalState);
    #timer call ckbOnline
	$tOnlineTimed = TimerLite::setTimer($delayOnlineTimed, \&ckbOnline);
}

# setOffline (from keypad or command) (any state -> offline)
sub setOffline 
{
    debug("SetOffline called");
    actionsSetOffline();

	TimerLite::removeTimer($tOnlineTimed);
	TimerLite::removeTimer($tIntrusionWarning);
	TimerLite::removeTimer($tIntrusionAlarm);
	$tOnlineTimed = -1;
	$tIntrusionWarning = -1;
	$tIntrusionAlarm = -1;
	$globalState = $stateGlobalOffline;
	#record global state change
	recordEventGlobal($globalState);
}

# Intrusion (online -> intrusion)
sub intrusion() 
{
    debug("Intrusion alert !");
    actionsIntrusion();
	
    $tIntrusionWarning = TimerLite::setTimer($delayIntrusionWarning, \&ckbIntrusionWarning);
    $tIntrusionAlarm = TimerLite::setTimer($delayIntrusionAlarm, \&ckbIntrusionAlarm);
    $globalState = $stateGlobalIntrusion;
    #record global state change
    recordEventGlobal($globalState);
}

#
# Callbacks from Timers
#

# (timed -> online)
sub ckbOnline
{
    actionsOnline();

    debug("Callback Online");
	$globalState = $stateGlobalOnline;
	#record global state change
	recordEventGlobal($globalState);
	TimerLite::setTimer(2, \&ckbOnlineTimeout);
}

# (after timed -> online)
sub ckbOnlineTimeout
{
    debug("Callback OnlineTimeout");
    actionsOnlineTimeout();

}

# (intrusion -> warning)
sub ckbIntrusionWarning
{
    debug("Callback Warning");
    #actionsWarning();

	TimerLite::setTimer($delayIntrusionWarningTimeout, \&ckbIntrusionWarningTimeout);
	$globalState = $stateGlobalWarning;
	#record global state change
	my $idEvent = recordEventGlobal($globalState);
	actionsWarning($idEvent);
}

# (after intrusion -> warning)
sub ckbIntrusionWarningTimeout
{
    debug("Callback WarningTimeout");
    actionsWarningTimeout();

}

# (warning -> alarm)
sub ckbIntrusionAlarm
{
    debug("Callback Alarm");
    actionsAlarm();

	TimerLite::setTimer($delayIntrusionAlarmTimeout, \&ckbIntrusionAlarmTimeout);
	$globalState = $stateGlobalAlert;
	#record global state change
	recordEventGlobal($globalState);
}

# (after warning -> alarm)
sub ckbIntrusionAlarmTimeout
{
    debug("Callback AlarmTimeout");
    actionsAlarmTimeout();
    
}

#
# Actions (done on specific states or callbacks)
#

sub actionsSetOnline
{
    #start zm if enabled
	#shellExecute($pathStartZM) if $enableZoneMinder;
	shellExecute($pathStartMotion) if $enableZoneMinder;
    #$nextCommand = "setLedRed";
    sendCommand($port, "setLedRed");
}

sub actionsSetOffline
{
    #stop music if enabled
    shellExecute($pathStopPlaylist) if $enableMusicPlaylist;
    #stop Zoneminder if enabled (longer)
	#shellExecute($pathStopZM) if $enableZoneMinder;
	shellExecute($pathStopMotion) if $enableZoneMinder;
	#$nextCommand = "setLedGreen";
    sendCommand($port, "setLedGreen");
}

sub actionsOnline
{
    #start music if enabled
	shellExecute($pathStartPlaylist) if $enableMusicPlaylist;
	#$nextCommand = "setLedRedBuzzer";
    sendCommand($port, "setLedRedBuzzer") if ($enabledBuzzer);
    sendCommand($port, "setLedRed") if not ($enabledBuzzer);
}

sub actionsOnlineTimeout
{
   	#$nextCommand = "setLedRed";
    sendCommand($port, "setLedRed");
}

sub actionsIntrusion
{
	#my $idEvent = shift;
	
	#recordMotionEventPictures($idEvent);
    #stop music if enabled
    shellExecute($pathStopPlaylist) if $enableMusicPlaylist;
}

sub actionsIntrusionTimeout
{
}

sub actionsWarning
{
	my $idEvent = shift;
	
    sendMail("Intrusion Warning");
    #start zmlast script to copy last instrusion pictures
    #zmLast() if $enableZoneMinder && $enableZoneMinderLastIntrusion;
	
	#save motion event associated pictures
	recordMotionEventPictures($idEvent);
	
    sendCommand($port, "setLedRedBuzzer") if ($enabledBuzzer);
}

sub actionsWarningTimeout
{
    sendCommand($port, "setLedRed") if ($enabledBuzzer);
}

sub actionsAlarm
{
    sendMail("Intrusion Alarm");
    if($enabledSiren)
    {
        sendCommand($port, "setLedRedBuzzer") if ($useBuzzerAsSiren);
    }
}

sub actionsAlarmTimeout
{
    if($enabledSiren)
    {
        sendCommand($port, "setLedRed") if ($useBuzzerAsSiren);
    }
}

# call zmlast script (copy last intrusion pictures and record them in db)

sub zmLast
{
    my $tableZmIntrusion = configFromFile("tableZmIntrusion");
    my $tableZmIntrusionPicture = configFromFile("tableZmIntrusionPicture");

    debug("ZmLast : Get latest intrusion pictures");
    shellExecute($pathZmLast);

    #insert new zmintrusion
    my $idZmIntrusion = dbInsert("insert into $tableZmIntrusion (date) values (now())");

    open LIST, $pathZmLastTarget."/list" or die "Cannot open ".$pathZmLastTarget."/list"."\n";
    foreach (<LIST>)
    {
        chomp();
        my $filename = basename($_);
        print $filename."\n";
        
        #insert
        dbExecute("insert into $tableZmIntrusionPicture (zmIntrusion_id, path) values ($idZmIntrusion, '$filename')");

    }
    close LIST;
}

sub recordMotionEventPictures
{
	my $idEvent = shift;
	my $tableMotionPicture = configFromFile("tableMotionPicture");
	my $tableMotionEventPicture = configFromFile("tableMotionEventPicture");
	
	my $prepare = dbSelectFetch2("select p.id from $tableMotionPicture p order by p.time_stamp desc limit 0,20");
	while($result = $prepare->fetchrow_hashref())
	{
		#print "fetch pic ".$result->{id}."\n";
		dbInsert("insert into $tableMotionEventPicture (event_id, security_id) values ($idEvent, '".$result->{id}."')");
	}
}

#
# Query services status
#
sub queryZMStatus
{
    my $pathStatus = config("pathStatusZM");
    #debugOff();
    debug("Query ZM status, execute $pathStatus");
    #debugOn();
    my $status = `$pathStatus`;
    if ($status =~ /ZoneMinder is running/)
    {
        return 1;
    }
    return 0;
}

sub queryMotionStatus
{
    my $pathStatus = config("pathStatusMotion");
    #debugOff();
    debug("Query Motion status, execute $pathStatus");
    #debugOn();
    my $status = `$pathStatus`;
    if ($status =~ /Motion is running/)
    {
        return 1;
    }
    return 0;
}

sub queryMusicPlaylistStatus
{
    my $pathStatus = config("pathStatusMusicPlaylist");
    debug("Query Music Playlist status, execute $pathStatus");
    my $status = `$pathStatus`;
    if ($status =~ /Music playlist is running/)
    {
        return 1;
    }
    return 0;
}

sub updateZMStatusInDB
{
    my $state = "Stopped";
    #if(queryZMStatus())
	if(queryMotionStatus())
    {
        $state = "Running";
    }
	my $tableEvent = configFromFile("tableEvent");
	
   	my $idState = getIdRefState($state);
   	my $idSensor = getIdSensorByName("ZoneMinder");

    my $result = dbSelectFetch("select e.state_id as state_id from $tableEvent e where sensor_id=$idSensor order by e.id desc limit 0,1");
    my $lastStateId = -1;
	if ($result)
	{
		$lastStateId = $result->{state_id};
    }
    if($idState != $lastStateId)
    {
        debug("Record ZM  Status Event [$state]");
        dbExecute("insert into $tableEvent (date, sensor_id, state_id) values (now(), $idSensor, $idState)");
    }
    else
    {
        debug("No ZM Status change");
    }
    TimerLite::setTimer(5, \&updateZMStatusInDB);
}

sub updateMusicPlaylistStatusInDB
{
    my $state = "Stopped";
    if(queryMusicPlaylistStatus())
    {
        $state = "Running";
    }
	my $tableEvent = configFromFile("tableEvent");
	
   	my $idState = getIdRefState($state);
   	my $idSensor = getIdSensorByName("MusicPlaylist");

    my $result = dbSelectFetch("select e.state_id as state_id from $tableEvent e where sensor_id=$idSensor order by e.id desc limit 0,1");
    my $lastStateId = -1;
	if ($result)
	{
		$lastStateId = $result->{state_id};
    }
    if($idState != $lastStateId)
    {
        debug("Record MusicPlaylist Status Event [$state]");
        dbExecute("insert into $tableEvent (date, sensor_id, state_id) values (now(), $idSensor, $idState)");
    }
    else
    {
        debug("No MusicPlaylist Status change");
    }
    TimerLite::setTimer(5, \&updateMusicPlaylistStatusInDB);
}

#
# DB
#

# Record a global event in db
sub recordEventGlobal
{
	my $state = shift;
	my $tableEvent = configFromFile("tableEvent");
	
   	my $idState = getIdRefState($state);
   	my $idSensor = getIdSensorByName("Global");
    debug("Record Global Event [$state]");
    #dbExecute("insert into $tableEvent (date, sensor_id, state_id) values (now(), $idSensor, $idState)");
	return dbInsert("insert into $tableEvent (date, sensor_id, state_id) values (now(), $idSensor, $idState)");
}

# Record a sensor event in db
sub recordEventSensor
{
	my $sensorState = shift;
	my $sensorPin = shift;
    my $tableEvent = configFromFile("tableEvent");

   	my $idState = getIdRefState($sensorState);
   	my $idSensor = getIdSensor($sensorPin);
    debug("Record Sensor [$sensorPin] Event [$sensorState]");
    dbExecute("insert into $tableEvent (date, sensor_id, state_id) values (now(), $idSensor, $idState)");
}

# Execute command if any
sub executeCommand
{
	my $tableCommand = configFromFile("tableCommand");
	my $tableExecute = configFromFile("tableExecute");
	
    #TODO validate available commands

    my $result = dbSelectFetch("select c.command, e.id from $tableCommand c, $tableExecute e where e.completed = 0 and e.command_id = c.id ORDER BY e.id DESC LIMIT 0 , 1");
	if ($result)
	{
		my $command = $result->{command};
		my $idExecute = $result->{id};
        my $executed = 0;

        if($command =~ /setOnline/ && $globalState eq $stateGlobalOffline)
	    {
		    setOnline();
            $executed = 1;				
	    }
	    elsif($command =~ /setOffline/ && $globalState ne $stateGlobalOffline)
	    {
		    setOffline();
            $executed = 1;
	    }
        elsif($command =~ /startZoneMinder/)
	    {
	        shellExecute($pathStartMotion);
            $executed = 1;
	    }
        elsif($command =~ /stopZoneMinder/)
	    {
            shellExecute($pathStopMotion);
            $executed = 1;
	    }
		#elsif($command =~ /startMotion/)
	    #{
	    #    shellExecute($pathStartMotion);
        #    $executed = 1;
	    #}
        #elsif($command =~ /stopMotion/)
	    #{
        #    shellExecute($pathStopMotion);
        #    $executed = 1;
	    #}
        elsif($command =~ /startMusicPlaylist/)
	    {
            shellExecute($pathStartPlaylist);
            $executed = 1;
	    }
        elsif($command =~ /stopMusicPlaylist/)
	    {
            shellExecute($pathStopPlaylist);
            $executed = 1;
	    }

        #TODO : do something with executed = 0
        dbExecute("update $tableExecute e set e.completed=1 where e.id = $idExecute");
	}
}

# Get State Id by state name
sub getIdRefState
{
	my $state = shift;
	my $tableRefState = configFromFile("tableRefState");
	
    my $result = dbSelectFetch("select r.id from $tableRefState r where r.state = '$state'");
    if ($result)
	{
		my $idRefState = $result->{id};
		return $idRefState;
	}
}

# Get Sensor Id by sensor number
sub getIdSensor
{
	my $sensorNb = shift; #pin 0 is global
	my $tableSensor = configFromFile("tableSensor");

    my $result = dbSelectFetch("select s.id from $tableSensor s where s.pin = '$sensorNb'");
	if ($result)
	{
		my $idSensor = $result->{id};
		return $idSensor;
	}
}

# Get Sensor Id by sensor name
sub getIdSensorByName
{
	my $sensorName = shift;
	my $tableSensor = configFromFile("tableSensor");

    my $result = dbSelectFetch("select s.id from $tableSensor s where s.name = '$sensorName'");
	if ($result)
	{
		my $idSensor = $result->{id};
		return $idSensor;
	}
}

# 
# Get/Set Settings in db
#

sub getDbParameter
{
	my $key = shift;
	my $value = "UNK";
    my $dbh = getDbConnection();
    my $tableParameter = configFromFile("tableParameter");

    my $result = dbSelectFetch("select p.value from $tableParameter p where p.key = '".$key."'");
	if ($result)
	{
		my $value = $result->{value};
		return $value;
	}
}

sub setDbParameter
{
	my $key = shift;
    my $group = shift;
	my $value = shift;
    my $showInUi = shift;
    my $order = shift;
	my $dbh = getDbConnection();
    my $tableParameter = configFromFile("tableParameter");

    dbExecute("insert into $tableParameter (`key`, `group`, `value`, `showInUi`, `name`, `order`) values ('$key', '$group', '$value', '$showInUi', '$key', '$order')");
}

#
# Db Utils
#

sub getDbConnection
{
	my $dbUrl = configFromFile("dbUrl");
	my $dbLogin = configFromFile("dbLogin");
	my $dbPasswd = configFromFile("dbPasswd");
	my $dbh = DBI->connect($dbUrl, $dbLogin, $dbPasswd, {'RaiseError' => 1});
	return $dbh;
}

sub dbSelectFetch2
{
	my $req = shift;
    my $dbh = getDbConnection();

    debugDb("[Fetch] $req");
    my $prepare = $dbh->prepare($req) or die("[DB fetch] Error when preparing request\n");
    
    $prepare->execute() or die("[DB fetch] Error when execute request\n");
    #my $result = $prepare->fetchrow_hashref();
    return $prepare;
}

sub dbSelectFetch
{
    my $req = shift;
    my $dbh = getDbConnection();

    debugDb("[Fetch] $req");
    my $prepare = $dbh->prepare($req) or die("[DB fetch] Error when preparing request\n");
    
    $prepare->execute() or die("[DB fetch] Error when execute request\n");
    my $result = $prepare->fetchrow_hashref();
    return $result;
}

sub dbExecute
{
    my $req = shift;
    my $dbh = getDbConnection();

    debugDb("[Execute] $req");
    my $prepare = $dbh->do($req) or die("[DB execute] Error when execute request\n");
}

#insert and return last id
sub dbInsert
{
    my $req = shift;
	#$dbh->{ q{mysql_insertid}};
    my $dbh = getDbConnection();

    debugDb("[Insert] $req");
    my $prepare = $dbh->do($req) or die("[DB insert] Error when execute request\n");
    return $dbh->{ q{mysql_insertid}};
}

#
# Utils
#

# Send Email
sub sendMail
{
	$globalStateName = shift;
	if($sendAlertMails == 1)
	{
		$strBody = "\"$globalStateName\" has been triggered at ".getCurDate();
	
		debug("Sending mail \"$globalStateName\" to " + config("emailAlerts"));
		$msg = MIME::Lite->new(
		             From     => 'arduino@kprod.net',
		             To       => config("emailAlerts"),
		             Subject  => "AAlarm alert",
		             Data     => $strBody
		             );
		#$msg->attach(
		#	Encoding => 'base64',
		#	Type => 'image/jpg',
		#	Path     => "/home/kemkem/aAlarm/webDj/static/motion/01-20141123003758-00.jpg",
		#	Id => "image"
		#);
		$msg->send;
	}
}

sub shellExecute()
{
    my $cmd = shift;
    debug("Execute : ".$cmd);
    system($cmd);
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

sub debug
{
    my $msg = shift;
    if($debug)
    {
        print "[".getCurDate()."] $msg\n";
    }
    if($logInFile)
    {
        recordLog($msg);
    }
}

sub debugDb
{
    my $msg = shift;
    if($dbdebug)
    {
        print "[DB] $msg\n";
    }
    if($logInFile)
    {
        recordLog($msg);
    }
}

sub recordLog
{
	my $log = shift;

	open LOG, ">>".configFromFile("pathLog");
	print LOG getCurDate()." ".$log."\n";
	close LOG;
}

#get param from hash (loaded from config file)
sub configFromFile()
{
	my $key = shift;
	return $hParameters{$key};
}

#load config file in hash
sub loadConfigFile()
{
	$path = shift;
	my %hashParameters;
	open IN, $path;
    my $order = 0;
    my $lastGroup;
	while (<IN>)
	{
		chomp();
		next if /$\#/;
		if(/(.*?):(.*?):(.*?)\s*=\s*(.*)/)
		{
			#($key,$value) = split("=");
			#print $1."|".$2."|\n";
            my $group = $1;
            $order = 0 if $group ne $lastGroup;
            $lastGroup = $group;
            my $key = $2;
            my $showInUi = $3;
            my $value = $4;
            $order++;
            if($initDbAfterLoadedParameters)
            {
                debug("InitDb key $key, group $group, showInUi $showInUi, value $value, order $order");
                initDbParameter($key, $group, $showInUi, $order);
            }
            else
            {
			    $hashParameters{$key} = $value;
            }
		}
	}
	close IN;

	return %hashParameters;
}

# Init Db parameter from hash
sub initDbParameter
{
	my $key = shift;
    my $group = shift;
    my $showInUi = shift;
    my $order = shift;

	if(exists($hParameters{$key}))
	{
		my $value = $hParameters{$key};
		setDbParameter($key, $group, $value, $showInUi, $order);
		return $value;
	}
	else
	{
		die "$key parameter not exists in config file\n";
	}
}

# Return parameter from Db ; if not exists, from hash, or die
sub config
{
	my $key = shift;
	my $dbParameter = getDbParameter($key);
	if($dbParameter ne "UNK")
	{
		return $dbParameter;
	}
	else
	{
		if(exists($hParameters{$key}))
		{
			return $value;
		}
		else
		{
			die "$key parameter not exists in config file\n";
		}
	}
}




