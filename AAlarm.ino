#include <Wire.h>
#include <i2ckeypadMod.h>
#include <Password.h>
#include <SimpleTimer.h>
#include <SoftwareSerial.h>

#define ROWS 4
#define COLS 3

#define I2Ck 0x20
#define aLedRed 0xA0
#define aLedGreen 0x90
#define aBuzz 0xC0

//TEST VALUES

#define timeout2Warning 4000
#define timeout2Siren 8000
#define timeout2WarningStop 1000
#define timeout2SirenStop 5000
#define timeout2Online 1000
#define timeout2OnlineWarningStop 1000

/*
#define timeout2Warning             20000
#define timeout2Siren               45000
#define timeout2WarningStop         4000
#define timeout2SirenStop           60000
#define timeout2Online              20000
#define timeout2OnlineWarningStop   3000
*/

#define CMD_SET_ONLINE "setOnline"
#define CMD_SET_OFFLINE "setOffline"
#define CMD_SET_WARNING "setWarning"
#define CMD_SET_ALARM "setAlarm"

#define CMD_SIREN_ON "sirenOn"
#define CMD_SIREN_OFF "sirenOff"

#define CMD_BUZZER_ON "buzzerOn"
#define CMD_BUZZER_OFF "buzzerOff"

#define CMD_KEYB_ENABLE "setKeybEnable"
#define CMD_KEYB_DISABLED "setKeybDisabled"

#define CMD_SENSOR "sensor"
#define CMD_STATUS "status"

#define CMD_MOD_PWD "passwd_"

i2ckeypad kpd = i2ckeypad(I2Ck, ROWS, COLS);
Password password = Password("4578");
SimpleTimer timer;

//States
#define STATE_OFFLINE 0
#define STATE_ONLINE_TIMED 1
#define STATE_ONLINE 2
#define STATE_INTRUSION 3
#define STATE_INTRUSION_WARNING 4
#define STATE_INTRUSION_ALARM 5
int status = STATE_OFFLINE;

//Sensor
#define SENSOR_OPEN  "OPEN"
#define SENSOR_CLOSED  "CLOSE"
#define SENSOR_UNKNOWN  "UNKNOWN"

//sensorState
int lastSensorValue = 0; 

//pins
int buzzerPin = 3;

//siren pin
int sirenPin = 3;
int sensorPin = 2;

//timer id
int timerIdWarning;
int timerIdSiren;
int timerIdWarningStop;
int timerIdSirenStop;
int timerId2OnlineWarningStop;
int timerIdOnline;

void setup()
{
  Serial.begin(9600);
  //Serial.begin(19200);
  
  pinMode(buzzerPin, OUTPUT);  
  pinMode(sirenPin, OUTPUT);  
  pinMode(sensorPin, INPUT);  
  Wire.begin();
  kpd.init();
  setOffline();
  Serial.println("READY");
}

int sensorValue = -1;

void loop()
{
  readSensor();
  serialReader();

  //timer
  timer.run();
  
  //keypad section
  char key = kpd.get_key();
  if(key != '\0')
  {
    //Serial.println(key);
    switch (key)
    {
      case '*':
        checkPwd();
        break;
      default:
        password.append(key);  
    }
  }
  
  if(strcmp(getSensorStatus(sensorValue), SENSOR_OPEN) == 0 && status == STATE_ONLINE)
  {
    instrusion();
  }
}

void executeCommand(char *serialReadString)
{
  if(strcmp(serialReadString, CMD_SET_ONLINE) == 0)
  {
    if (status != STATE_ONLINE)
    {
      setOnline();
      //cmdOk();
    }
  }
  else if(strcmp(serialReadString, CMD_SET_OFFLINE) == 0)
  {
    if (status != STATE_OFFLINE)
    {
      setOffline();
      //cmdOk();
    }
  }
  else if(strcmp(serialReadString, CMD_STATUS) == 0)
  {
    Serial.println(getFinalStatus());
    /*
    if (status == STATE_OFFLINE)
    {
      Serial.println("STATUS OFFLINE");
    }
    else if (status == STATE_ONLINE_TIMED)
    {
      Serial.println("STATUS ONLINE_TIMED");
    }
    else if (status == STATE_ONLINE)
    {
      Serial.println("STATUS ONLINE");
    }
    else if (status == STATE_INTRUSION)
    {
      Serial.println("STATUS INTRUSION");
    }
    else if (status == STATE_INTRUSION_WARNING)
    {
      Serial.println("STATUS INTRUSION_WARNING");
    }
    else if (status == STATE_INTRUSION_ALARM)
    {
      Serial.println("STATUS INTRUSION_ALARM");
    }*/
  }
  else
  {
    Serial.println("UNKNOWN CMD");
  }
}

String getFinalStatus()
{
    String statusStr;
    if (status == STATE_OFFLINE)
    {
      statusStr = "OFFLINE";
    }
    else if (status == STATE_ONLINE_TIMED)
    {
      statusStr = "ONLINE_TIMED";
    }
    else if (status == STATE_ONLINE)
    {
      statusStr = "ONLINE";
    }
    else if (status == STATE_INTRUSION)
    {
      statusStr = "INTRUSION";
    }
    else if (status == STATE_INTRUSION_WARNING)
    {
      statusStr = "INTRUSION_WARNING";
    }
    else if (status == STATE_INTRUSION_ALARM)
    {
      statusStr = "INTRUSION_ALARM";
    }
    statusStr.concat("|");
    statusStr.concat(getSensorStatus(sensorValue));
    String final = "STATUS:";
    final.concat(statusStr);
    return final;
}

void setOnlineTimed()
{
  status = STATE_ONLINE_TIMED;
  timerIdOnline = timer.setTimeout(timeout2Online, setOnline);
}

