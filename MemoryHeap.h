// MemoryHeap.h

#ifndef _MEMORYHEAP_h
#define _MEMORYHEAP_h

#define HEAP_SIZE 64

#if defined(ARDUINO) && ARDUINO >= 100
	#include "arduino.h"
#else
	#include "WProgram.h"
#endif

class MemoryHeap
{
	public:
		MemoryHeap();
		void writeByte(unsigned int address, byte value);
		bool getByte(unsigned int address, byte &byte);
		void clear();
	private:
		byte heapValues[HEAP_SIZE];
		unsigned int heapAddresses[HEAP_SIZE];
		unsigned int nextHeapIndex;
		int getAddressIndex(unsigned int address);
};

#endif

