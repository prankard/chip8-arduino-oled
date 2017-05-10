package com.prankard.chip8.renderers 
{
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Expo;
	import com.greensock.easing.FastEase;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author James Prankard
	 */
	public class Dot extends Sprite 
	{
		protected static const ON_COLOUR:uint = 0x4BB4F1;
		private var _on:Boolean = false;
		private static const TWEEN_TIME:Number = 0.2;
		protected var onSprite:Sprite;
		protected var size:int;
		
		public function Dot(size:int) 
		{
			this.size = size;
			onSprite = new Sprite();
			onSprite.graphics.beginFill(ON_COLOUR);
			onSprite.graphics.drawRect(0, 0, size, size);
			//onSprite.graphics.drawRect(-size * 0.5, -size * 0.5, size, size);
			//onSprite.x = onSprite.y = size * 0.25;
			
			onSprite.alpha = 0;
			//if (Math.random() > 0.5) onSprite.alpha = 0;
			addChild(onSprite);
		}
		
		public function turnOn():void
		{
			if (!_on)
			{
				//TweenLite.to(onSprite, 0, { alpha:1, scaleX:1, scaleY:1 } );
				//TweenMax.killTweensOf(onSprite);
				onSprite.scaleX = onSprite.scaleY = onSprite.alpha = 1;
				_on = true;
			}
		}
		
		public function turnOff():void
		{
			if (_on)
			{
				onSprite.alpha = 0;
				//TweenMax.to(onSprite, TWEEN_TIME *0.8, { delay:TWEEN_TIME * 0.2, ease:Quad.easeOut, scaleX:0, scaleY:0 } );
				//TweenMax.to(onSprite, TWEEN_TIME , { alpha:0, ease:Quad.easeIn } );
				//TweenMax.to(onSprite, TWEEN_TIME, { alpha:0, ease:Expo.easeOut } );
				_on = false;
			}
		}
		
		public function get on():Boolean 
		{
			return _on;
		}
	}

}