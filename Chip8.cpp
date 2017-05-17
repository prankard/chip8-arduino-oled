#include "Chip8.h"

const unsigned int FONT_ADDRESS = 0x0;
const unsigned int START_ADDRESS = 0x200;

Chip8::Chip8()
{

}

void Chip8::setup()
{
#ifdef DEBUG_CHIP8
    Serial.begin(9600);
#endif
	//_rom = rom;

    clearScreen();
    programCounter = START_ADDRESS;

	lastTime = millis();
}

void Chip8::step()
{
	if (end)
	{
		gamepad->getInputs(keys);
		for (int i = 0; i < KEYS_LENGTH; i++)
		{
			if (keys[i])
			{
				reset();
				break;
			}
		}
		return;
	}

	millis();
    interpretOpcode(currentOpcode());
	gamepad->getInputs(keys);

	unsigned long now = millis();
	unsigned long diff = lastTime - now;
	diff *= 0.60;
	if (delayTimer > diff)
		delayTimer -= diff;
	else
		delayTimer = 0;
//	delayTimer -= diff * 0.06;
	lastTime = now;
}

unsigned int Chip8::currentOpcode()
{
    unsigned int opcode = getByte(programCounter) << 8 | getByte(programCounter + 1);

#ifdef DEBUG_CHIP8
    Serial.println(programCounter, HEX);
    Serial.println(getByte(programCounter), HEX);
    Serial.println(getByte(programCounter + 1), HEX);
    Serial.println(opcode, HEX);
#endif
	//Serial.println(opcode, HEX);
    return opcode;
}

void Chip8::clearScreen()
{
    //for(const byte &b : this.displayBytes)
      //  b = 0;

    for(unsigned int i = 0; i < sizeof(displayBytes)/sizeof(displayBytes[0]); i++)
        displayBytes[i] = 0x0;

	renderer->clearScreen();
}
		
void Chip8::nextOpcode()
{
    programCounter += 2;
}

