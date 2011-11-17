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
		public function draw(): void
		{
			graphics.lineStyle(3);
			for (var i:int = 0; i < 8; i++)
			{
				graphics.moveTo(STEP * i, 400);
				graphics.lineTo(STEP * i, 450);
				graphics.lineTo(STEP * i + STEP, 450);
			}
			graphics.lineTo(STEP * i, 400);
		}
		public function addToStage(stage:Stage):void
		{
			stage.addChild(this)
		}
	}

}