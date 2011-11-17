package
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	/**
	 * ...
	 * @author Eddiw
	 */
	
	public class Executor 
	{
		private var kran:Kran;
		private var cubeArray: Array;
		
		public function Executor() 
		{
			cubeArray = new Array;
		}

		public function init(stage : Stage):void
		{
			//инициализация массива кубиков
			for ( var i:int = 1; i < 5; i++)
				cubeArray.push(new Cube(i).addToStage(stage));
			
			kran = new Kran();
			kran.addToStage(stage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
		}
		
		public function keyHandler(event:KeyboardEvent):void {
			switch (event.keyCode)
			{
				case 39: //Right Arrow
				{
					kran.moveRight();
					break;
				}
				case 37: //Left Arrow
				{
					kran.moveLeft();
					break;
				}
				case 40: //Down Arrow
				{
					kran.moveDown();
					break;
				}
				case 38: //Up Arrow
				{
					kran.moveUp();
					break;
				}
				case 32: //Space
				{
					kran.close();
					break;
				}
			}
		}
	}
}
