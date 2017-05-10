// AdafruitRenderer.h

#ifndef _ADAFRUITRENDERER_h
#define _ADAFRUITRENDERER_h

#if defined(ARDUINO) && ARDUINO >= 100
	#include "arduino.h"
#else
	#include "WProgram.h"
#endif

#include "Renderer.h"
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#define OLED_RESET 4

class AdafruitRenderer : Renderer
{
	public:
		AdafruitRenderer(uint8_t port);
		virtual void setup();
		virtual void render(byte* bytes, unsigned int screenWidth, unsigned int screenHeight);
	private:
		Adafruit_SSD1306* display;
};

#endif

