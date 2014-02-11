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
