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
		private var linker: Linker;
		private var takenCube:Cube;
		
		
		public function Executor() 
		{
			cubeArray = new Array(8);
			for (var i:int = 0; i < 8; i++)
//
			linker = new Linker;
		}

		public function init(stage : Stage):void
		{
			//инициализация массива кубиков
			for ( var i:int = 0; i < 5; i++)
				cubeArray[i] = new Cube(i);
			//рисуем
			for each(var cube:Cube in cubeArray)
			{
				cube.addToStage(stage);		
				cube.draw();
			}
				
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
					// если под краном ничего нет ИЛИ (кран открыт И кран пуст)
					if (cubeArray[kran.Position] == null || (!kran.isClosed() && !kran.hasCube()))
						kran.moveDown();
					break;
				}
				case 38: //Up Arrow
				{
					kran.moveUp();
					break;
				}
				case 67: //'C' Close
				{
					
					kran.close();
					if (kran.isDown() && cubeArray[kran.Position] != undefined)
					{
						takeCube(cubeArray[kran.Position]);
					}
					break;
				}
				case 82: //'R' Release
				{
					try
					{
						if (kran.isDown())
							putCube(kran.getCube());
						kran.release();	
					}
					catch (e:String)
					{
						trace(e);
					}
				}
			}
		}
			//Вытащить из массива чтобы потом перетащить в нужную позицию
			private function takeCube(cube:Cube):void
			{
				linker.link(kran, cube);
				cubeArray[kran.Position] = null;
			}
			//положить в массив
			private function putCube(cube:Cube):void
			{
				//if (cubeArray[cube.Position] == null);
				cubeArray[kran.Position] = kran.getCube();
			}
	}
}