void Chip8::interpretOpcode(unsigned int opcode)
{
    byte a = (opcode & 0xF000) >> 12;
    byte b = (opcode & 0x0F00) >> 8;
    byte c = (opcode & 0x00F0) >> 4;  
    byte d = opcode & 0x000F;

#ifdef DEBUG_CHIP8
    Serial.println(opcode, HEX);
    Serial.println((opcode & 0xFF00) >> 8, HEX);
    Serial.println((opcode & 0x00FF), HEX);
    Serial.println(a, HEX);
    Serial.println(b, HEX);
    Serial.println(c, HEX);
    Serial.println(d, HEX);
#endif

    switch (opcode)
    {
        case 0x00E0: // Clear screen
#ifdef DEBUG_CHIP8
            Serial.println("clear screen");
#endif
            clearScreen();
            nextOpcode();
            return;
        case 0x00EE: //Return from subroutine
            programCounter = stack[--stackIndex];
            stack[stackIndex] = 0;
#ifdef DEBUG_CHIP8
            Serial.println("Exit subroutine");
#endif

            return;
    }

    // Perform address
    unsigned int address = (opcode & 0x0FFF);
    unsigned int x;
    unsigned int y;
    unsigned int nn = (opcode & 0x00FF);
    unsigned int j = 0;
    unsigned int sum = 0;

    switch (a)
    {
        case 0x0: // Calls RCA 1802 program at address
			end = true;
            break;
        case 0x1: // Jump to address
			if (programCounter == address)
				end = true;

            programCounter = address;
            return;
        case 0x2: // Calls a subroutine at addressnextOpcode();
			nextOpcode();
            stack[stackIndex++] = programCounter;
            programCounter = address;       
            return;
        case 0x3: // 3XNN	Skips the next instruction if VX equals NN.
            if (v[b] == nn)
                nextOpcode();
            nextOpcode();
            return;
        case 0x4: // 4XNN	Skips the next instruction if VX doesn't equal NN.
            if (v[b] != nn)
                nextOpcode();
            nextOpcode();
            return;
        case 0x5: // 5XY0	Skips the next instruction if VX equals VY.
            if (v[b] == v[c])
                nextOpcode();
            nextOpcode();
            return;;
        case 0x6: // 6XNN Sets VX to NN
            // Sets the values for the data registers
			v[b] = nn;
#ifdef DEBUG_CHIP8
			Serial.println("stored v");
			Serial.println(b);
            Serial.println("as");
            Serial.println(nn);
#endif
            nextOpcode();
            return;
        case 0x7: // 7XNN	Adds NN to VX.
            //if (DEBUG) trace("v[" + b + "] += " + nn.toString(16));
            //if (DEBUG) trace("v[" + b + "] += " + nn.toString());
            //if (DEBUG) trace("v[b]: " + v[b].toString());
            v[b] += nn; // We might need to max out this value if it gets too high
            v[b] %= 256;
            //if (DEBUG) trace("v[b]: " + v[b].toString());
            nextOpcode();
            return;
        case 0x8:
            switch (d)
            {
                case 0x0: // 8XY0	Sets VX to the value of VY.
                    v[b] = v[c];
                    nextOpcode();
                    return;
                case 0x1: // 8XY1	Sets VX to VX or VY.
                    v[b] = v[b] | v[c];
                    nextOpcode();
                    return;
                case 0x2: // 8XY2	Sets VX to VX and VY.
                    v[b] = v[b] & v[c];
                    nextOpcode();
                    return;
                case 0x3: // 8XY3	Sets VX to VX xor VY.
                    v[b] = v[b] ^ v[c];
                    nextOpcode();
                    return;
                case 0x4: // 8XY4	Adds VY to VX. VF is set to 1 when there's a carry, and to 0 when there isn't.
                    sum = v[b] + v[c];
                    v[0xF] = (sum > 0xFF) ? 1 : 0;
                    v[b] = sum % 256;
                    nextOpcode();
                    return;
                case 0x5: // 8XY5	VY is subtracted from VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
                    sum = v[b] - v[c];
                    v[0xF] = (sum < 0) ? 0 : 1;
                    while (sum < 0)
                        sum += 0xFF;
                    v[b] = sum % 256;
                    nextOpcode();
                    return;
                case 0x6: // 8XY6	Shifts VX right by one. VF is set to the value of the least significant bit of VX before the shift.[2]
                    v[0xF] = v[b] & 1;
                    v[b] = v[b] >> 1;
                    nextOpcode();
                    return;
                case 0x7:
                    // TODO: This?
                    // 8XY7	Sets VX to VY minus VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
                    //nextOpcode();
					Serial.println("Not implemented 0x7");
                    break;
                case 0xE:
                    // TODO: This?
                    // 8XYE	Shifts VX left by one. VF is set to the value of the most significant bit of VX before the shift.[2]
                    //v[0xF] = v[b] & 1;
                    //v[b] = (v[b] << 1) % 256;
                    //nextOpcode();
					Serial.println("Not implemented 0xE");
                    break;
            }
            break;
        case 0x9: // 9XY0	Skips the next instruction if VX doesn't equal VY.
            if (v[b] != v[c])
                nextOpcode();
            nextOpcode();
            return;
        case 0xA:
            // Set index to 
            i = address;
#ifdef DEBUG_CHIP8
            Serial.print("set i to :");
            Serial.println(i, HEX);
#endif
            nextOpcode();
            return;
        case 0xB:
            // Jumps to address plus V0
            programCounter = address + v[0];
            return;
        case 0xC: // CXNN	Sets VX to a random number and NN.
            //Serial.println("setting v[" + b + "] to random 0xFF & " + nn.toString(16));
            v[b] = (random(0, 0xFF)) & nn;
            nextOpcode();
            return;
        case 0xD:
#ifdef DEBUG_CHIP8
            Serial.println("draw a sprite at ");
            Serial.println(v[b]);
            Serial.println(v[c]);
            Serial.println(" height of ");
            Serial.println(d);
#endif
            v[0xf] = 0;
			{
				int drawAddress = i;
				for (int row = 0; row < d; row++)
				{
					v[0xf] = v[0xf] | drawSprite(v[b] % 64, (v[c] + row) % displayHeight, getByte(drawAddress++));
				}
			}
            nextOpcode();
            return;
            //*/
        case 0xE:
            switch (nn)
            {
                case 0x9E:
                    // EX9E	Skips the next instruction if the key stored in VX is pressed.
                    if (keys[v[b]])
                        nextOpcode();
                    nextOpcode();
                    return;
                case 0xA1:
                    // EXA1	Skips the next instruction if the key stored in VX isn't pressed.
                    if (!keys[v[b]])
                        nextOpcode();
                    nextOpcode();
                    return;
            }
            break;
        case 0xF:
            switch (nn)
            {
                case 0x07:
                    // FX07	Sets VX to the value of the delay timer.
                    v[b] = delayTimer;
                    nextOpcode();
                    return;
                case 0x0A:
                    // FX0A	A key press is awaited, and then stored in VX.
                    for (int k = 0; k < KEYS_LENGTH; k++) 
                    {
                        if (keys[k])
                        {
                            v[b] = k;
                            nextOpcode();
							break;
                        }
                    }
                    return;
                case 0x15:
                    // FX15	Sets the delay timer to VX.
                    delayTimer = v[b];
                    nextOpcode();
                    return;
                case 0x18:
                    // FX18	Sets the sound timer to VX.
                    soundTimer = v[b];
                    // TODO: Sound timer
                    /*
                    if (soundTimer == 0)
                    {
                        dispatchEvent(new Chip8SoundEvent(Chip8SoundEvent.SOUND_OFF));
                    }
                    else
                    {
                        dispatchEvent(new Chip8SoundEvent(Chip8SoundEvent.SOUND_ON, soundTimer));
                    }
                    */
                    nextOpcode();
                    return;
                case 0x1E: // FX1E	Adds VX to I.[3]
                    i += v[b];
                    i %= 0xFFF;
                    nextOpcode();
                    return;
                case 0x29: // FX29	Sets I to the location of the sprite for the character in VX. Characters 0-F (in hexadecimal) are represented by a 4x5 font.
                    i = FONT_ADDRESS + v[b] * 0x5;
                    nextOpcode();
                    return;
                case 0x33:
                    /**
                        * FX33	Stores the Binary-coded decimal representation of VX, 
                        * with the most significant of three digits at the address in I, 
                        * the middle digit at I plus 1, 
                        * and the least significant digit at I plus 2. 
                        * (In other words, take the decimal representation of VX, 
                        * place the hundreds digit in memory at location in I, the tens digit at location I+1, and the ones digit at location I+2.)
                        */
					{
						int decimal = v[b];
						int hundred = decimal / 100;
						int tens = (decimal / 10) % 10;
						int ones = (decimal % 100) % 10;

						setByte(i, hundred);
						setByte(i + 1, tens);
						setByte(i + 2, ones);
					}
					nextOpcode();
                    return;
                case 0x55: // FX55	Stores V0 to VX in memory starting at address I
					for (j = 0; j <= b; j++)
						setByte(i, v[j]);

                    nextOpcode();
                    return;
                case 0x65: // FX65	Fills V0 to VX with values from memory starting at address I
                    for (j = 0; j <= b; j++)
                        v[j] = getByte(i + j);
                    nextOpcode();
                    return;
            }
            break;



    }

	Serial.println("Opcode not implemented");
	Serial.println(opcode, HEX);
    delay(100000);
}

