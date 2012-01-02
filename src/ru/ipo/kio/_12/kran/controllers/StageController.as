package ru.ipo.kio._12.kran.controllers
{
	import flash.display.Stage;
	import flash.media.Camera;
	import flash.system.System;
	import flash.trace.Trace;
	import flash.ui.ContextMenu;
	import ru.ipo.kio._12.kran.graphics.ArrayGraphic;
	import ru.ipo.kio._12.kran.model.Cube;
	import ru.ipo.kio._12.kran.model.Kran;
	import ru.ipo.kio._12.kran.tasks.Task;
	import ru.ipo.kio._12.kran.tasks.WordTask;


	/**
	 * ...
	 * @author Eddiw
	 */
	public class StageController 
	{
		private const CUBEHEIGHT: int = 100;
		
		private var kran:Kran;
		private var cubeArray: Array;
		private var task:Task;
		private var stage: Stage;
		private var arr:ArrayGraphic;
		
		public function StageController(stage: Stage) 
		{
			this.stage = stage;
			arr = new ArrayGraphic;
			kran = new Kran();
			kran.addToStage(stage);
			cubeArray = new Array(8);
			task = new WordTask(cubeArray);
			arr.addToStage(stage);	
			task.addToStage(stage);
		}
		public function execCommand(code:String):void
		{
			if ( code == "R") //Right Arrow
				moveRight();
			else if (code =="L") //Left Arrow
				moveLeft();
			else if (code == "D") //Down Arrow
				moveDown();
			else if (code == "U") //Up Arrow
				moveUp();
			else if (code == "C") //'C' Close
				close();
			else if (code == "O") //'R' Release
				release();
		}
		public function moveRight():void
		{
			if (!kran.isDown() && kran.Position < 7)
				kran.moveRight();
		}
		
		public function moveLeft():void
		{
			if (!kran.isDown() && kran.Position > 0)
				kran.moveLeft();
		}
		public function moveDown():void
		{
			// если кран открыт и пуст
			if ((!kran.isClosed() && !kran.hasCube()))
				//если ячейка пустая или в ней ОДИН кубик
				if (cubeArray[kran.Position].length == 0 || cubeArray[kran.Position].length == 1)
					kran.moveDown(400);
				else //если в ячейке больше одного кубика
					kran.moveDown(500 - (checkVertLenghtOfArray(kran.Position)) * CUBEHEIGHT);
			else if (kran.hasCube()) // если в кране есть кубик
				{ // если под краном пусто ИЛИ кран пуст и под краном ОДИН кубик
					if (cubeArray[kran.Position].length == 0 /*|| 
						(!kran.hasCube() && cubeArray[kran.Position].length == 1)*/ )
					kran.moveDown(400);
				else 
					kran.moveDown(500 - (checkVertLenghtOfArray(kran.Position) + 1) * CUBEHEIGHT);
				kran.getCube().setYpos(cubeArray[kran.Position].length);
				} //если в кране кубик и под краном кубик
			else if (kran.hasCube() && cubeArray[kran.Position].length == 1)
			{
				kran.moveDown(300);
			}
		}
		
		public function moveUp():void
		{
			kran.moveUp();
		}
		
		public function close():void
		{
			kran.close();
			if (kran.isDown() && !kran.hasCube())
			{
				takeCube(cubeArray[kran.Position]);
			}
		}
		
		public function release():void
		{
			try
			{
				if (kran.isDown() && kran.isClosed())
					putCube(kran.getCube());
					kran.release();	
			}
			catch (e:String)
			{
				trace(e);
			}
		}
		
		public function reset():void
		{
			for each(var a:Array in cubeArray)
			{
				for each(var c : Cube in a)
					c.clear();
				a.length = 0;
			}
			task = new WordTask(cubeArray);
			task.addToStage(stage);
			kran.reset();
		}
		
		//Вытащить из массива чтобы потом перетащить в нужную позицию
		private function takeCube(vertArr:Array):void
		{
			if(vertArr.length != 0)
				kran.setCube(vertArr.pop());
		}
		//положить в массив
		private function putCube(cube:Cube):void
		{
			if (kran.hasCube()){
				var tmp:Cube = kran.getCube();
				tmp.setYpos(cubeArray[kran.Position].length);
				cubeArray[kran.Position].push(tmp);
			}
		}
		
		private function checkVertLenghtOfArray(xpos:uint):int
		{
			return cubeArray[xpos].length;
		}
		
		public function checkSolution():void
		{
			if (task.isSolved())
				trace("SOLVED!");
			else 
				trace("NOT SOLVED!");
		}
	}
}