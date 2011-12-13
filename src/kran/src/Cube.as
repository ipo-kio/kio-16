package  
{
	import flash.display.Stage;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
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
		private var letter:String;
		
		private var graphic:CubeGraphic;
				
		public function Cube(xpos:uint, ypos:uint, color:uint = 0)
		{
			this.color = color;
			this.height = HEIGHT;
			this.width = WIDTH;
			this.xPosition = xpos;
			this.yPosition = ypos;
			this.verticalLock = true;
			this.graphic = new CubeGraphic(xPosition,yPosition,width,height,color);
			this.draw();
		}
		
		public function draw():void
		{			
			this.graphic.draw();
		}
		
		public function clear():void
		{
			this.graphic.clear();
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
		
		public function setLetter(letter : String):void
		{
			this.letter = letter;
			graphic.setText(letter);
		}
		
		public function getLetter():String
		{
			return letter;
		}
		
		public function setColor(color:uint):void
		{
			this.color = color;
			this.graphic.setColor(color);
		}
		
		public function getColor():uint
		{
			return color;
		}
	}

}