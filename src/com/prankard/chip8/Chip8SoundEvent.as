package com.prankard.chip8 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author James Prankard
	 */
	public class Chip8SoundEvent extends Event 
	{
		static public const SOUND_ON:String = "soundOn";
		static public const SOUND_OFF:String = "soundOff";
		
		public var soundTime:uint = 0;
		
		public function Chip8SoundEvent(type:String, soundTime:uint = 0) 
		{
			this.soundTime = soundTime;
			super(type);
		}
		
		public override function clone():Event 
		{ 
			return new Chip8SoundEvent(type, soundTime);
		}
	}
}