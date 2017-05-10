package com.prankard.chip8.renderers 
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author James Prankard
	 */
	public interface IChip8Renderer
	{
		
		function render(displayBytes:ByteArray):void;
	}
	
}