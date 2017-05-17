// 
// 
// 

#include "MemoryHeap.h"

MemoryHeap::MemoryHeap()
{
	clear();
}

void MemoryHeap::writeByte(unsigned int address, byte value)
{
	int addressIndex = getAddressIndex(address);
	if (addressIndex != -1)
		heapValues[addressIndex] = value;
	else
	{
		heapAddresses[nextHeapIndex] = address;
		heapValues[nextHeapIndex] = value;
		nextHeapIndex++;
	}
}

bool MemoryHeap::getByte(unsigned int address, byte &value)
{
	int addressIndex = getAddressIndex(address);
	if (addressIndex == -1)
		return false;

	value = heapValues[addressIndex];
	return true;
}

void MemoryHeap::clear()
{
	for (int i = 0; i < HEAP_SIZE; i++)
		heapAddresses[i] = 0;

	nextHeapIndex = 0;
}

int MemoryHeap::getAddressIndex(unsigned int address)
{
	for (int i = 0; i < HEAP_SIZE; i++)
	{
		if (heapAddresses[i] == address)
			return i;
	}
	return -1;
}
