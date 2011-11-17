package  
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Eddiw
	 */
	public class Kran
	{
		private const HORIZONTAL_STEP:int = 130;
		
		private var Graphic:KranGraphic;
		
		private var position:uint;
		
		private var height:uint; //насколько опущен
		
		private var closed:Boolean;
		
		private var verticalLock:Boolean // нужен для предотвращения опускания 2 раза подряд
		
		private var cube:Cube;
		
		public function Kran() 
		{
				super();
				Graphic = new KranGraphic();
				Graphic.x = 0;
				Graphic.y = 0;
				position = 0;
				closed = false;
				verticalLock = false;
				close();
		}
		
		public function addToStage(stage:Stage):void
		{
				stage.addChild(this.Graphic);
		}
		
		public function moveLeft():void
		{	
			-- position;
			Graphic.moveLeft(HORIZONTAL_STEP);
		}
		public function moveRight():void
		{ 
			++ position; 
			Graphic.moveRight(HORIZONTAL_STEP);
		}
		
		public function moveDown():void 
		{
			if (!verticalLock)
			Graphic.moveDown();
			verticalLock = true;
		}
		
		public function moveUp():void
		{
			if (verticalLock)
			Graphic.moveUp();
			verticalLock = false;
		}
		public function close():void
		{
			if (!closed)
			{
				closed = true;
				this.Graphic.Rightfoot.rotation -= 30;
				this.Graphic.rotateAroundPoint(Graphic.Leftfoot, 20 , Graphic.leftAxizPoint);
			}
			else release();
		}
		
		public function release():void
		{
			closed = false;
			this.Graphic.Rightfoot.rotation += 30;
			this.Graphic.rotateAroundPoint(Graphic.Leftfoot, -20 , Graphic.leftAxizPoint);
		}
	}

}