#pragma once
#ifndef LogRenderer_h
#define LogRenderer_h

#include "Renderer.h"

class LogRenderer : public Renderer
{
public:
	LogRenderer(unsigned long baud);
	virtual void setup();
	virtual void clearScreen();
	virtual void render(byte* bytes, unsigned int screenWidth, unsigned int screenHeight);
	virtual void drawByteSprite(byte* bytes, unsigned int xBytePos, unsigned int yBytePos);
};

#endif