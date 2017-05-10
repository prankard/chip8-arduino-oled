package com.prankard.chip8.tones 
{
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	/**
	 * ...
	 * @author James Prankard
	 */
	public class PitchToneGenerator implements IToneGenerator
	{
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		
		private var _isPlaying:Boolean = false;
		
		private var _soundChannel:SoundChannel;
		
		private var _sound:Sound;
		
		private var _pitch:Number = 1;
		
		public function PitchToneGenerator(pitch:Number = 1) 
		{
			_pitch = pitch;
		}
		
		public function playTone():void
		{
			_isPlaying = true;
			_sound = new Sound(); 
			_sound.addEventListener(SampleDataEvent.SAMPLE_DATA, sineWaveGenerator); 
			_soundChannel = _sound.play(); 
		}
		
		public function stopTone():void
		{
			if (!_isPlaying)
				return;
			
			_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, sineWaveGenerator);
			_soundChannel.stop();
			_soundChannel = null;
			_sound = null;
		}
		
		private function sineWaveGenerator(event:SampleDataEvent):void 
		{		
			for (var i:int = 0; i < 8192; i++) 
			{
				var n:Number = Math.sin((i + event.position) / Math.PI / 4 * _pitch); 
				event.data.writeFloat(n); 
				event.data.writeFloat(n); 
			} 
		}
	}
}