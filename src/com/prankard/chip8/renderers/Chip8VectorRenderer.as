package com.prankard.chip8.renderers 
{
	import com.prankard.chip8.Chip8;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author James Prankard
	 */
	public class Chip8VectorRenderer extends AbstractChip8Renderer 
	{
		
		public function Chip8VectorRenderer() 
		{
			this.graphics.beginFill(0x000000, 0);
			this.graphics.drawRect(0, 0, Chip8.SCREEN_WIDTH, Chip8.SCREEN_HEIGHT);
		}
		
		override public function render(displayBytes:ByteArray):void 
		{
			this.graphics.clear();
			super.render(displayBytes);
		}
		
		override protected function setPixel(x:Number, y:Number, on:Boolean):void 
		{
			var elipse:Number = 0.8;
			this.graphics.beginFill(on ? 0x009900 : 0x000000, 1);
			this.graphics.drawRoundRect(x, y, 1, 1, elipse, elipse);
			//this.graphics.drawCircle(x + 0.5, y + 0.5, 0.5);
		}
	}

}