package  
{
	import flash.display.Stage;
	/**
	 * ...
	 * @author Eddiw
	 */
	public class Cube 
	{
		private const HEIGHT:int = 100;
		private const WIDTH:int = 80;
		
		private var color:int;
		private var height:uint;
		private var width:uint;
		private var position:uint;
		
		private var graphic:CubeGraphic;
				
		public function Cube(pos:uint)
		{
			this.color = 0;
			this.height = HEIGHT;
			this.width = WIDTH;
			this.position = pos;
			this.graphic = new CubeGraphic();
			
			graphic.draw(pos, width, height, color);
		}
		public function movePosition(dx:int):void
		{
			this.position += dx;
		}
		
		public function addToStage(stage:Stage):void
		{
			stage.addChild(this.graphic);
		}
	}

}