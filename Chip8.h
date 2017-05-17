#ifndef Chip8_h
#define Chip8_h

//#define DEBUG_CHIP8

#define KEYS_LENGTH 16
#define CACHE_SIZE 1
const int FONT_DATA_SIZE = 80;

#include "Arduino.h"
#include "Renderer.h"
#include "MemoryHeap.h"
#include "Gamepad.h"
#include <avr/pgmspace.h>

class Chip8
{
  public:
	  void reset();
	  const byte FONT_DATA[FONT_DATA_SIZE] PROGMEM = {
		0xF0,0x90,0x90,0x90,0xF0,// 0
		0x20,0x60,0x20,0x20,0x70,// 1
		0xF0,0x10,0xF0,0x80,0xF0,// 2
		0xF0,0x10,0xF0,0x10,0xF0,// 3
		0x90,0x90,0xF0,0x10,0x10,// 4
		0xF0,0x80,0xF0,0x10,0xF0,// 5
		0xF0,0x80,0xF0,0x90,0xF0,// 6
		0xF0,0x10,0x20,0x40,0x40,// 7
		0xF0,0x90,0xF0,0x90,0xF0,// 8
		0xF0,0x90,0xF0,0x10,0xF0,// 9
		0xF0,0x90,0xF0,0x90,0x90,// A
		0xE0,0x90,0xE0,0x90,0xE0,// B
		0xF0,0x80,0x80,0x80,0xF0,// C
		0xE0,0x90,0x90,0x90,0xE0,// D
		0xF0,0x80,0xF0,0x80,0xF0,// E
		0xF0,0x80,0xF0,0x80,0x80 // F
	};
	Renderer *renderer;
	Gamepad *gamepad;
	unsigned int displayWidth = 64;
	unsigned int displayHeight = 32;
    Chip8();
    void step();
    void setup();
	void loadRom(byte* rom, int length);
	bool drawFlag;
	/**
	* The display to render
	*/
	byte displayBytes[64 * 32 / 8];
	bool end;
  private:
		byte* _rom;
		
		/**
		 * The speed the chip 8 will run at (1 Hz = one thousand of cycles per second)
		 */
		double _hertz = 1;
		
		/**
		 * The rom we will load into memory and read commands
		 */
		//byte _memory[768];
		
		//bool displayBool[SCREENWIDTH * SCREENHEIGHT];
		
		/**
		 * The data registers (named v0 - v15) (memory avaliable for the opcode commands inside the CPU) (each can hold 0xFF)
		 */
    unsigned int v[16];
		/**
		 * The address register (stores 16 bits) named i (can hold 0xFFF)
		 */
		unsigned int i;
		
		/**
		 * The prorgam counter (index we are in memory)
		 */
		unsigned int programCounter;
		
		/**
		 * The stack (12 slots of 0xFFF, saves where we are in memory so we can do 12 subcommands)
		 */
		unsigned int stack[12];
		int stackIndex;
		
		/**
		 * The delay time, decreases at 60hz to zero
		 */
		double delayTimer = 0;
		
		/**
		 * The sound timer, decreases at 60hz
		 */
		double soundTimer = 0;
		
		/**
		 * The keys that are toggleable
		 */
		bool keys[KEYS_LENGTH];

	void clearScreen();
	unsigned int currentOpcode();
	void nextOpcode();
	void interpretOpcode(unsigned int opcode);
	unsigned int drawSprite(int x, int y, unsigned int data);
	byte getByte(int address);
	void setByte(int address, byte value);
	void cacheRenderByte(int bytePosition);
	void renderByte(int bytePosition);
	const unsigned int CACHE_MAX = CACHE_SIZE;
	unsigned int cacheIndex;
	unsigned int cache[CACHE_SIZE];
	int lastBytePos = 0;
	MemoryHeap heap;
	unsigned long lastTime;
};

#endif
