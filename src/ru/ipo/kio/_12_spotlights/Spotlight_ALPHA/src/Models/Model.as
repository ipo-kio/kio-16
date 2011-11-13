package Models 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import ModelComponents.Stage.StageControllers.StageControllersBuilder;
	/**
	 * ...
	 * @author ovv
	 */
	public class Model 
	{
		
		private var _sprite: Sprite;
		private var _stage: Stage;
		private var _controllersSprite: Sprite;
		
		public function Model(sprite: Sprite, controllersSprite: Sprite, ) {
			_sprite = sprite;
			_countSpotlights = countSpotlights;
			_lengthSpotlights = lengthSpotlights;
			_center = center;
			_radius = radius;
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