/**
* Will draw a sprite at x and y
* @param	x
* @param	y
* @param	data One Byte (8 bits) eg 10111101 or 0xBD
* @return Will turn true if a pixel turned off (collision detection)
*/
unsigned int Chip8::drawSprite(int x, int y, unsigned int data)
{
	/*
	renderer->drawSmallByte(x, y, data);
	return;
	*/

#ifdef DEBUG_CHIP8
    Serial.println(data, BIN);
    Serial.println("---");
    Serial.print(x);
    Serial.print("x");
    Serial.println(y);
#endif
    //memory
    //displayBytes.position = Math.random() * 200;
    //displayBytes.writeByte(0xF);
    //drawFlag = true;
    //return 1;
    //trace(getBinary(data) + " : " + data.toString(16));
    
    int extraLeftBits = x % 8;
    int extraRightBits = 8 - extraLeftBits;
    int position = (x - extraLeftBits + y * displayWidth) / 8;
    byte byte1 = displayBytes[position];
    unsigned int combined;
    unsigned int shape;
    unsigned int inverseShape;
    unsigned int newRender;
    unsigned int currentBits;
    
    int size = 16;
	/*
	Serial.print("x:");
	Serial.print(x);
	Serial.print(",y:");
	Serial.println(y);
	*/
    
    // Write one byte
    if (x >= displayWidth - 8)
    {
        size = 8;
        
        combined = byte1;
        shape = 0xFF >> extraLeftBits;
        inverseShape = shape ^ 0xFF;
        currentBits = (shape & combined) << extraLeftBits;
        
        newRender = (shape & ((data ^ currentBits) >> extraLeftBits)) | (inverseShape & combined);
        
        displayBytes[position] = newRender;
		cacheRenderByte(position);
//		drawSprite(position, position % 16, displayBytes[position]);
		//Serial.println("one byte");
		//*/
    }
    else
    {
		//Serial.println("two bytes");
        // Write two bytes
        byte byte2 = displayBytes[position + 1];
        combined = byte1 << 8 | byte2;
        //var shape:uint = (((0xFFFF << extraLeftBits) & 0xFFFF) >> (extraRightBits + extraLeftBits)) << extraRightBits;
        shape = 0xFF << extraRightBits;
        inverseShape = shape ^ 0xFFFF;
        currentBits = (shape & combined) >> extraRightBits;
        
        newRender = (shape & ((data ^ currentBits) << extraRightBits)) | (inverseShape & combined);

        displayBytes[position] = (newRender >> 8);
        displayBytes[position + 1] = (newRender & 0xFF);
		cacheRenderByte(position);
		cacheRenderByte(position + 1);
    }
    
    //var hit:uint = (((data | currentBits) & data) == data) ? 0 : 0x1;
    unsigned int hit = (((newRender & combined) & combined) == combined) ? 0 : 0x1;
    
    //Serial.println(getBinarySquares(data));
    /*
        trace("--");
        trace("X    :" + x);
        trace("left :" + extraLeftBits);
        trace("right:" + extraRightBits);
        trace("shape:" + getBinary(shape, size));
        trace("inver:" + getBinary(inverseShape, size));
        trace("old  :" + getBinary(combined, size));
        trace("new  :" + getBinary(newRender, size));
        trace("curr :" + getBinary(currentBits, 8));
        trace("data :" + getBinary(data, 8));
        trace("--");
        trace(hit);
        trace("---");
    //*/
    
    drawFlag = true;
    return hit;
    /*
    //trace("extra bits: " + extraBits);
    
    
    //var overlap:Boolean = x > SCREEN_WIDTH - 8;
    
    var both:uint = byte1 << 8 | byte2;
    
    var shape:uint = (((0xFFFF << extraLeftBits) & 0xFFFF) >> (extraRightBits + extraLeftBits)) << extraRightBits;
    var currentDisplayBits:uint = (both & shape) >> extraRightBits;
    var oppositeShape:uint = overlap ? (shape ^ 0xFF) : (shape ^ 0xFFFF);
    
    var newRender:uint = ((data ^ currentDisplayBits) << extraRightBits) | (both & oppositeShape);
    displayBytes.position = position;
    displayBytes.writeByte(newRender >> 8);
    if (!overlap) displayBytes.writeByte(newRender);
    
    //trace("----");
    //trace("left: " + extraLeftBits);
    //trace("right: " + extraRightBits);
    //trace(getBinary(both, 16));
    //trace(getBinary(shape, 16));
    //trace(getBinary(newRender, 16));
    //trace(getBinary(currentDisplayBits, 8));
    //trace(getBinary(data, 8));
    trace(getBinary(both, 16));
    trace(getBinary(newRender, 16));
    //trace(overlap);
    var hit:uint = (((data | currentDisplayBits) & data) == data) ? 0 : 0x1;
    
    drawFlag = true;
    //trace("pre bytes: " + currentDisplayBits.toString(16));
    //trace("new bytes: " + newRender.toString(16));
    
    return hit;
    
    //var combined:uint = (byte1 << extraLeftBits) & byte2 >> extraRightBits;
    return 1;
    */
}

