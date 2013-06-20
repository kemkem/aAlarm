/*
||
|| @file PasswordKeypad.pde
|| @version 1.0
|| @author Alexander Brevig
|| @contact alexanderbrevig@gmail.com
||
|| @description
|| | A simple password application that uses a keypad as input source.
|| #
||
*/

//http://www.arduino.cc/playground/uploads/Code/Password.zip
#include <Password.h>
//http://www.arduino.cc/playground/uploads/Code/Keypad.zip
#include <Keypad.h> 

Password password = Password( "1234" );

byte rows = 4; //four rows
byte cols = 4; //four columns
byte rowPins[] = {2,3,4,5}; //connect to the row pinouts of the keypad
byte colPins[] = {6,7,8,9}; //connect to the column pinouts of the keypad

Keypad keypad = Keypad(rowPins,colPins,rows,cols);

const byte ledPin = 13; 

void setup(){
  pinMode(ledPin, OUTPUT);      // sets the digital pin as output
  digitalWrite(ledPin, HIGH);   // sets the LED on
  Serial.begin(9600);
  keypad.addEventListener(keypadEvent); //add an event listener for this keypad
}
  
void loop(){
  keypad.getKey();
}

//take care of some special events
void keypadEvent(KeypadEvent eKey){
  switch (eKey){
    case '*': guessPassword(); break;
    case '#': password.reset(); break;
	default: 
		password.append(eKey);
  }
}

void guessPassword(){
	if (password.evaluate()){
		digitalWrite(ledPin,HIGH);
	}else{
		digitalWrite(ledPin,LOW);
	}
}