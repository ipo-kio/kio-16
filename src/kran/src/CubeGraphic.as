package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Eddiw
	 */
	
	public class CubeGraphic extends Sprite /*implements IMove*/
	{
		private const RED:uint = 0xFF0000;
		private const ORANGE: uint = 0xF00000;
		
		private const HORIZONTAL_STEP:int = 130;
		
		public function draw(xpos :int, ypos:int, width: int, height: int, color: uint):void 
		{
			graphics.beginFill(color);
			graphics.drawRoundRect( xpos * 130 + 30, 650 - height - ypos*height, width, height,20,20);
			graphics.endFill();
		}		
		
		public function moveRight():void
		{
			this.x += HORIZONTAL_STEP;
		}
		
		public function moveLeft():void
		{
			this.x -= HORIZONTAL_STEP;
		}
		
		public function moveDown(howMuch: int):void
		{
			this.y += howMuch;
		}
		
		public function moveUp(howMuch :int):void
		{
			this.y -= howMuch;
		}
		
		public function setLetter(str:String):void
		{
			
		}
	}
}