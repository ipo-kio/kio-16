package  
{
	import flash.display.Stage;
	/**
	 * ...
	 * @author Eddiw
	 */
	public class Cube implements IMove
	{
		
		private const HEIGHT:int = 100;
		private const WIDTH:int = 80;
		
		private var color:int;
		private var height:uint;
		private var width:uint;
		private var position:uint;
		private var verticalLock:Boolean;
		
		private var graphic:CubeGraphic;
				
		public function Cube(pos:uint)
		{
			this.color = 0;
			this.height = HEIGHT;
			this.width = WIDTH;
			this.position = pos;
			this.verticalLock = true;
			this.graphic = new CubeGraphic();
		}
		
		public function draw():void
		{			
			this.graphic.draw(position, width, height, color);
		}
		
		public function movePosition(dx:int):void
		{
			this.position += dx;
		}
		
		public function get Position():uint
		{
			return this.position;
		}
		
		public function addToStage(stage:Stage):void
		{
			stage.addChild(this.graphic);
		}
		
		public function moveLeft():void
		{
			graphic.moveLeft();
		}
		
		public function moveRight():void
		{
			graphic.moveRight();
		}
		
		public function moveDown():void
		{
			if (!verticalLock) {
				verticalLock = !verticalLock;
				graphic.moveDown();
			}
				
		}
		public function moveUp():void
		{
			if (verticalLock) {
				verticalLock = !verticalLock;
				graphic.moveUp();
			}
		}
	}

}