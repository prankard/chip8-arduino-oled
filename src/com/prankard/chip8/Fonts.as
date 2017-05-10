package com.prankard.chip8 
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author James Prankard
	 */
	public class Fonts 
	{
		
		public function Fonts() 
		{
			throw new Error("Static class guys, do not instatiate");
		}
		
		public static function getFontData():ByteArray
		{
			var data:ByteArray = new ByteArray();
			// 0
			data.writeByte(0xF0);
			data.writeByte(0x90);
			data.writeByte(0x90);
			data.writeByte(0x90);
			data.writeByte(0xF0);
			// 1
			data.writeByte(0x20);
			data.writeByte(0x60);
			data.writeByte(0x20);
			data.writeByte(0x20);
			data.writeByte(0x70);
			// 2
			data.writeByte(0xF0);
			data.writeByte(0x10);
			data.writeByte(0xF0);
			data.writeByte(0x80);
			data.writeByte(0xF0);
			// 3
			data.writeByte(0xF0);
			data.writeByte(0x10);
			data.writeByte(0xF0);
			data.writeByte(0x10);
			data.writeByte(0xF0);
			// 4
			data.writeByte(0x90);
			data.writeByte(0x90);
			data.writeByte(0xF0);
			data.writeByte(0x10);
			data.writeByte(0x10);
			// 5
			data.writeByte(0xF0);
			data.writeByte(0x80);
			data.writeByte(0xF0);
			data.writeByte(0x10);
			data.writeByte(0xF0);
			// 6
			data.writeByte(0xF0);
			data.writeByte(0x80);
			data.writeByte(0xF0);
			data.writeByte(0x90);
			data.writeByte(0xF0);
			// 7
			data.writeByte(0xF0);
			data.writeByte(0x10);
			data.writeByte(0x20);
			data.writeByte(0x40);
			data.writeByte(0x40);
			// 8
			data.writeByte(0xF0);
			data.writeByte(0x90);
			data.writeByte(0xF0);
			data.writeByte(0x90);
			data.writeByte(0xF0);
			// 9
			data.writeByte(0xF0);
			data.writeByte(0x90);
			data.writeByte(0xF0);
			data.writeByte(0x10);
			data.writeByte(0xF0);
			// A
			data.writeByte(0xF0);
			data.writeByte(0x90);
			data.writeByte(0xF0);
			data.writeByte(0x90);
			data.writeByte(0x90);
			// B
			data.writeByte(0xE0);
			data.writeByte(0x90);
			data.writeByte(0xE0);
			data.writeByte(0x90);
			data.writeByte(0xE0);
			// C
			data.writeByte(0xF0);
			data.writeByte(0x80);
			data.writeByte(0x80);
			data.writeByte(0x80);
			data.writeByte(0xF0);
			// D
			data.writeByte(0xE0);
			data.writeByte(0x90);
			data.writeByte(0x90);
			data.writeByte(0x90);
			data.writeByte(0xE0);
			// E
			data.writeByte(0xF0);
			data.writeByte(0x80);
			data.writeByte(0xF0);
			data.writeByte(0x80);
			data.writeByte(0xF0);
			// F
			data.writeByte(0xF0);
			data.writeByte(0x80);
			data.writeByte(0xF0);
			data.writeByte(0x80);
			data.writeByte(0x80);
			return data;
		}
	}
}