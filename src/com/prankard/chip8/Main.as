package com.prankard.chip8
{
	import com.prankard.chip8.renderers.AbstractChip8Renderer;
	import com.prankard.chip8.renderers.Chip8BitmapRender;
	import com.prankard.chip8.renderers.Chip8TextfieldRender;
	import com.prankard.chip8.renderers.Chip8VectorRenderer;
	import com.prankard.chip8.renderers.IChip8Renderer;
	import com.prankard.chip8.renderers.TweenChip8Renderer;
	import com.prankard.chip8.tones.IToneGenerator;
	import com.prankard.chip8.tones.PitchToneGenerator;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author James Prankard
	 */
	public class Main extends Sprite 
	{
		private var chip8:Chip8;
		private var bitmap:Bitmap;
		//[Embed(source="roms/15PUZZLE", mimeType="application/octet-stream")]
		//[Embed(source="roms/BLINKY", mimeType="application/octet-stream")]
		//[Embed(source="roms/BLITZ", mimeType="application/octet-stream")]
		//[Embed(source="roms/BRIX", mimeType="application/octet-stream")]
		//[Embed(source="roms/CONNECT4", mimeType="application/octet-stream")]
		//[Embed(source="roms/GUESS", mimeType="application/octet-stream")]
		//[Embed(source="roms/HIDDEN", mimeType="application/octet-stream")]
		//[Embed(source="roms/INVADERS", mimeType="application/octet-stream")]
		//[Embed(source="roms/KALEID", mimeType="application/octet-stream")]
		//[Embed(source="roms/MAZE", mimeType="application/octet-stream")]
		//[Embed(source="roms/MAZETEST", mimeType="application/octet-stream")]
		//[Embed(source="roms/MERLIN", mimeType="application/octet-stream")]
		//[Embed(source="roms/MISSILE", mimeType="application/octet-stream")]
		//[Embed(source="roms/PONG", mimeType="application/octet-stream")]
		[Embed(source="roms/PONG2", mimeType="application/octet-stream")]
		//[Embed(source="roms/PUZZLE", mimeType="application/octet-stream")]
		//[Embed(source="roms/SYZYGY", mimeType="application/octet-stream")]
		//[Embed(source="roms/TANK", mimeType="application/octet-stream")]
		//[Embed(source="roms/TETRIS", mimeType="application/octet-stream")]
		//[Embed(source="roms/TICTAC", mimeType="application/octet-stream")]
		//[Embed(source="roms/UFO", mimeType="application/octet-stream")]
		//[Embed(source="roms/VBRIX", mimeType="application/octet-stream")]
		//[Embed(source="roms/VERS", mimeType="application/octet-stream")]
		//[Embed(source="roms/WIPEOFF", mimeType="application/octet-stream")]
		
		//[Embed(source="Games/Cave.ch8", mimeType="application/octet-stream")]
		//[Embed(source="Games/Astro Dodge (2008) [Revival Studios].ch8", mimeType="application/octet-stream")]
		
		//[Embed(source = "test-roms/Chip8 emulator Logo [Garstyciuks].ch8", mimeType = "application/octet-stream")]
		//[Embed(source = "test-roms/Chip8 Picture.ch8", mimeType = "application/octet-stream")]
		//[Embed(source="test-roms/Delay Timer Test [Matthew Mikolay, 2010].txt", mimeType = "application/octet-stream")]
		//[Embed(source="test-roms/Division Test [Sergey Naydenov, 2010].ch8", mimeType="application/octet-stream")]
		
		public var RomClass:Class;
		public var hertz:Number = 0.01;
		
		private var toneGenerator:IToneGenerator;
		
		private var renderer:AbstractChip8Renderer;
		
		public function Main():void 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate, false, 0, true);
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			//trace("X:" + 0x3F);
			//return;
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// entry point
			chip8 = new Chip8();
			chip8.init(stage);
			
			//renderer = new Chip8BitmapRender();
			renderer = new TweenChip8Renderer();
			//renderer = new Chip8VectorRenderer();
			//renderer = new Chip8TextfieldRender();
			renderer.width = stage.stageWidth;
			renderer.scaleY = renderer.scaleX;
			addChild(renderer);
			
			chip8.addEventListener(Chip8Event.UPDATE_RENDER, onUpdateRender, false, 0, true);
			
			//bitmap = new Bitmap(new BitmapData(Chip8.SCREEN_WIDTH, Chip8.SCREEN_HEIGHT));
			//chip8.render(bitmap.bitmapData);
			//chip8.addEventListener(Event.ENTER_FRAME, render);
			chip8.addEventListener(Chip8Event.UPDATE_RENDER, onUpdateRender, false, 0, true);
			chip8.addEventListener(Chip8SoundEvent.SOUND_ON, onUpdateSound);
			chip8.addEventListener(Chip8SoundEvent.SOUND_OFF, onUpdateSound);
			
			//var fps:FPSCounter = new FPSCounter(0, 0, 0x990000);
			//addChild(fps);
			
			//stage.addEventListener(MouseEvent.CLICK, loadRom);
			loadRom();
		}
		
		private function loadRom(e:MouseEvent=null):void
		{
			stage.removeEventListener(MouseEvent.CLICK, loadRom);
			
			toneGenerator = new PitchToneGenerator(3);
			
			var rom:ByteArray = new RomClass() as ByteArray;
			chip8.loadRom(rom);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, shortcuts, false, 0, true);
		}
		
		private var playSound:Boolean = false;
		
		private function onUpdateSound(e:Chip8SoundEvent):void 
		{
			switch (e.type)
			{
				case Chip8SoundEvent.SOUND_OFF:
					toneGenerator.stopTone();
					break;
				case Chip8SoundEvent.SOUND_ON:
					toneGenerator.playTone();
					break;
			}
		}
		
		private function onUpdateRender(e:Chip8Event):void 
		{
			renderer.render(e.displayBytes);
		}
		
		private var state:RomState = null;
		private function shortcuts(e:KeyboardEvent):void 
		{
			switch (e.keyCode)
			{
				case 116:
					state = chip8.getState();
					break;
				case 118:
					chip8.loadState(state);
					break;
				case 82:
					chip8.reset();
					break;
			}
			//trace(e.keyCode);
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			NativeApplication.nativeApplication.exit();
			chip8.traceRender();
		}
	}
}