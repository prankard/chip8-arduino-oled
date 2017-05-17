// 
// 
// 

#include "Gamepad.h"

const int inputPin = 2;

Gamepad::Gamepad()
{
	pinMode(inputPin, INPUT_PULLUP);
}
 
void Gamepad::getInputs(bool* keys)
{
	int val = digitalRead(inputPin);
//	keys[4] = true;
	for (int i = 0; i < 16; i++)
		keys[i] = val == LOW;
}

