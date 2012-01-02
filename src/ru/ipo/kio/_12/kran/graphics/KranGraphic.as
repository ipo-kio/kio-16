package ru.ipo.kio._12.kran.graphics
{
	
	import flash.display.MorphShape;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Matrix;
	import com.greensock.TweenLite;
	import ru.ipo.kio._12.kran.*;
	
	[Embed(source="../_resources/Kran.swf#Kran")]
	public class KranGraphic extends Sprite {
		
		private const HORIZONTAL_STEP:int = 128;
		private const TWEENTIME:Number = 0.5;
	
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
			//this.x += HORIZONTAL_STEP;
			TweenLite.to(this, TWEENTIME, { x:this.x + HORIZONTAL_STEP} );
		}
		public function moveLeft():void
		{
			//this.x -= HORIZONTAL_STEP;
			TweenLite.to(this, TWEENTIME, { x:this.x - HORIZONTAL_STEP} );
		}
		public function moveDown(howMuch:int):void
		{
			//this.y += howMuch;
			TweenLite.to(this, TWEENTIME, { y:this.y + howMuch} );
			heightBar.scaleY = -20;
		}
		public function moveUp():void
		{
			//this.y = 0;
			TweenLite.to(this, TWEENTIME, { y:0} );
		}
		
		public function reset():void
		{
			this.x = 0;
			this.y = 0;
		}
	}
}
