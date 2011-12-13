package  
{
	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	 * ...
	 * @author Eddiw
	 */
	public class ArrayGraphic extends Sprite
	{
		public const STEP: int = 130;
		public function ArrayGraphic(): void
		{
			graphics.lineStyle(3);
			for (var i:int = 0; i < 8; i++)
			{
				graphics.moveTo(STEP * i, 600);
				graphics.lineTo(STEP * i, 650);
				graphics.lineTo(STEP * i + STEP, 650);
			}
			graphics.lineTo(STEP * i, 600);
		}
		public function addToStage(stage:Stage):void
		{
			stage.addChild(this)
		}
	}

}