package  
{
	/**
	 * ...
	 * @author Eddiw
	 */
	public class ColorTask extends Task 
	{
		private const RED:uint = 0xFF0000;
		private const ORANGE:uint = 0xFF8800;
		private const YELLOW:uint = 0xFFFF00;
		private const GREEN:uint = 0x00FF00;
		private const LIGHTBLUE:uint = 0x00FFFF;
		private const BLUE:uint = 0x0000AA;
		private const MAGENTA:uint = 0xFF00FF;
		
		private var ColorArray:Array;
		
		public function ColorTask(array:Array) 
		{
			super(array);
			ColorArray = new Array(RED, ORANGE, YELLOW, GREEN, LIGHTBLUE, BLUE, MAGENTA);
			initCubes();
		}
		
		private function initCubes():void
		{
			for (var i:int = 0; i < 8; i++ )
				coordinates[i] = new Array(0);
			this.setCubes(2, 2);
			this.setCubes(3, 1);
			this.setCubes(4, 1);
			this.setCubes(6, 3);
			
			var num : int = 0;
			for (var j:int = 0; j < 8; j++ )
			{
				for each(var c : Cube in coordinates[j])
				{
					c.setColor(ColorArray[num]);
					++num;
				}
			}
		}
		
		public override function isSolved():Boolean
		{
			var i : int = 0;
			for each(var Arr : Array in coordinates)
			{
				try{
				if (Arr[0].getColor() != ColorArray[i])
					return false;
				}catch (e: TypeError){
					return false;
				}
				++i;
				if (i == 7)
				break;
			}
			return true;
		}
		
	}

}