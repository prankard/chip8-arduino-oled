package com.prankard.chip8 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author James Prankard
	 */
	public class RomState 
	{
		public var delayTimer:Number;
		public var soundTimer:Number;
		public var displayBytes:ByteArray;
		public var memory:ByteArray;
		public var programCounter:uint;
		public var stackIndex:uint;
		public var stack:Vector.<uint>;
		public var i:uint;
		public var v:Vector.<uint>;
		
		public function RomState(displayBytes:ByteArray, memory:ByteArray, programCounter:uint, stackIndex:uint, stack:Vector.<uint>, v:Vector.<uint>, i:uint, soundTimer:Number, delayTimer:Number) 
		{
			this.soundTimer = soundTimer;
			this.delayTimer = delayTimer;
			this.displayBytes = displayBytes;
			this.memory = memory
			this.programCounter = programCounter;
			this.stackIndex = stackIndex;
			this.stack = stack;
			this.v = v;
			this.i = i;
		}
		
		public function clone():RomState
		{
			var displayBytes:ByteArray = new ByteArray();
			this.displayBytes.position = 0;
			displayBytes.writeBytes(this.displayBytes);
			var memory:ByteArray = new ByteArray();
			this.memory.position = 0;
			memory.writeBytes(this.memory);
			var j:int = 0;
			var stack:Vector.<uint> = new Vector.<uint>(this.stack.length);
			for (j = 0; j < this.stack.length; j++)
				stack[j] = this.stack[j];
			var v:Vector.<uint> = new Vector.<uint>(this.v.length);
			for (j = 0; j < this.v.length; j++)
				v[j] = this.v[j];
			return new RomState(displayBytes, memory, programCounter, stackIndex, stack, v, i, soundTimer, delayTimer);
		}
	}
}