#include "LogRenderer.h"

LogRenderer::LogRenderer(unsigned long baud)
{
	//Serial.begin(baud);
}

void LogRenderer::setup()
{

}

void LogRenderer::render(byte* displayBytes, unsigned int screenWidth, unsigned int screenHeight)
{
	double bytesWidth = screenWidth / 8;
	unsigned int bytesLength = screenWidth * screenHeight / 8;
	int x = 0;
	int y = 0;
	char line[64] = "";
	for (int i = 0; i < bytesLength; i++)
	{
		byte b = displayBytes[i];

		byte byteCheck = B10000000;
		for (int bytePos = 0; bytePos < 8; bytePos++)
		{
			if ((b & byteCheck) > 0)
			{
				line[x + bytePos] = '1';
				//Serial.print("■");
			}
			else
			{
				line[x + bytePos] = '0';
				//Serial.print("□");
			}

			byteCheck = byteCheck >> 1;
		}

		x += 8;
		if (x >= screenWidth)
		{
			Serial.println(line);
			y++;
			x = 0;
		}
	}
	Serial.println(" ");
}