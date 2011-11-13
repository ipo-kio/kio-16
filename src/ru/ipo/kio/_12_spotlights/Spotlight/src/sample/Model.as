package sample 
{
	import fl.controls.Label;
	import fl.controls.TextArea;
	import flash.events.Event;
	import sample.colorModels.colorControllers.IController;
	import sample.colorModels.colorControllers.RGBController;
	import sample.colorModels.IColor;
	import sample.colorModels.RGB;
	import sample.geometry.Point;
	import sample.geometry.Section;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Osipov Vladimir
	 */
	public class Model 
	{
		
		private var _sprite: Sprite;
		private var _countSpotlights: int; // Количество прожекторов
		private var _arraySpotlights: Array; // Массив прожекторов
		private var _lengthSpotlights: Number// Длина лучей прожекторов
		private var _center: Point; // Центр модели
		private var _radius: Number; // Радиус модели
		private var _resultColor: IColor; // Цвет получаемый при смешешении цветов прожекторов
		
		public function Model(sprite: Sprite, countSpotlights: int, lengthSpotlights: Number, center: Point, radius: Number) {
			_sprite = sprite;
			_countSpotlights = countSpotlights;
			_lengthSpotlights = lengthSpotlights;
			_center = center;
			_radius = radius;
			// Инициализация массива прожекторов
			_arraySpotlights = new Array();
			for (var i: int = 0; i < countSpotlights; i++ ) {
				var j: int;
				if (i != countSpotlights - 1) {
					j = i + 1;
				} else {
					j = 0;
				}
				var firstX: Number = center.x + radius * Math.cos(3 * Math.PI / 2 - (2 * Math.PI * i) / countSpotlights);
				var firstY: Number = center.y + radius * Math.sin(3 * Math.PI / 2 - (2 * Math.PI * i) / countSpotlights);
				var secondX: Number = center.x + radius * Math.cos(3 * Math.PI / 2 - (2 * Math.PI * j) / countSpotlights);
				var secondY: Number = center.y + radius * Math.sin(3 * Math.PI / 2 - (2 * Math.PI * j) / countSpotlights);
				_arraySpotlights[i] = new Spotlight(new Section(new Point(firstX, firstY), new Point(secondX, secondY)), lengthSpotlights, new RGB());
				_arraySpotlights[i].color.newColor();
			}
		}
		
		public function get sprite(): Sprite {
			return _sprite;
		}
		public function get countSpotlights(): int {
			return _countSpotlights;
		}
		public function get arraySpotlights(): Array {
			return _arraySpotlights;
		}
		public function get lengthSpotlights(): Number {
			return _lengthSpotlights;
		}
		public function get center(): Point {
			return _center;
		}
		public function get radius(): Number {
			return _radius;
		}
		public function get resultColor(): IColor {
			return _resultColor;
		}
		
		// Рисует объект на спрайте
		public function view(): void {
			for (var i: int = 0; i < countSpotlights; i++ ) {
				_arraySpotlights[i].view(_sprite);
			}
			_sprite.graphics.beginFill(0xFFFFFF);
			_sprite.graphics.drawCircle(_center.x, _center.y, _radius);
			_sprite.graphics.endFill();
			_sprite.graphics.beginFill(0x000000);
			_sprite.graphics.drawCircle(_center.x, _center.y, _radius - 2);
			_sprite.graphics.endFill();
		}
		// Обновление модели
		public function refresh(arrayIndexSpotlight: Array, conversion: int): void {
			for (var i:int = 0; i < arrayIndexSpotlight.length; i++) 
			{
				_arraySpotlights[arrayIndexSpotlight[i]].refresh(_sprite, conversion);
			}
			_sprite.graphics.beginFill(0xFFFFFF);
			_sprite.graphics.drawCircle(_center.x, _center.y, _radius);
			_sprite.graphics.endFill();
			_sprite.graphics.beginFill(0x000000);
			_sprite.graphics.drawCircle(_center.x, _center.y, _radius - 2);
			_sprite.graphics.endFill();
		}
		
	}

}