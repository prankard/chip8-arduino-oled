// 
// 
// 

#include "ArdulibRenderer.h"

ArdulibRenderer::ArdulibRenderer()
{

}

void ArdulibRenderer::setup()
{
	Wire.begin();
	oled.init();
	oled.clearDisplay();
	/*
	oled.setTextXY(0, 0);              // Set cursor position, start of line 0
	oled.putString("Prankard");
	oled.setTextXY(1, 0);              // Set cursor position, start of line 1
	oled.putString("LTD");
	oled.setTextXY(2, 0);              // Set cursor position, start of line 2
	oled.putString("Cheltenham,");
	oled.setTextXY(2, 10);             // Set cursor position, line 2 10th character
	oled.putString("UK");
	delay(200);
	//*/
	//oled.clearDisplay();
	/*
	display = new Adafruit_SSD1306(OLED_RESET);
	display->begin(SSD1306_SWITCHCAPVCC, 0x3C);  // initialize with the I2C addr 0x3D (for the 128x64)
	*/
	oled.setHorizontalMode();
}

void ArdulibRenderer::render(byte* bytes, unsigned int screenWidth, unsigned int screenHeight)
{           
	// Initialze SSD1306 OLED display
	//oled.clearDisplay();              // Clear screen
	oled.clearDisplay();

	//for (int i = 0; i < screenWidth * screenHeight / 8; i++)
	//	bytes[i] = 0xFF;
//	bytes = ACROBOT;
	//oled.drawBitmap(ACROBOT, screenWidth * screenHeight / 8);
	/*
	oled.setTextXY(0, 0);              // Set cursor position, start of line 0
	oled.putString("Prankard");
	oled.setTextXY(1, 0);              // Set cursor position, start of line 1
	oled.putString("LTD");
	oled.setTextXY(2, 0);              // Set cursor position, start of line 2
	oled.putString("Cheltenham,");
	oled.setTextXY(2, 10);             // Set cursor position, line 2 10th character
	oled.putString("UK");
	*/
}

void ArdulibRenderer::clearScreen()
{
	oled.clearDisplay();
}

void ArdulibRenderer::drawSmallByte(byte* bytes, unsigned int xBytePos, unsigned int yBytePos)
{
//	oled.setTextXY(yBytePos, xBytePos);
	oled.drawSingleByte(xBytePos, yBytePos, bytes);
}

void ArdulibRenderer::drawByteSprite(byte* bytes, unsigned int xBytePos, unsigned int yBytePos)
{
	oled.setTextXY(yBytePos, xBytePos);

	/*
	// a,b
	// c,d
	unsigned char a[8];
	unsigned char b[8];
	unsigned char c[8];
	unsigned char d[8];

	for (int i = 0; i < 8; i++)
	{
		unsigned int b1 = bytes[i] & B10000000;
		unsigned int b2 = bytes[i] & B01000000;
		unsigned int b3 = bytes[i] & B00100000;
		unsigned int b4 = bytes[i] & B00010000;

		
	}
	*/

	unsigned char* pointer = bytes;
	oled.putCustomChar(pointer, 8);

	//delay(100);

	//delay(200);
}