void setOnline()
{
  status = STATE_ONLINE;
  ledRed();
}

void setOffline()
{
  status = STATE_OFFLINE;
  ledGreen();
  sirenOff();
  timer.disable(timerIdWarning);
  timer.disable(timerIdSiren);
  timer.disable(timerIdOnline);
  timer.disable(timerId2OnlineWarningStop);
  timer.disable(timerIdWarningStop);
  timer.disable(timerIdSirenStop);
}

void checkPwd()
{
  if (password.evaluate()){
    if(status == STATE_OFFLINE)
    {
      setOnlineTimed();
    }
    else
    {
      setOffline();
    }
    password.reset();
  }
  else
  {
    password.reset();
  }
}

void instrusion()
{
  status = STATE_INTRUSION;
  timerIdWarning = timer.setTimeout(timeout2Warning, raiseWarning);
  timerIdSiren = timer.setTimeout(timeout2Siren, raiseSiren);
}

void raiseOnlineWarning()
{
  ledGreenBuz();
  timerId2OnlineWarningStop = timer.setTimeout(timeout2OnlineWarningStop, stopOnlineWarning);
}

void stopOnlineWarning()
{
  setOnline();
}

void raiseWarning()
{
  status = STATE_INTRUSION_WARNING;
  ledRedBuz();
  timerIdWarningStop = timer.setTimeout(timeout2WarningStop, stopWarning);
}

void raiseSiren()
{
  status = STATE_INTRUSION_ALARM;
  sirenOn();
  timerIdSirenStop = timer.setTimeout(timeout2SirenStop, stopSiren);
}

void stopWarning()
{
  ledRed();
}

void stopSiren()
{
  sirenOff();
}



/*
UTILITIES
*/
void serialReader()
{
  int makeSerialStringPosition;
  int inByte;
  char serialReadString[50];
  const int charCR = 10; //Terminate lines with CR
  const int charNL = 13; //Terminate lines with NL

  inByte = Serial.read();
  makeSerialStringPosition=0;
  

  if (inByte > 0 && (inByte != charCR ||  inByte != charNL)) { //If we see data (inByte > 0) and that data isn't a carriage return
	delay(100); //Allow serial data time to collect (I think. All I know is it doesn't work without this.)

	while ((inByte != charCR || inByte != charNL) && Serial.available() > 0){ // As long as EOL not found and there's more to read, keep reading
	  serialReadString[makeSerialStringPosition] = inByte; // Save the data in a character array
	  makeSerialStringPosition++; //Increment position in array
	  //if (inByte > 0) Serial.println(inByte); // Debug line that prints the charcodes one per line for everything recieved over serial
	  inByte = Serial.read(); // Read next byte
	}

	if (inByte == charCR || inByte == charNL) //If we terminated properly
	{
	  serialReadString[makeSerialStringPosition] = 0; //Null terminate the serialReadString (Overwrites last position char (terminating char) with 0
	  //Serial.println(serialReadString);
          executeCommand(serialReadString);
	}
  }
}

void cmdOk()
{
  Serial.println("OK");
}

void cmdKo()
{
  Serial.println("KO");
}

char* getSensorStatus(int statusValue)
{
  //if(statusValue == HIGH) //if sensor connected to "T" (high when pressed)
  if(statusValue == LOW) //if sensor connected to "R" (low when pressed)
  {
    return SENSOR_OPEN;
  }
  //else if (statusValue == HIGH) //if sensor connected to "T" (high when pressed)
  else if (statusValue == HIGH) //if sensor connected to "R" (low when pressed)
  {
    return SENSOR_CLOSED;
  }
  else
  {
    return SENSOR_UNKNOWN;
  }
}

int readSensor()
{
  sensorValue = digitalRead(sensorPin);
  if (sensorValue != lastSensorValue) {
    lastSensorValue = sensorValue;
    return sensorValue;
  }
  else
  {
    return -1;
  }
}

void i2cKeypadWrite(int data)
{
  Wire.beginTransmission(I2Ck);
  Wire.write(data); 
  Wire.endTransmission();
  Wire.beginTransmission(I2Ck);
  Wire.write((uint8_t)0x70); 
  Wire.endTransmission();
}

void buzz()
{
    i2cKeypadWrite(aBuzz);
}

void ledRed()
{
    i2cKeypadWrite(aLedRed);
}

void ledGreen()
{
    i2cKeypadWrite(aLedGreen);
}

void ledRedBuz()
{
  i2cKeypadWrite(aLedRed | aBuzz);
}

void ledGreenBuz()
{
  i2cKeypadWrite(aLedGreen | aBuzz);
}

void sirenOn()
{
  digitalWrite(sirenPin, HIGH);
}

void sirenOff()
{
  digitalWrite(sirenPin, LOW);
}



/*old
void normal()
{
  //timer
  timer.run();
  
  //keypad section
  char key = kpd.get_key();
  if(key != '\0')
  {
    //Serial.println(key);
    switch (key)
    {
      case '*':
        checkPwd();
        break;
      default:
        password.append(key);  
    }
  }
  
  //sensor section
  if (isSensorStateChanged() && isOnline)
  {
    //Serial.println("changed state");
    hasDoorBeenOpened = true;
    timerIdWarning = timer.setTimeout(timeout2Warning, raiseWarning);
    timerIdSiren = timer.setTimeout(timeout2Siren, raiseSiren);
  }
  
  setOnline();
}

boolean isSensorStateChanged()
{
  boolean hasChanged = false;
  sensorValue = digitalRead(sensorPin);
  if (sensorValue != lastSensorValue) {
    if (sensorValue == HIGH) {
       hasChanged = true;
    }
  }
  lastSensorValue = sensorValue;
  return hasChanged;  
}
*/
