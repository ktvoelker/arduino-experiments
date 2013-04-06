
#include <Arduino.h>

const int LED = 13;
const int DELAY = 250;

void setup() {
  pinMode(LED, OUTPUT);
}

void loop() {
  while (1) {
    digitalWrite(LED, HIGH);
    delay(DELAY);
    digitalWrite(LED, LOW);
    delay(DELAY);
  }
}

