package ru.ipo.kio._12.kran.tasks
{
	import flash.display.Stage;
	import ru.ipo.kio._12.kran.*;
	import ru.ipo.kio._12.kran.model.Cube;
	/**
	 * ...
	 * @author Eddiw
	 */
	public class Task 
	{
		protected var solved:Boolean;
		protected var coordinates:Array;	
		public function Task(arr:Array)
		{
			coordinates = arr;
		}
		
		public function setCubes(where:int, count:int):void
		{
			for (var i:int = 1; i <= count; i++ )
				coordinates[where - 1].push(new Cube(where-1,i-1));
		}
		
		public function addToStage(stage:Stage):void
		{
			for (var i:int = 0; i < 8; i ++)
				for each (var c : Cube in coordinates[i])
					c.addToStage(stage);
		}	
		public function isSolved():Boolean
		{
			return solved;
		}
	}
}