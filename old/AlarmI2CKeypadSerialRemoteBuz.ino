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
/*
#define timeout2Warning 10000
#define timeout2Siren 20000
#define timeout2WarningStop 1000
#define timeout2SirenStop 5000
#define timeout2Online 4000
#define timeout2OnlineWarningStop 2000
*/

#define timeout2Warning             20000
#define timeout2Siren               45000
#define timeout2WarningStop         4000
#define timeout2SirenStop           60000
#define timeout2Online              20000
#define timeout2OnlineWarningStop   3000

i2ckeypad kpd = i2ckeypad(I2Ck, ROWS, COLS);
Password password = Password("4578");
SimpleTimer timer;

//online/offline state
boolean isOnline = false;

//sensorState
int sensorPin = 2;
int sensorValue = 0;
int lastSensorValue = 0; 
//boolean sensorHasChanged = false;

//states
boolean isSirenRaised = false;
boolean isWarningRaised = false;
boolean hasDoorBeenOpened = false;
//boolean hasWarningBeenRaised = false;
//boolean hasSirenBeenRaised = false;

//buzzer pin
int buzzerPin = 3;

//siren pin
int sirenPin = 3;

//timer id
int timerIdWarning;
int timerIdSiren;
int timerIdWarningStop;
int timerIdSirenStop;
int timerIdOnline;

//serial IN data
char incomingByte;

void setup()
{
  //Serial.begin(9600);
  Serial.begin(19200);
  
  pinMode(buzzerPin, OUTPUT);  
  pinMode(sirenPin, OUTPUT);  
  pinMode(sensorPin, INPUT);  
  Wire.begin();
  kpd.init();
  setOffline();
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

void loop()
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
  
  //serial com section
  if (Serial.available () > 0)
  {
    incomingByte = Serial.read ();
    if (incomingByte == 10 || incomingByte == 13)
    {
      if(isOnline)
      {
        if (isSirenRaised)
        {
          Serial.print("alarm triggered\n");
        }
        else if(isWarningRaised)
        {
          Serial.print("warning has been triggered\n");
        }
        else if(hasDoorBeenOpened)
        {
          Serial.print("door has been opened\n");
        }
        else
        {
          Serial.print("online\n");
        }
      }
      else
      {
        Serial.print("offline\n");
      }
      
      
    }
    Serial.flush();
  }
}

void raiseOnlineWarning()
{
  ledGreenBuz();
  timerIdWarningStop = timer.setTimeout(timeout2OnlineWarningStop, stopOnlineWarning);
}

void stopOnlineWarning()
{
  isOnline = true;
  ledRed();
}

void raiseWarning()
{
  isWarningRaised = true;
  //buzzerOn();
  ledRedBuz();
  timerIdWarningStop = timer.setTimeout(timeout2WarningStop, stopWarning);
}

void raiseSiren()
{
  isSirenRaised = true;
  sirenOn();
  timerIdSirenStop = timer.setTimeout(timeout2SirenStop, stopSiren);
}

void stopWarning()
{
  isWarningRaised = true;
  //buzzerOff();
  ledRed();
}

void stopSiren()
{
  isSirenRaised = true;
  sirenOff();
  
  setOffline();
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

void checkPwd()
{
  if (password.evaluate()){
    toogleOnlineState();
    password.reset();
  }
  else
  {
    password.reset();
  }
}

void toogleOnlineState()
{
  if (isOnline)
  {
    setOffline();
  }
  else
  {
    timerIdOnline = timer.setTimeout(timeout2Online, setOnline);
  }
}

void setOnline()
{
  isOnline = true;
  raiseOnlineWarning();
  //ledRed();
}

void setOffline()
{
  isOnline = false;
  ledGreen();
  //buzzerOff();
  sirenOff();
  timer.disable(timerIdWarning);
  timer.disable(timerIdSiren);
  isSirenRaised = false;
  isWarningRaised = false;
  hasDoorBeenOpened = false;
}

/*
void buzzerOn()
{
  digitalWrite(buzzerPin, HIGH);
}

void buzzerOff()
{
  digitalWrite(buzzerPin, LOW);
}
*/

void sirenOn()
{
  digitalWrite(sirenPin, HIGH);
}

void sirenOff()
{
  digitalWrite(sirenPin, LOW);
}

