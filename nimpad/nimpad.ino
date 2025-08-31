#include <Keypad.h>
#include <HID-Project.h>

const int R1 = 5;
const int R2 = 6;
const int R3 = 7;
const int R4 = 8;
const int R5 = 9;
const int C1 = 10;
const int C2 = 16;

const int ROWS = 5;
const int COLS = 2;
const char keys[COLS][ROWS] = {
  // For some reason this has to be flipped to work
  { 0, 2, 4, 6, 8 },
  { 1, 3, 5, 7, 9 }
};
const byte rowPins[ROWS] = { R1, R2, R3, R4, R5 };
const byte colPins[COLS] = { C1, C2 };
const Keypad kpd = Keypad(makeKeymap(keys), colPins, rowPins, COLS, ROWS);

void setup() {
  Serial.begin(9600);
  Keyboard.begin();
  while(!Serial);
}

void keyWrapper(char button, KeyState state) {
  char buffer[2];
  if (state == PRESSED) {
    sprintf(buffer, "%d1", button);
  } else if (state == RELEASED) {
    sprintf(buffer, "%d0", button);
  }
  Serial.print(buffer);
  Serial.flush();
}

void loop() {
  if (kpd.getKeys()) {
    for (int i = 0; i < LIST_MAX; i++) {
      if (kpd.key[i].stateChanged) {
        keyWrapper(kpd.key[i].kchar, kpd.key[i].kstate);
      }
    }
  }
}
