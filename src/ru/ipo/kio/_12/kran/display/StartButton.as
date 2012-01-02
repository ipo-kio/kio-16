package ru.ipo.kio._12.kran.display
{
	
	/**
	 * ...
	 * @author Eddiw
	 */
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import ru.ipo.kio._12.kran.*;
	
	public class StartButton extends Sprite
	{
		private var button: SimpleButton;
		public function StartButton(x:int, y :int, s:String)
		{
			button = new StartButtonImpl(x,y);
			var text:TextField = new TextField();
			text.text = s;
			text.setTextFormat(new TextFormat("arial", 15, 0x000000, true));
			text.x = x - 5;
			text.y = y - 20;
			text.selectable = false;
			text.width = 60;
			text.height = 20;
			addChild(button);
			addChild(text);
		}
		
		public function addToStage(stage : Stage):void
		{
			stage.addChild(this);
		}
		
		public function disable():void
		{
			button.enabled = false;
		}
		
		public function enable():void
		{
			button.enabled = true;
		}
	}
}
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.StaticText;

//	const XPOS:Number = 900;
//	const YPOS:Number = 680;
		
	class StartButtonImpl extends SimpleButton
	{	
		public function StartButtonImpl(x:int, y:int)
		{
			this.downState = new ButtonState(x, y, 0xFF0000);
			this.upState = new ButtonState(x, y, 0xFF0000);
			this.hitTestState = new ButtonState(x, y, 0x00FF00);
			this.overState = new ButtonState(x, y, 0x000000);
			this.useHandCursor = true;
		}
	}

	class ButtonState extends flash.display.Shape
	{
		static private const SIZE:Number = 20;
		private var xPos:int, yPos:int;
		private var bgColor:uint;
		public function ButtonState(x:int, y:int, bgColor:uint)
		{
			this.xPos = x;
			this.yPos = y;
			this.bgColor = bgColor;
			draw();
		}
		
		private function draw():void
		{
			graphics.lineStyle(4,0xA0FFA0,1);
			graphics.beginFill(bgColor);
			graphics.drawRoundRect(xPos, yPos, 50, 30, 4, 4);
			graphics.endFill();
		}
	}
