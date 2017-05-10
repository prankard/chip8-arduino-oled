#pragma once
#ifndef LogRenderer_h
#define LogRenderer_h

#include "Renderer.h"

class LogRenderer : Renderer
{
public:
	LogRenderer(unsigned long baud);
	virtual void setup();
	virtual void render(byte* bytes, unsigned int screenWidth, unsigned int screenHeight);
};

#endif