package com.prankard.chip8.renderers 
{
	import com.prankard.chip8.Chip8;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author James Prankard
	 */
	public class TweenChip8Renderer extends AbstractChip8Renderer 
	{
		private var dots:Vector.<AdvancedDot>;
		
		public function TweenChip8Renderer() 
		{
			dots = new Vector.<AdvancedDot>();
			var x:int = 0;
			var y:int = 0;
			var dotSize:int = 5;
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, Chip8.SCREEN_WIDTH * dotSize, Chip8.SCREEN_HEIGHT * dotSize);
			for (var i:int = 0; i < Chip8.SCREEN_WIDTH * Chip8.SCREEN_HEIGHT; i++)
			{
				var dot:AdvancedDot = new AdvancedDot(dotSize);
				dot.x = x * dotSize;
				dot.y = y * dotSize;
				//trace(x, y);
				x++;
				if (x >= Chip8.SCREEN_WIDTH)
				{
					x = 0;
					y++;
				}
				dots.push(dot);
				addChild(dot);
			}
			
			for (x = 0; x < Chip8.SCREEN_WIDTH; x++)
			{
				for (y = 0; y < Chip8.SCREEN_HEIGHT; y++)
				{
					(getDot(x, y) as AdvancedDot).setSurroundingDots([getDot(x, y - 1), getDot(x + 1, y), getDot(x, y + 1), getDot(x - 1, y)]);
				}
			}
		}
		
		override public function render(displayBytes:ByteArray):void 
		{
			super.render(displayBytes);
			for each (var dot:AdvancedDot in dots)
				dot.updateDotGraphic();
		}
		
		override protected function setPixel(x:Number, y:Number, on:Boolean):void 
		{
			if (on)
				getDot(x, y).turnOn();
			else
				getDot(x, y).turnOff();
		}
		
		public function getDot(x:int, y:int):Dot
		{
			if (x >= Chip8.SCREEN_WIDTH || x < 0 || y >= Chip8.SCREEN_HEIGHT || y < 0)
				return null;
			return dots[x + y * Chip8.SCREEN_WIDTH];
		}
	}

}