package  {
	
	import flash.display.MorphShape;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Matrix;
	
	[Embed(source="../lib/Kran1.swf#Kran")]
	public class KranGraphic extends Sprite implements IMove {
		
		private const HORIZONTAL_STEP:int = 130;
		
		public var Rightfoot: MovieClip;
		public var Leftfoot: MovieClip;
		public var top: MovieClip;
		public var heightBar:MovieClip;
		
		public var leftAxizPoint:Point; // ось вращения левой руки
		
		public function KranGraphic() 
		{
			super();
			this.scaleX = 0.7;
			this.scaleY = 0.7;
			leftAxizPoint = new Point(Leftfoot.width, 0);
		}
		
		public function rotateAroundPoint(target:MovieClip, angle:Number, transformationPoint:Point):void
		{
			var m:Matrix = target.transform.matrix;
		
			transformationPoint= m.transformPoint(transformationPoint);
		
			m.tx -= transformationPoint.x;
			m.ty -= transformationPoint.y;
			m.rotate(angle * (Math.PI / 180));
			m.tx += transformationPoint.x;
			m.ty += transformationPoint.y;
			target.transform.matrix = m;
		}
		
		public function moveRight():void
		{
			this.x += HORIZONTAL_STEP;
		}
		public function moveLeft():void
		{
			this.x -= HORIZONTAL_STEP;
		}
		public function moveDown(howMuch:int):void
		{
			this.y += howMuch;
			heightBar.scaleY = -20;
		}
		public function moveUp():void
		{
			this.y = 0;
			heightBar.scaleY = 1;
		}
	}
}
