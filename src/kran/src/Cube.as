package  
{
	import flash.display.Stage;
	/**
	 * ...
	 * @author Eddiw
	 */
	public class Cube /*implements IMove*/
	{
		
		private const HEIGHT:int = 100;
		private const WIDTH:int = 80;
		
		private var color:int;
		private var height:uint;
		private var width:uint;
		private var xPosition:uint;
		private var yPosition:uint
		private var verticalLock:Boolean;
		
		private var graphic:CubeGraphic;
				
		public function Cube(xpos:uint, ypos:uint)
		{
			this.color = 0;
			this.height = HEIGHT;
			this.width = WIDTH;
			this.xPosition = xpos;
			this.yPosition = ypos;
			this.verticalLock = true;
			this.graphic = new CubeGraphic();
			this.draw();
		}
		
		public function draw():void
		{			
			this.graphic.draw(xPosition, yPosition, width, height, color);
		}
		
		public function movePosition(dx:int):void
		{
			this.xPosition += dx;
		}
		
		public function get Position():uint
		{
			return this.xPosition;
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
		
		public function moveDown(howMuch:int):void
		{
			if (!verticalLock) {
				verticalLock = !verticalLock;
				graphic.moveDown(howMuch);
			}
				
		}
		public function moveUp():void
		{
			if (verticalLock) {
				verticalLock = !verticalLock;
				graphic.moveUp(400 - (this.yPosition*HEIGHT));
			}
		}
		
		public function setYpos(ypos:int):void
		{
			yPosition = ypos;
		}
	}

}