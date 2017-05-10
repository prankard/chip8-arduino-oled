package com.prankard.chip8.tones 
{
	
	/**
	 * ...
	 * @author James Prankard
	 */
	public interface IToneGenerator 
	{
		function get isPlaying():Boolean;
		
		function stopTone():void;
		
		function playTone():void;
	}
}