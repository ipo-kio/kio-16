package  
{
	/**
	 * ...
	 * @author Eddiw
	 */
	public class WordTask extends Task
	{
		private var words:Array;
		private var curWord:String;
		public function WordTask(array:Array) 
		{
			super(array);
			words = new Array;
			words.push("TEMPLATE", "IDIOTISM", "PROGRAMS");
			initCubes();
		}
		
		public function initCubes():void
		{
			for (var i:int = 0; i < 8; i++ )
				coordinates[i] = new Array(0);
			this.setCubes(1, 3);
			this.setCubes(2, 2);
			this.setCubes(3, 1);
			this.setCubes(4, 2);
			
			var word: String = getWord();
			curWord = word;
			
			var num : int = 0;
			for (var j:int = 0; j < 8; j++ )
			{
				for each(var c : Cube in coordinates[j])
				{
					c.setLetter(word.charAt(num));
					++num;
				}
			}
		}
		
		public function getWord():String
		{
			return words.pop();
		}		
		
		public override function isSolved():Boolean
		{
			var tmp:String = new String();
			for each (var arr:Array in coordinates)
			{
				try {
					tmp = tmp.concat(arr[0].getLetter());
				}catch (e:TypeError){
					return false;
				}
			}
			return (tmp == curWord);
		}
	}

}