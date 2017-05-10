#ifndef LiquidCrystalRenderer_h
#define LiquidCrystalRenderer_h

#include <LiquidCrystal.h>
#include "Renderer.h"

class LiquidCrystalRenderer : Renderer
{
public:
	LiquidCrystalRenderer(uint8_t rs, uint8_t enable, uint8_t d0, uint8_t d1, uint8_t d2, uint8_t d3);
	virtual void setup();
	virtual void render(byte* displayBytes, unsigned int screenWidth, unsigned int screenHeight);
private:
	LiquidCrystal *lcd;
	const int WIDTH = 16;
	const int HEIGHT = 2;
	const int CHARACTERS = 32;
	const int CharBankSize = 8;
};

#endif
