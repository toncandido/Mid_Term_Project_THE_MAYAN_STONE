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


/////////********/////////********/////////********/////////********

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
