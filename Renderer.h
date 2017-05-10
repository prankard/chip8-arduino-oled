#pragma once
#ifndef Renderer_h
#define Renderer_h
#include "Arduino.h"

class Renderer
{
public:
	virtual void setup() = 0;
	virtual void render(byte* displayBytes, unsigned int screenWidth, unsigned int screenHeight) = 0;
};

#endif