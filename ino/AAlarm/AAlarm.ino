#include <Wire.h>
#include <i2ckeypadMod.h>

//Keypad
#define ROWS 4
#define COLS 3

//Adresses
#define I2Ck 0x20
#define aLedRed 0xA0
#define aLedGreen 0x90
#define aBuzz 0xC0

//Sensor states
#define SENSOR_OPEN  "OPEN"
#define SENSOR_CLOSED  "CLOSE"
#define SENSOR_UNKNOWN  "UNKNOWN"

//SensorState
int lastSensorValue = 0;

//Pins
int buzzerPin = 3;
int sirenPin = 3;
int sensorPin = 2;

i2ckeypad kpd = i2ckeypad(I2Ck, ROWS, COLS);
int sensorValue = -1;
String keys = "";

void setup()
{
  Serial.begin(9600);
  
  pinMode(buzzerPin, OUTPUT);  
  pinMode(sirenPin, OUTPUT);  
  pinMode(sensorPin, INPUT);  
  Wire.begin();
  kpd.init();
}


void loop()
{
  readSensor();
  serialReader();

  //keypad section
  char key = kpd.get_key();
  if(key != '\0')
  {
    
    keys += key;
    Serial.println(keys);
    /*
    switch (key)
    {
    }
    */
  }
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
          //executeCommand(serialReadString);
	}
  }
}

char* getSensorStatus(int statusValue)
{
  //if(statusValue == HIGH) //if sensor connected to "T" (high when pressed)
  if(statusValue == LOW) //if sensor connected to "R" (low when pressed)
  {
    return SENSOR_OPEN;
  }
  //else if (statusValue == LOW) //if sensor connected to "T" (high when pressed)
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

