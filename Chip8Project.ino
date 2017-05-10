#include "DigitalPin.h"
#include "Chip8.h"
#include "LiquidCrystalRenderer.h"
#include "LogRenderer.h"
//#include "AdafruitRenderer.h"

Chip8 chip;
LiquidCrystalRenderer renderer(12, 11, 5, 4, 3, 2);
//AdafruitRenderer renderer(0x3C);
//LogRenderer renderer(9600);

unsigned long lastTime;

void setup()
{
	Serial.begin(9600);
	Serial.println("Hello log");
	renderer.setup();
	chip.setup();
}

void loop() 
{
	// put your main code here, to run repeatedly:
	if (lastTime != 0)
	{
		unsigned int diff = millis() - lastTime;
		while (diff-- != 0)
		{
			chip.step();
		}
		if (chip.drawFlag)
		{
			renderer.render(chip.displayBytes, chip.displayWidth, chip.displayHeight);
			chip.drawFlag = false;
		}
	}

	lastTime = millis();
}
