package ModelComponents.Stage 
{
	import ColorModels.ColorsBuilder;
	import ColorModels.RGB;
	import flash.display.Sprite;
	import GeometricSamples.Point;
	import GeometricSamples.Section;
	import ModelComponents.Spotlight.Spotlight;
	import ModelComponents.Stage.StageControllers.StageControllersBuilder;
	/**
	 * ...
	 * @author ovv
	 */
	public class Stage 
	{
		private var _center: Point;
		private var _radius: Number;
		private var _color: ColorsBuilder;
		private var _controller: StageControllersBuilder;
		private var _spotlights: Array;
		
		public function Stage(center: Point, radius: Number, countSpotlights: int, lengthSpotlights: Number, color: ColorsBuilder) {
			_center = center;
			_radius = radius;
			_color = color;
			_spotlights = new Array();
			for (var i:int = 0; i < countSpotlights; i++) 
			{
				var j: int;
				if (i != countSpotlights - 1) {
					j = i + 1;
				} else {
					j = 0;
				}
				var firstX: Number = center.x + radius * Math.cos(3 * Math.PI / 2 + (2 * Math.PI * i) / countSpotlights);
				var firstY: Number = center.y + radius * Math.sin(3 * Math.PI / 2 + (2 * Math.PI * i) / countSpotlights);
				var secondX: Number = center.x + radius * Math.cos(3 * Math.PI / 2 + (2 * Math.PI * j) / countSpotlights);
				var secondY: Number = center.y + radius * Math.sin(3 * Math.PI / 2 + (2 * Math.PI * j) / countSpotlights);
				_spotlights[i] = new Spotlight(new Section(new Point(firstX, firstY), new Point(secondX, secondY)), lengthSpotlights, new RGB());
				_spotlights[i].color.randomColor();
			}
		}
		
		public function get center(): Point {
			return _center;
		}
		public function get radius(): Number {
			return _radius;
		}
		public function get color(): uint {
			var colorsArray: Array = new Array();
			for (var i:int = 0; i < _spotlights.length; i++) 
			{
				colorsArray[i] = _spotlights[i].color;
			}
			return _color.mixColor(colorsArray);
		}
		
		public function init(sprite: Sprite): void {
			for (var i: int = 0; i < _spotlights.length; i++ ) {
				_spotlights[i].init(sprite);
			}
			sprite.graphics.beginFill(0xFFFFFF);
			sprite.graphics.drawCircle(_center.x, _center.y, _radius);
			sprite.graphics.endFill();
			sprite.graphics.beginFill(color);
			sprite.graphics.drawCircle(_center.x, _center.y, _radius - 2);
			sprite.graphics.endFill();
		}
		public function refresh(sprite: Sprite): void {
			sprite.graphics.beginFill(color);
			sprite.graphics.drawCircle(_center.x, _center.y, _radius - 2);
			sprite.graphics.endFill();
		}
	}

}