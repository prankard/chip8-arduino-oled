#include "LiquidCrystalRenderer.h"

LiquidCrystalRenderer::LiquidCrystalRenderer(uint8_t rs, uint8_t enable, uint8_t d0, uint8_t d1, uint8_t d2, uint8_t d3)
{
	lcd = new LiquidCrystal(12, 11, 5, 4, 3, 2);
}

void LiquidCrystalRenderer::setup()
{
	lcd->begin(WIDTH, HEIGHT);
	lcd->clear();
}

void LiquidCrystalRenderer::render(byte* displayBytes, unsigned int screenWidth, unsigned int screenHeight)
{
	int byteWidth = screenWidth / 8;

	int charBankIndex = 0;
	int col = 0;
	int row = 0;
	byte character[8];
	for (int charIndex = 0; charIndex < CHARACTERS; charIndex++)
	{
		for (int i = 0; i < 8; i++)
		{
			character[i] = displayBytes[charIndex + i * byteWidth + byteWidth * 8] | 0xFFFFF000;
		}

		lcd->createChar(charBankIndex, character);
		lcd->setCursor(col, row);
		lcd->write(charBankIndex);

		col++;
		if (col >= WIDTH)
		{
			col = 0;
			row++;
		}

		charBankIndex++;
		if (charBankIndex >= CharBankSize)
		{
			charBankIndex = 0;
			return; // temp return
			delay(10); // Delay to display and then allow for new characters in bank
		}
	}
}