// 
// 
// 

#include "AdafruitRenderer.h"

AdafruitRenderer::AdafruitRenderer(uint8_t port)
{

}

void AdafruitRenderer::setup()
{
	display = new Adafruit_SSD1306(OLED_RESET);
	display->begin(SSD1306_SWITCHCAPVCC, 0x3C);  // initialize with the I2C addr 0x3D (for the 128x64)
}

void AdafruitRenderer::render(byte* bytes, unsigned int screenWidth, unsigned int screenHeight)
{

}