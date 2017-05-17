// Gamepad.h

#ifndef _GAMEPAD_h
#define _GAMEPAD_h

#if defined(ARDUINO) && ARDUINO >= 100
	#include "arduino.h"
#else
	#include "WProgram.h"
#endif

class Gamepad
{
public:
	Gamepad();
	void getInputs(bool* keys);
};

#endif

