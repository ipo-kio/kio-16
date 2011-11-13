package ModelComponents.Spotlight 
{
	import ColorModels.ColorsBuilder;
	import flash.display.Sprite;
	import GeometricSamples.Section;
	import ModelComponents.Spotlight.SpotlightControllers.SpotlightControllersBuilder;
	/**
	 * ...
	 * @author ...
	 */
	public class Spotlight 
	{
		private var _controller: SpotlightControllersBuilder
		private var _color: ColorsBuilder; // Цвет прожектора
		private var _base: Section; // Основа прожектора
		private var _length: Number; // Длина луча прожектора
		private var _x: int;
		private var _y: int;
		
		public function Spotlight(base: Section, length: int, color: ColorsBuilder) {
			_base = base;
			_length = length;
			_color = color;
		}
		
		public function get color(): ColorsBuilder {
			return _color;
		}
		public function get base(): Section {
			return _base;
		}
		public function get length(): Number {
			return _length;
		}
		public function get controller(): SpotlightControllersBuilder {
			return _controller;
		}
		public function set color(color: ColorsBuilder): void {
			_color = color;
		}
		public function set base(base: Section): void {
			_base = base;
		}
		public function set length(length: Number): void {
			_length = length;
		}
		
		// Отрисовка прожектора
		public function init(sprite: Sprite): void {
			sprite.graphics.beginFill(_color.calcHex([100]));
			sprite.graphics.moveTo(_base.firstPoint.x, _base.firstPoint.y);
			sprite.graphics.lineTo(_base.secondPoint.x, _base.secondPoint.y);
			_x = _base.calcCenter().x;
			_y = _base.calcCenter().y;
			if (_base.firstPoint.x < _base.secondPoint.x) {
				if (_base.firstPoint.y >= _base.secondPoint.y) {
					_x -= _length / Math.sqrt(1 + Math.pow(_base.calcNormalSlope(), 2));
					_y -= _length / Math.sqrt(1 + 1 / Math.pow(_base.calcNormalSlope(), 2));
				} else {
					_x += _length / Math.sqrt(1 + Math.pow(_base.calcNormalSlope(), 2));
					_y -= _length / Math.sqrt(1 + 1 / Math.pow(_base.calcNormalSlope(), 2));
				}
			} else {
				if (_base.firstPoint.y >= _base.secondPoint.y) {
					_x -= _length / Math.sqrt(1 + Math.pow(_base.calcNormalSlope(), 2));
					_y += _length / Math.sqrt(1 + 1 / Math.pow(_base.calcNormalSlope(), 2));
				} else {
					_x += _length / Math.sqrt(1 + Math.pow(_base.calcNormalSlope(), 2));
					_y += _length / Math.sqrt(1 + 1 / Math.pow(_base.calcNormalSlope(), 2));
				}
			}
			sprite.graphics.lineTo(_x, _y);
			sprite.graphics.lineTo(_base.firstPoint.x, _base.firstPoint.y);
			sprite.graphics.endFill();
		}
		
		// Обновление прожектора
		public function refresh(sprite: Sprite, conversionOptions: Array): void {
			sprite.graphics.beginFill(_color.calcHex(conversionOptions));
			sprite.graphics.moveTo(_base.firstPoint.x, _base.firstPoint.y);
			sprite.graphics.lineTo(_base.secondPoint.x, _base.secondPoint.y);
			sprite.graphics.lineTo(_x, _y);
			sprite.graphics.lineTo(_base.firstPoint.x, _base.firstPoint.y);
			sprite.graphics.endFill();
		}
	}

}