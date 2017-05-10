package com.prankard.chip8.renderers 
{
	/**
	 * ...
	 * @author James Prankard
	 */
	public class AdvancedDot extends Dot
	{
		private var topLeftRadius:Number;
		private var bottomLeftRadius:Number;
		private var bottomRightRadius:Number;
		private var topRightRadius:Number;
		private var radius:Number;
		protected var upDot:Dot;
		protected var rightDot:Dot;
		protected var downDot:Dot;
		protected var leftDot:Dot;
		
		public function AdvancedDot(size:int) 
		{
			radius = size * 0.2;
			super(size);
		}
		
		public function setSurroundingDots(array:Array):void
		{
			upDot = array[0];
			rightDot = array[1];
			downDot = array[2];
			leftDot = array[3];
		}
		
		public function updateDotGraphic():void
		{
			if (on)
			{
				var topRightRadius:Number = radius;
				var bottomRightRadius:Number = radius;
				var bottomLeftRadius:Number = radius;
				var topLeftRadius:Number = radius;
				if ((upDot != null && upDot.on) || (rightDot != null && rightDot.on))
					topRightRadius = 0;
				if ((rightDot != null && rightDot.on) || (downDot != null && downDot.on))
					bottomRightRadius = 0;
				if ((downDot != null && downDot.on) || (leftDot != null && leftDot.on))
					bottomLeftRadius = 0;
				if ((leftDot != null && leftDot.on) || (upDot != null && upDot.on))
					topLeftRadius = 0;
				
				if (topRightRadius != this.topRightRadius || bottomRightRadius != this.bottomRightRadius || bottomLeftRadius != this.bottomLeftRadius || topLeftRadius != this.topLeftRadius)
				{
					this.topLeftRadius = topLeftRadius;
					this.bottomRightRadius = bottomRightRadius;
					this.bottomLeftRadius = bottomLeftRadius;
					this.topLeftRadius = topLeftRadius;
					onSprite.graphics.clear();
					onSprite.graphics.beginFill(ON_COLOUR);
					onSprite.graphics.drawRoundRectComplex(0, 0, size, size, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius);
				}
			}
		}
	}
}