package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Eddiw
	 */
	public class CubeGraphic extends Sprite implements IMove
	{
		private const RED:uint = 0xFF0000;
		private const ORANGE: uint = 0xF00000;
		
		private const HORIZONTAL_STEP:int = 130;
		
		public function draw(pos :int, width: int, height: int, color: uint):void 
		{
			graphics.beginFill(color);
			graphics.drawRect((pos) * 130 + 30, 450 - height, width, height);
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
		public function moveDown():void
		{
			this.y += 200;
		}
		public function moveUp():void
		{
			this.y -= 200;
		}
	}

}