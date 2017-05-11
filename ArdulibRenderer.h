// ArdulibRenderer.h

#ifndef _ARDULIBRENDERER_h
#define _ARDULIBRENDERER_h

#if defined(ARDUINO) && ARDUINO >= 100
	#include "arduino.h"
#else
	#include "WProgram.h"
#endif

#include "Renderer.h"
#include <Wire.h>
#include <ACROBOTIC_SSD1306.h>

class ArdulibRenderer : Renderer
{
public:

	//static const unsigned char ACROBOT[] PROGMEM = {
	ArdulibRenderer();
	virtual void setup();
	virtual void render(byte* bytes, unsigned int screenWidth, unsigned int screenHeight);
};

#endif

