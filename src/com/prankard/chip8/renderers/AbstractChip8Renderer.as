package com.prankard.chip8.renderers 
{
	import com.prankard.chip8.Chip8;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author James Prankard
	 */
	public class AbstractChip8Renderer extends Sprite implements IChip8Renderer
	{
		
		public function AbstractChip8Renderer() 
		{
			
		}
		
		public function render(displayBytes:ByteArray):void
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
						setPixel(x, y, true);
					else
						setPixel(x, y, false);
					
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
		
		protected function setPixel(x:Number, y:Number, on:Boolean):void
		{
			
		}
	}
}