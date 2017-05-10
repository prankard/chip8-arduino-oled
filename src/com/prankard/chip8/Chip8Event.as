package com.prankard.chip8 
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author James Prankard
	 */
	public class Chip8Event extends Event 
	{
		static public const UPDATE_RENDER:String = "updateRender";
		public var displayBytes:ByteArray;
		
		public function Chip8Event(type:String, displayBytes:ByteArray) 
		{
			this.displayBytes = displayBytes;
			super(type);
		} 
		
		public override function clone():Event 
		{ 
			return new Chip8Event(type, displayBytes);
		} 
	}
}