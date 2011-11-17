package  
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Eddiw
	 */
	public class CubeGraphic extends Sprite 
	{
		private const RED:uint = 0xFF0000;
		private const ORANGE: uint = 0xF00000;
		
		public function draw(pos :int, width: int, height: int, color: uint):void 
		{
			graphics.beginFill(color);
			graphics.drawRect((pos - 1) * 130 + 30, 450 - height, width, height);
			graphics.endFill();
		}		
	}

}