package com.prankard.chip8.renderers 
{
	import com.prankard.chip8.Chip8;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author James Prankard
	 */
	public class Chip8TextfieldRender extends AbstractChip8Renderer 
	{
		private var textfield:TextField;
		public function Chip8TextfieldRender() 
		{
			textfield = new TextField();
			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.defaultTextFormat = new TextFormat("_sans", 12, 0x000000);
			var s:String = "";
			for (var y:int = 0; y < Chip8.SCREEN_HEIGHT; y++)
			{
				for (var x:int = 0; x < Chip8.SCREEN_WIDTH; x++)
				{
					s += "0";
				}
				s += "\n";
			}
			textfield.text = s;
			addChild(textfield);
		}
		
		override public function render(displayBytes:ByteArray):void 
		{
			displayBytes.position = 0;
			var bytesWidth:Number = Chip8.SCREEN_WIDTH / 8;
			var x:int = 0;
			var y:int = 0;
			var string:String = "";
			while (displayBytes.bytesAvailable > 0)
			{
				var byte:uint = displayBytes.readUnsignedByte();
				var byteString:String = byte.toString(2);
				while (byteString.length < 8)
					byteString = "0" + byteString;
				string += byteString;
				x += 8;
				if (x >= Chip8.SCREEN_WIDTH)
				{
					string += "\n";
					y++;
					x = 0;
				}
			}
			textfield.text = string;
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