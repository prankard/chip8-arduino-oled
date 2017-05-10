package com.prankard.chip8.renderers 
{
	import com.prankard.chip8.Chip8;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author James Prankard
	 */
	public class Chip8BitmapRender extends AbstractChip8Renderer implements IChip8Renderer
	{
		static public const OFF_COLOUR:uint = 0x000000;
		static public const ON_COLOUR:uint = 0x009900;
		private var bitmapData:BitmapData;
		
		public function Chip8BitmapRender() 
		{
			bitmapData = new BitmapData(Chip8.SCREEN_WIDTH, Chip8.SCREEN_HEIGHT, false, OFF_COLOUR);
			addChild(new Bitmap(bitmapData));
		}
		
		override public function render(displayBytes:ByteArray):void
		{
			displayBytes.position = 0;
			var bytesWidth:Number = Chip8.SCREEN_WIDTH / 8;
			var x:int = 0;
			var y:int = 0;
			var string:String = "";
			while (displayBytes.bytesAvailable > 0)
			{
				var byte:uint = displayBytes.readUnsignedByte();
				
				if (byte.toString(16).length == 1) string += "0";
				string +=  byte.toString(16) + " ";
				
				for (var i:int = 0; i < 8; i++)
				{
					if ((byte >> (7 - i) & (0xFF >> 7)) > 0)
					{
						bitmapData.setPixel(x, y, 0x008000);
					}
					else
					{
						bitmapData.setPixel(x, y, 0x000000);
					}
					
					x++;
					if (x >= Chip8.SCREEN_WIDTH)
					{
						//string += "\n";
						y++;
						x = 0;
					}
				}
			}
		}
		
		override protected function setPixel(x:Number, y:Number, on:Boolean):void
		{
			bitmapData.setPixel(x, y, on ? ON_COLOUR : OFF_COLOUR);
		}
	}
}