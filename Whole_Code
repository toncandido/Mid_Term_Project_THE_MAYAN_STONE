/* 
 OCAD U -  DIGF-2B03-Physical-Computing
 Student Ton Candido 2519551
 Mid Term Project code for DIGF-2B03-Physical-Computing class at OCAD U
 The project is a rounded board with LEDs and Sensors in which you have to interact with the sensors to go to next levels
 Every new level, the speed of the game increases.
 
 Base code for sensors:
 
 Photo Sensor - http://arduino.cc/en/Tutorial/Calibration
 Force Sensor - http://learn.adafruit.com/force-sensitive-resistor-fsr/using-an-fsr
 Push Button - Arduino CookBook 5.1 Using a Switch
 
 all accessed February 9, 2014
 
 */
 
 ```javascript
 
 //VARIABLES
 
 
//LEDs
const int oneLED = 6; 
const int twoLED = 2; 
const int threeLED = 3;
const int fourLED = 4;
const int fiveLED = 5;

const int startLED = 7;
const int startButton = 8; // Green Button

int velocity = 0; //speed of the level

//Booleans
boolean startGame = false;
boolean blinkBegin = false;
boolean newLevel = false;
boolean standBy = true; //First state of the game is stand by
boolean secondPart = false; //Photo sensor task
boolean thirdPart = false; //Force sensor task

//START BUTTON
int buttonPushCounter = 0;   // counter for the number of button presses
int buttonState = 0;         // current state of the button
int lastButtonState = 0;     // previous state of the button

//PHOTO SENSOR
const int sensorPin = A5;    // pin that the sensor is attached to=
int sensorValue = 0;         // the sensor value
int sensorMin = 1023;        // minimum sensor value
int sensorMax = 0; // maximum sensor value
int readValue; // Value after mapping and constraining

//FORCE SENSOR
int fsrPin = A4;     // the FSR and 10K pulldown are connected to a0
int fsrReading;     // the analog reading from the FSR resistor divider

//PRESS BUTTON SENSOR
const int pressButtonPin = 9;
int pressButtonState;

//BUXZZER
int speakerPin = 12;

int numTones = 4;
int tones[] = {261, 261, 330, 440 }; //Song to start the game
int tonesWin[] = {262,294,330,349}; //Song when you win the level


/////////********/////////********/////////********/////////********

//SETUP AND LOOP

void setup(){

  //LEDs
  pinMode(oneLED, OUTPUT); 
  pinMode(twoLED, OUTPUT); 
  pinMode(threeLED, OUTPUT);
  pinMode(fourLED, OUTPUT);
  pinMode(fiveLED, OUTPUT);
  pinMode(startLED, OUTPUT);

  //Buttons
  pinMode(startButton, INPUT);
  pinMode(pressButtonPin, INPUT);

  Serial.begin(9600);      // open the serial port at 9600 bps: 

  // turn on LED to signal the start of the calibration period:
  pinMode(13, OUTPUT);
  digitalWrite(13, HIGH);

  // calibrate during the first five seconds 
  while (millis() < 5000) {
    sensorValue = analogRead(sensorPin);

    // record the maximum sensor value
    if (sensorValue > sensorMax) {
      sensorMax = sensorValue;
    }

    // record the minimum sensor value
    if (sensorValue < sensorMin) {
      sensorMin = sensorValue;
    }
  }
  // signal the end of the calibration period
  digitalWrite(13, LOW);
}




void loop() {

  pushButton(); //Green Button starts the game

  if (buttonPushCounter % 2 == 0) { //Every even pushes of the Green Button, the game starts, every odd, the game stops
    
    standBy = false;
    startGame = true;   //Starts the game

    if (startGame == true) {

      digitalWrite(startLED, LOW); //Turn the Green LED off, it's on when the game is in stand by

      blinkLED(oneLED, 740 + velocity); // 3 first LEDs blink in sequency
      blinkLED(twoLED, 740 + velocity);
      blinkLED(threeLED, 740 + velocity);

      blinkLED(startLED, 740 + velocity); // Green LEDS blinks in the center and ends loop
    }

    photoSensor(); // Call the photosensor to read the values
    Serial.print("photo sensor:  ");
    Serial.println(readValue);

    //PHOTO sensor
    if (readValue == 10) { //if photo sensor is covered continuos the game
      blinkLED(fourLED, 740 + velocity); // Blinks next LED

      blinkLED(startLED, 740 + velocity);  //Green LEDS blinks in the center and ends loop

      secondPart = true; // Says that this part was complete

    }

    else { // If photosensor is not covered, the game restarts
      secondPart = false;
      startGame = false;
      blinkLED(startLED, 10);
      pushButton();

      delay(1000);
      startGame = true;
    }


    forceSensor(); //Call the force sensor
    Serial.print("FORCE sensor:  ");
    Serial.print(fsrReading);     // the raw analog reading 

      //FORCE sensor
    if (fsrReading >= 225) { //if FORCE sensor is without the stone weight, continuos the game
      if (secondPart == true) { // Only continuos if the photosensor was covered previously
        blinkLED(fiveLED, 740 + velocity); // Blinks next LED

        blinkLED(startLED, 740 + velocity); //Green LEDS blinks in the center and ends loop
        thirdPart = true; // Says that this part was complete
      }
    }

    else { // If Force Sensor is with the stone weight, the game restarts
      tone(speakerPin, 0); // Plays error sound
      delay(200);
      noTone(speakerPin);

      secondPart = false;
      thirdPart = false;

      startGame = false;
      blinkLED(startLED, 10);
      delay(1000);
      startGame = true;
    }

    //BUTTON sensor
    pressButton();  
    Serial.print("button press:  ");
    Serial.println(pressButtonState);


    if (pressButtonState == 0) { //if Button sensor is covered, continuos the game and speed up on the next level
      if (secondPart == true) {
        if (thirdPart == true) {
          forceSensor();
          Serial.print("FORCE sensor:  ");
          Serial.print(fsrReading);     
          if (fsrReading != 255) { // the next level only works if the stone is in place

            newLevel = true;

            if (newLevel == true) {

              for (int i = 0; i < numTones; i++) { // Play a song
                tone(speakerPin, tonesWin[i]);
                delay(200);
              }
              noTone(speakerPin); 

              secondPart = false; // Reset the tasks
              thirdPart = false;

              startGame = false;
              blinkBegin = true; // Blinks all LEDs

              if (blinkBegin == true) {  // Blinks all LEDs
                allBlink();
              }

              delay (1400);

              blinkBegin = false; // Stop Blinking
              startGame = true; // Starts next Level
              velocity = velocity - 40; // Speed up the game

              if (velocity <= -640) { // If MAX velocity, the final level
                startGame = false;

                blinkBegin = true; // Blinks all LEDs

                if (blinkBegin == true) {
                  allBlink();
                  delay (5400);
                }

                blinkBegin = false;

                standBy = true;
                velocity = 0; // Velocity back to beggining after last level
              }
            }
          }
        }
      }
    }
    else { // If Button is not pressed or the stone is not in place, the level restarts
      tone(speakerPin, 0);
      delay(200);
      noTone(speakerPin);

      secondPart = false;
      thirdPart = false;
      startGame = false;
      blinkLED(startLED, 10);
      delay(1000);
      startGame = true;
    }
  }

  else {
    standBy = true; // Every odd pushes on the Green Button, the game stops
  }

  if (standBy == true) {
    off(); // Call void off, which is the Stand By state
  }
}

/////////********/////////********/////////********/////////********


//VOIDS

void off() { // Stand By state
  digitalWrite(oneLED, LOW);
  digitalWrite(twoLED, LOW);
  digitalWrite(threeLED, LOW);
  digitalWrite(fourLED, LOW);
  digitalWrite(fiveLED, LOW);
  digitalWrite(startLED, HIGH);
}

void allBlink() { // All LEDs blink

    digitalWrite(oneLED, HIGH);
  digitalWrite(twoLED, HIGH);
  digitalWrite(threeLED, HIGH);
  digitalWrite(fourLED, HIGH);
  digitalWrite(fiveLED, HIGH);
  digitalWrite(startLED, LOW);
  delay(500); 
  digitalWrite(oneLED, LOW);
  digitalWrite(twoLED, LOW);
  digitalWrite(threeLED, LOW);
  digitalWrite(fourLED, LOW);
  digitalWrite(fiveLED, LOW);
  digitalWrite(startLED, LOW);
  delay(500); 
}


void blinkLED(int pin, int duration) { // Function to blink any LED with any duration

  digitalWrite(pin, HIGH);
  delay(duration); 
  digitalWrite(pin, LOW); 
  delay(duration);
}


void pushButton() { // The central Green Button

  // read the pushbutton input pin:
  buttonState = digitalRead(startButton);

  // compare the buttonState to its previous state
  if (buttonState != lastButtonState) {
    // if the state has changed, increment the counter
    if (buttonState == HIGH) {
      // if the current state is HIGH then the button
      // wend from off to on:
      buttonPushCounter++;
      Serial.println("on");
      Serial.print("number of button pushes:  ");
      Serial.println(buttonPushCounter); // Print how many times the button was pressed

      for (int i = 0; i < numTones; i++) { // Play a song after pressed
        tone(speakerPin, tones[i]);
        delay(200);
      }
      noTone(speakerPin); 
    }
  }
  // save the current state as the last state, 
  //for next time through the loop
  lastButtonState = buttonState; 
}


//////SENSORS///////

//PHOTO SENSOR
void photoSensor() {
  // read the sensor:
  sensorValue = analogRead(sensorPin);

  // apply the calibration to the sensor reading
  sensorValue = map(sensorValue, sensorMin, sensorMax, 0, 255);

  // in case the sensor value is outside the range seen during calibration
  readValue = constrain(sensorValue, 0, 10);
  Serial.print("photo sensor:  ");
  Serial.println(readValue);
  //PHOTO SENSOR 
}

//FORCE SENSOR
void forceSensor() {
  fsrReading = analogRead(fsrPin); 

  fsrReading = map(fsrReading, 800, 1023, 0, 255);
  Serial.print("FORCE sensor:  ");
  Serial.print(fsrReading);     // the reading after mapping
  Serial.print("Velocity:  ");
  Serial.print(velocity);     // the speed of the game reading (could be in another place)

}

//LAST BUTTON
void pressButton() {

  // read the pushbutton input pin:
  pressButtonState = digitalRead(pressButtonPin);
  Serial.print("button press:  ");
  Serial.println(pressButtonState);
  


}

      ```
