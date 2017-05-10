package com.prankard.chip8 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author James Prankard
	 */
	public class Chip8 extends Sprite
	{
		public static const SCREEN_WIDTH:uint = 64;
		public static const SCREEN_HEIGHT:uint = 32;
		
		private static const MEMORY_SIZE:uint = 4096;
		private static const NUMBER_OF_REGISTERS:uint = 16;
		private static const SIZE_OF_STACK:int = 12;
		private static const START_ADDRESS:uint = 0x200;
		private static const FONT_ADDRESS:uint = 0x50;
		
		private static const DEBUG:Boolean = false;
		
		/**
		 * The speed the chip 8 will run at (1 Hz = one thousand of cycles per second)
		 */
		public var hertz:Number = 1;
		
		/**
		 * The rom we will load into memory and read commands
		 */
		public var memory:ByteArray;
		
		/**
		 * The display to render
		 */
		public var display:BitmapData;
		
		/**
		 * The data registers (named v0 - v16) (memory avaliable for the opcode commands inside the CPU) (each can hold 0xFF)
		 */
		public var v:Vector.<uint>;
		
		/**
		 * The address register (stores 16 bits) named i (can hold 0xFFF)
		 */
		public var i:uint;
		
		/**
		 * The prorgam counter (index we are in memory)
		 */
		public var programCounter:int;
		
		/**
		 * The stack (12 slots of 0xFFF, saves where we are in memory so we can do 12 subcommands)
		 */
		private var stack:Vector.<uint>;
		private var stackIndex:int = 0;
		
		/**
		 * The information of the display (monochrome)
		 */
		private var displayBytes:ByteArray;
		
		/**
		 * The delay time, decreases at 60hz to zero
		 */
		private var delayTimer:Number = 0;
		
		/**
		 * The sound timer, decreases at 60hz
		 */
		private var soundTimer:Number = 0;
		
		/**
		 * The keys that are toggleable
		 */
		private var keys:Vector.<Boolean>;
		private var drawFlag:Boolean;
		private var lastTime:uint;
		
		public function Chip8() 
		{
			
		}
		
		public function getState():RomState
		{
			return new RomState(displayBytes, memory, programCounter, stackIndex, stack, v, i, soundTimer, delayTimer).clone();
		}
		
		public function loadState(state:RomState):void
		{
			state = state.clone();
			this.displayBytes = state.displayBytes;
			this.memory = state.memory;
			this.programCounter = state.programCounter;
			this.stackIndex = state.stackIndex;
			this.stack = state.stack;
			this.v = state.v;
			this.i = state.i;
			this.delayTimer = state.delayTimer;
			this.soundTimer = state.soundTimer;
			drawFlag = true;
		}
		
		public function init(stage:Stage):void
		{
			keys = new Vector.<Boolean>(16);
			stack = new Vector.<uint>(SIZE_OF_STACK);
			v = new Vector.<uint>(NUMBER_OF_REGISTERS);
			memory = new ByteArray();
			var i:int = 0;
			for (i = 0; i < MEMORY_SIZE; i++)
				memory.writeByte(0);
			displayBytes = new ByteArray();
			// Writes lots of zeros
			clearScreen();
			
			memory.position = 0;
			var fontBytes:ByteArray = Fonts.getFontData();
			fontBytes.position = 0;
			
			memory.position = FONT_ADDRESS;
			memory.writeBytes(fontBytes);
			if (DEBUG) trace("Fonts loaded from: " + FONT_ADDRESS.toString(16) + " to " + (memory.position).toString(16));
			
			programCounter = START_ADDRESS;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyCapture, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyCapture, false, 0, true);
		}
		
		private function onKeyCapture(e:KeyboardEvent):void 
		{
			var value:Boolean = e.type == KeyboardEvent.KEY_DOWN ? true : false;
			if (DEBUG) trace(e.keyCode);
			var key:int = -1;
			// Numpad 0 - 9
			if (e.keyCode >= 96 && e.keyCode <= 105)
				key = e.keyCode - 96;
			// Top numbers 0 - 9
			if (e.keyCode >= 48 && e.keyCode <= 57)
				key = e.keyCode - 48;
			// A -F
			if (e.keyCode >= 65 && e.keyCode <= 70)
				key = e.keyCode - 55;
				
			if (e.keyCode == 37)
				key = 4;
			if (e.keyCode == 39)
				key = 6;
			if (e.keyCode == 38)
				key = 2;
			if (e.keyCode == 40)
				key = 8;
			
			if (key != -1)
				keys[key] = value;
		}
		
		public function loadRom(bytes:ByteArray):void
		
		{
			memory.position = START_ADDRESS;
			//memory.clear();
			memory.writeBytes(bytes, 0);
			if (DEBUG) trace("Loaded rom: " + bytes.length + " bytes");
			//memory = bytes;
			
			/*
			traceOpcode(programCounter);
			programCounter += 2;
			traceOpcode(programCounter);
			programCounter += 2;
			traceOpcode(programCounter);
			programCounter += 2;
			traceOpcode(programCounter);
			programCounter += 2;
			traceOpcode(programCounter);
			programCounter += 2;
			traceOpcode(programCounter);
			*/
			
			
			//var code:uint = 0xA2F0;
			//interpretOpcode(code);
			
			lastTime = getTimer();
			this.addEventListener(Event.ENTER_FRAME, tick, false, 0, true);
		}
		
		public function reset():void
		{
			clearScreen();
			programCounter = START_ADDRESS;
			var value:uint = 0;
			for each (value in v)
				value = 0;
			i = 0;
			for each (var key:Boolean in keys)
				key = false;
			soundTimer = delayTimer = 0;
			for each (value in stack)
				value = 0;
		}
		
		private function onTimer():void
		{
			
		}
		
		private function tick(e:Event):void 
		{
			var now:int = getTimer();
			var timeDifference:Number = (now - lastTime);
			
			//trace("times per second: " + timeDifference * hertz);
			for (var i:int = 0; i < timeDifference * hertz; i++)
			{
				var optCode:uint = currentOpcode;
				interpretOpcode(optCode);
				
				if ((optCode & 0xF000) >> 12 == 0xD && v[0xf] == 0)
				{
					if (DEBUG) trace("break");
					break;
				}
			}
			
			lastTime = now;
			if (delayTimer > 0)	delayTimer -= timeDifference * 0.06;
			else delayTimer = 0;
			if (soundTimer > 0)
			{
				soundTimer -= timeDifference * 0.06;
				if (soundTimer <= 0)
				{
					soundTimer = 0;
					dispatchEvent(new Chip8SoundEvent(Chip8SoundEvent.SOUND_OFF));
				}
			}
			//else soundTimer = 0;
			
			if (drawFlag)
				dispatchEvent(new Chip8Event(Chip8Event.UPDATE_RENDER, displayBytes));
		}
		
		public function get currentOpcode():uint
		{
			memory.position = programCounter;
			return (memory.readUnsignedByte() << 8) | memory.readUnsignedByte();
		}
		
		public function traceOpcode(index:uint):void 
		{
			memory.position = index;
			var byte1:Number = memory.readByte();
			var byte2:Number = memory.readByte();
			if (DEBUG) trace("Opcode: " + byte1.toString(16) + "," + byte2.toString(16));
		}
		
		public function interpretOpcode(optcode:uint):void
		{
			if (DEBUG) trace("****************** " + optcode.toString(16) + " ******************");
			var a:int = (optcode & 0xF000) >> 12;
			var b:int = (optcode & 0x0F00) >> 8;
			var c:int = (optcode & 0x00F0) >> 4;
			var d:int = optcode & 0x000F;
			//trace(a.toString(16), b.toString(16), c.toString(16), d.toString(16));
			
			// Perform simple instructions
			switch (optcode)
			{
				case 0x00E0:
					// clears screen
					clearScreen();
					nextOpcode();
					return;
				case 0x00EE:
					// Return from subroutine
					programCounter = stack[--stackIndex];
					stack[stackIndex] = 0;
					//trace("Ending subroutine, stack is " + stackIndex);
					return;
			}
			
			// Perform address
			var address:int = (optcode & 0x0FFF);
			var x:uint;
			var y:uint;
			var nn:uint = (optcode & 0x00FF);;
			var j:int = 0;
			var sum:int;
			switch (a)
			{
				case 0x0:
					// Calls RCA 1802 program at address
					break;
				case 0x1:
					// Jumps to address
					if (DEBUG) trace("Jumping to: " + address.toString(16));
					programCounter = address;
					return;
				case 0x2:
					// Calls subroutine at address
					nextOpcode();
					stack[stackIndex++] = programCounter;
					programCounter = address;
					if (DEBUG) trace("Going to subroutine " + address + " stack has " + stackIndex);
					return;
				case 0x3:
					// 3XNN	Skips the next instruction if VX equals NN.
					if (DEBUG) trace("skipping optcode if v[" + b + "] == " + nn.toString(16));
					if (v[b] == nn)
					{
						if (DEBUG) trace("skipped");
						nextOpcode();
					}
					nextOpcode();
					return;
				case 0x4:
					// 4XNN	Skips the next instruction if VX doesn't equal NN.
					if (DEBUG) trace("skipping optcode if v[" + b + "] != " + nn.toString(16));
					if (v[b] != nn)
						nextOpcode();
					nextOpcode();
					return;
				case 0x5:
					// 5XY0	Skips the next instruction if VX equals VY.
					if (DEBUG) trace("skipping optcode if v[" + b + "] == v[" + c + "]");
					if (v[b] == v[c])
						nextOpcode();
					nextOpcode();
					return;
				case 0x6:
					// 6XNN Sets VX to NN
					// Sets the values for the data registers
					v[b] = nn;
					if (DEBUG) trace("stored v[" + b + "] as " + nn.toString(16));
					nextOpcode();
					return;
				case 0x7:
					// 7XNN	Adds NN to VX.
					if (DEBUG) trace("v[" + b + "] += " + nn.toString(16));
					if (DEBUG) trace("v[" + b + "] += " + nn.toString());
					if (DEBUG) trace("v[b]: " + v[b].toString());
					v[b] += nn; // We might need to max out this value if it gets too high
					v[b] %= 256;
					if (DEBUG) trace("v[b]: " + v[b].toString());
					nextOpcode();
					return;
				case 0x8:
					switch (d)
					{
						case 0x0:
							// 8XY0	Sets VX to the value of VY.
							//trace(
							v[b] = v[c];
							nextOpcode();
							return;
						case 0x1:
							// 8XY1	Sets VX to VX or VY.
							v[b] = v[b] | v[c];
							nextOpcode();
							return;
						case 0x2:
							// 8XY2	Sets VX to VX and VY.
							v[b] = v[b] & v[c];
							nextOpcode();
							return;
						case 0x3:
							// 8XY3	Sets VX to VX xor VY.
							v[b] = v[b] ^ v[c];
							nextOpcode();
							return;
						case 0x4:
							// 8XY4	Adds VY to VX. VF is set to 1 when there's a carry, and to 0 when there isn't.
							sum = v[b] + v[c];
							v[0xF] = (sum > 0xFF) ? 1 : 0;
							v[b] = sum % 256;
							nextOpcode();
							return;
						case 0x5:
							// 8XY5	VY is subtracted from VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
							sum = v[b] - v[c];
							v[0xF] = (sum < 0) ? 0 : 1;
							while (sum < 0)
								sum += 0xFF;
							v[b] = sum % 256;
							nextOpcode();
							return;
						case 0x6:
							// 8XY6	Shifts VX right by one. VF is set to the value of the least significant bit of VX before the shift.[2]
							v[0xF] = v[b] & 1;
							v[b] = v[b] >> 1;
							nextOpcode();
							return;
						case 0x7:
							// 8XY7	Sets VX to VY minus VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
							//nextOpcode();
							break;
						case 0xE:
							// 8XYE	Shifts VX left by one. VF is set to the value of the most significant bit of VX before the shift.[2]
							//v[0xF] = v[b] & 1;
							//v[b] = (v[b] << 1) % 256;
							//nextOpcode();
							break;
					}
					break;
				case 0x9:
					// 9XY0	Skips the next instruction if VX doesn't equal VY.
					if (DEBUG) trace("skipping optcode if v[" + b + "] != v[" + c + "]");
					if (v[b] != v[c])
					{
						if (DEBUG) trace("skipped");
						nextOpcode();
					}
					nextOpcode();
					return;
				case 0xA:
					// Set index to address
					i = address;
					if (DEBUG) trace("set i to : " + i.toString(10));
					nextOpcode();
					return;
				case 0xB:
					// Jumps to address plus V0
					programCounter = address + v[0];
					if (DEBUG) trace("Jumping to address plus vo: " + (address + v[0]));
					return;
				case 0xC:
					// CXNN	Sets VX to a random number and NN.
					if (DEBUG) trace("setting v[" + b + "] to random 0xFF & " + nn.toString(16));
					v[b] = (Math.random() * 0xFF) & nn;
					nextOpcode();
					return;
				case 0xD:
					if (DEBUG) trace("draw a sprite at " + v[b], v[c] + " height of " + d);
					memory.position = i;
					
					v[0xf] = 0;
					for (var row:int = 0; row < d; row++)
					{
						//if (v[b] <= 0x3F && (v[c] + row) <= 0x1F)
						//{
							v[0xf] = v[0xf] | drawSprite(v[b] % 64, (v[c] + row) % SCREEN_HEIGHT, memory.readUnsignedByte());
							//v[0xf] = 0;
						//}
					}
					nextOpcode();
					return;
				case 0xE:
					switch (nn)
					{
						case 0x9E:
							// EX9E	Skips the next instruction if the key stored in VX is pressed.
							if (DEBUG) trace("Skipping if key " + v[b] + " is pressed");
							if (keys[v[b]])
								nextOpcode();
							nextOpcode();
							return;
						case 0xA1:
							// EXA1	Skips the next instruction if the key stored in VX isn't pressed.
							if (DEBUG) trace("Skipping if key " + v[b] + " isn't pressed");
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
							if (DEBUG) trace("setting v[" + b + "] to the delay timer");
							v[b] = delayTimer;
							nextOpcode();
							return;
						case 0x0A:
							// FX0A	A key press is awaited, and then stored in VX.
							for (var k:int = 0; k < keys.length; k++) 
							{
								if (keys[k])
								{
									v[b] = k;
									nextOpcode();
								}
							}
							return;
						case 0x15:
							// FX15	Sets the delay timer to VX.
							if (DEBUG) trace("setting delay timer to v[" + b + "]");
							delayTimer = v[b];
							nextOpcode();
							return;
						case 0x18:
							// FX18	Sets the sound timer to VX.
							if (DEBUG) trace("setting sound timer to v[" + b + "]");
							soundTimer = v[b];
							if (soundTimer == 0)
							{
								dispatchEvent(new Chip8SoundEvent(Chip8SoundEvent.SOUND_OFF));
							}
							else
							{
								dispatchEvent(new Chip8SoundEvent(Chip8SoundEvent.SOUND_ON, soundTimer));
							}
							nextOpcode();
							return;
						case 0x1E:
							// FX1E	Adds VX to I.[3]
							if (DEBUG) trace("i += v[" + b + "]");
							i += v[b];
							i %= 0xFFF	
							nextOpcode();
							return;
						case 0x29:
							// FX29	Sets I to the location of the sprite for the character in VX. Characters 0-F (in hexadecimal) are represented by a 4x5 font.
							if (DEBUG) trace("Setting i to font address for character : " + v[b].toString(16));
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
							var decimalString:String = v[b].toString();
							var hundreds:Number = Number(decimalString.charAt(decimalString.length - 3));
							var tens:Number = Number(decimalString.charAt(decimalString.length - 2));
							var ones:Number = Number(decimalString.charAt(decimalString.length - 1));
							if (DEBUG) trace("stored v["+b+"](" + v[b] + "): " + hundreds, tens, ones + " into memory in i(" + i + "), i+1, i+2");
							memory.position = i;
							memory.writeByte(hundreds);
							memory.writeByte(tens);
							memory.writeByte(ones);
							nextOpcode();
							return;
						case 0x55:
							// FX55	Stores V0 to VX in memory starting at address I
							if (DEBUG) trace("Storing V0 - V" + b + " into memory starting at i:" + i);
							memory.position = i;
							for (j = 0; j <= b; j++)
								memory.writeByte(v[j]);
							nextOpcode();
							return;
						case 0x65:
							// FX65	Fills V0 to VX with values from memory starting at address I
							if (DEBUG) trace("Filling V0 - V" + b);
							memory.position = i;
							for (j = 0; j <= b; j++)
								v[j] = memory.readByte();
							nextOpcode();
							return;
					}
					break;
			}
			if (DEBUG) trace("whoops");
			//nextOpcode();
		}
		
		public function getBinary(value:uint, characters:int = 8):String 
		{
			var string:String = value.toString(2);
			while (string.length < characters)
				string = "0" + string;
			return string;
		}
		
		private function getBinarySquares(value:uint, characters:int = 8):String 
		{
			var findOnes:RegExp = /1/g;
			var findZeros:RegExp = /0/g;
			var binary:String = getBinary(value, characters);
			binary = binary.replace(findOnes, "■");
			binary = binary.replace(findZeros, "□");
			return binary;
		}
		
		/**
		 * Will draw a sprite at x and y
		 * @param	x
		 * @param	y
		 * @param	data One Byte (8 bits) eg 10111101 or 0xBD
		 * @return Will turn true if a pixel turned off (collision detection)
		 */
		public function drawSprite(x:int, y:int, data:uint):uint
		{
			//memory
			//displayBytes.position = Math.random() * 200;
			//displayBytes.writeByte(0xF);
			//drawFlag = true;
			//return 1;
			//trace(getBinary(data) + " : " + data.toString(16));
			
			var extraLeftBits:int = x % 8;
			var extraRightBits:int = 8 - extraLeftBits;
			var position:int = (x - extraLeftBits + y * SCREEN_WIDTH) / 8;
			displayBytes.position = position;
			var byte1:uint = displayBytes.readUnsignedByte();
			var combined:uint;
			var shape:uint;
			var inverseShape:uint;
			var newRender:uint;
			var currentBits:uint;
			
			var size:int = 16;
			
			// Write one byte
			if (x > SCREEN_WIDTH - 8 || displayBytes.bytesAvailable == 0)
			{
				size = 8;
				
				combined = byte1;
				shape = 0xFF >> extraLeftBits;
				inverseShape = shape ^ 0xFF;
				currentBits = (shape & combined) << extraLeftBits;
				
				newRender = (shape & ((data ^ currentBits) >> extraLeftBits)) | (inverseShape & combined);
				
				displayBytes.position = position;
				displayBytes.writeByte(newRender);
			}
			else
			{
				// Write two bytes
				var byte2:uint = displayBytes.readUnsignedByte();
				combined = byte1 << 8 | byte2;
				//var shape:uint = (((0xFFFF << extraLeftBits) & 0xFFFF) >> (extraRightBits + extraLeftBits)) << extraRightBits;
				shape = 0xFF << extraRightBits;
				inverseShape = shape ^ 0xFFFF;
				currentBits = (shape & combined) >> extraRightBits;
				
				newRender = (shape & ((data ^ currentBits) << extraRightBits)) | (inverseShape & combined);
				
				displayBytes.position = position;
				displayBytes.writeByte((newRender >> 8));
				displayBytes.writeByte((newRender & 0xFF));
			}
			
			//var hit:uint = (((data | currentBits) & data) == data) ? 0 : 0x1;
			var hit:uint = (((newRender & combined) & combined) == combined) ? 0 : 0x1;
			
			if (DEBUG) trace(getBinarySquares(data));
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
		
		public function clearScreen():void
		{
			displayBytes.position = 0;
			for (var i:int = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT / 8; i++)
				displayBytes.writeByte(0);
			drawFlag = true;
		}
		
		public function nextOpcode():void
		{
			programCounter += 2;
		}
		
		public function traceRender():void 
		{
			displayBytes.position = 0;
			var bytesWidth:Number = SCREEN_WIDTH / 8;
			var totalBytes:Number = SCREEN_HEIGHT * SCREEN_HEIGHT / 8;
			var x:int = 0;
			var string:String = "";
			if (DEBUG) trace(totalBytes);
			//return;
			for (var i:int = 0; i < totalBytes; i++)
			{
				var byte:uint = displayBytes.readUnsignedByte();
				string += getBinary(byte);
				
				//string += "11111111";
				x++;
				if (x >= bytesWidth)
				{
					string += "\n";
					x = 0;
				}
			}
			//string = "";
			if (DEBUG) trace(string);
		}
	}
}