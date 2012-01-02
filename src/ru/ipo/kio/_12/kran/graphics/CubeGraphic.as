package ru.ipo.kio._12.kran.graphics
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	import ru.ipo.kio._12.kran.*;
	/**
	 * ...
	 * @author Eddiw
	 */
	
	public class CubeGraphic extends Sprite /*implements IMove*/
	{
		private const RED:uint = 0xFF0000;
		private const ORANGE: uint = 0xF00000;
		private const XHORIZONTAL_STEP:int = 128;
		private const YLOWERBOUND:int = 650
		private const TWEENTIME:Number = 0.5;
		
		private var xPos:int, yPos:int, CGwidth:int, CGheight:int;
		private var color:uint;
		private var txt:TextField;
		
		public function CubeGraphic(xpos :int, ypos:int, width: int, height: int, color: uint)
		{
			this.xPos = xpos;
			this.yPos = ypos;
			this.CGheight = height;
			this.CGwidth = width;
			this.color = color;
		}
		
		public function draw():void 
		{
			graphics.beginFill(color);
			graphics.drawRoundRect( xPos * XHORIZONTAL_STEP + 30, 
									YLOWERBOUND - CGheight - yPos * CGheight,
									CGwidth, 
									CGheight,
									20,
									20);
			graphics.endFill();
		}		
		
		public function moveRight():void
		{
			TweenLite.to(this, TWEENTIME, { x:this.x + XHORIZONTAL_STEP} );
		}
		
		public function moveLeft():void
		{
			TweenLite.to(this, TWEENTIME, { x:this.x - XHORIZONTAL_STEP} );
		}
		
		public function moveDown(howMuch: int):void
		{
			TweenLite.to(this, TWEENTIME, { y:this.y + howMuch} );
		}
		
		public function moveUp(howMuch :int):void
		{
			TweenLite.to(this, TWEENTIME, { y:this.y - howMuch} );
		}
		
		public function clear():void
		{
			this.graphics.clear();
			if(this.txt != null)
				this.txt.text = "";
		}
		
		public function setText(letter:String):void
		{
			txt = new TextField();
			var txtFormat : TextFormat = new TextFormat("arial", 80, 0xFFFFFF, true);
			txt.text = letter;
			txt.x = xPos* XHORIZONTAL_STEP + 35;
			txt.y = 650 - CGheight - yPos * CGheight + 5;
			txt.setTextFormat(txtFormat);
			txt.selectable = false;
			addChild(txt);
		}
		
		public function setColor(color:uint):void
		{
			this.color = color;
			this.graphics.clear();
			this.draw();
		}
	}
}