void Chip8::cacheRenderByte(int bytePosition)
{
	// No cache
	/*
	renderByte(bytePosition);
	return;
	//*/

	int byteWidth = displayWidth / 8;
	int yPos = (int)(bytePosition / byteWidth);
	int xPos = bytePosition - byteWidth * yPos;
	int yBytePos = yPos / 8;
	int rootByte = yBytePos * 8 * byteWidth + xPos;

	// Mini cache
	/*
	if (lastBytePos != rootByte)
	{
		renderByte(lastBytePos);
	}
	lastBytePos = rootByte;
	//*/

	//*
	// Mega cache
	cache[cacheIndex] = rootByte;

	cacheIndex++;
	if (cacheIndex >= CACHE_MAX)
	{
		for (int i = 0; i < CACHE_MAX; i++)
		{
			bool last = true;
			for (int j = i + 1; j < CACHE_MAX; j++)
			{
				if (cache[j] == cache[i])
				{
					last = false;
					break;
				}
			}
			if (last)
				renderByte(cache[i]);
		}
		cacheIndex = 0;
	}
	//*/
}

void Chip8::renderByte(int bytePosition)
{
	int yPos = (int)(bytePosition * 8 / displayWidth);
	int xPos = bytePosition - displayWidth / 8 * yPos;
	int yBytePos = yPos / 8;
	int yByteStartPos = yBytePos * 8;
	byte bytes[8];
	/*
	Serial.println("---");
	Serial.println(bytePosition);
	Serial.println("---");
	//*/

	bool check = false;
	for (int i = 0; i < 8; i++)
	{
		int newPos = (yByteStartPos + i) * (displayWidth / 8) + xPos;
		bytes[i] = displayBytes[newPos];
	}
	
	/*
	Serial.println("---");
	Serial.println(xPos);
	Serial.println(yBytePos);
	Serial.println("---");
	Serial.print(bytePosition);
	Serial.print(" = ");
	Serial.print(xPos);
	Serial.print("x");
	Serial.println(yPos);
	*/
	renderer->drawByteSprite(bytes, xPos, yBytePos);
}

void Chip8::loadRom(byte* bytes, int length)
{
    _rom = bytes;
}

byte Chip8::getByte(int address)
{
	if (address < START_ADDRESS)
	{
//		return pgm_read_byte(address);
		return FONT_DATA[address];
	}
	else
	{
		byte b;
		if (heap.getByte(address, b))
		{
			return b;
		}
		//return pgm_read_byte_near(address - START_ADDRESS);
		return _rom[address - START_ADDRESS];
	}
}

void Chip8::setByte(int address, byte value)
{
	heap.writeByte(address, value);
}

void Chip8::reset() 
{
	clearScreen();
	programCounter = START_ADDRESS;
	end = false;
	heap.clear();
}