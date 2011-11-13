package sample 
{
	import adobe.utils.CustomActions;
	import flash.display.Sprite;
	import sample.colorModels.IColor;
	import sample.geometry.Section;
	/**
	 * ...
	 * @author Osipov Vladimir
	 */
	public class Spotlight 
	{
		private var _color: IColor; // Цвет прожектора
		private var _base: Section; // Основа прожектора
		private var _length: Number; // Длина луча прожектора
		private var _x: int;
		private var _y: int;
		
		public function Spotlight(base: Section, length: int, color: IColor) {
			_base = base;
			_length = length;
			_color = color;
		}
		
		public function get color(): IColor {
			return _color;
		}
		public function get base(): Section {
			return _base;
		}
		public function get length(): Number {
			return _length;
		}
		public function set color(color: IColor): void {
			_color = color;
		}
		public function set base(base: Section): void {
			_base = base;
		}
		public function set length(length: Number): void {
			_length = length;
		}
		
		// Отрисовка прожектора
		public function view(sprite: Sprite): void {
			sprite.graphics.beginFill(_color.calcHex(100));
			sprite.graphics.moveTo(_base.firstPoint.x, _base.firstPoint.y);
			sprite.graphics.lineTo(_base.secondPoint.x, _base.secondPoint.y);
			_x = _base.calcCenter().x;
			_y = _base.calcCenter().y;
			if (_base.firstPoint.x <= _base.secondPoint.x) {
				if (_base.firstPoint.y <= _base.secondPoint.y) {
					_x -= _length / Math.sqrt(1 + Math.pow(_base.calcNormalSlope(), 2));
					_y += _length / Math.sqrt(1 + 1 / Math.pow(_base.calcNormalSlope(), 2));
				} else {
					_x += _length / Math.sqrt(1 + Math.pow(_base.calcNormalSlope(), 2));
					_y += _length / Math.sqrt(1 + 1 / Math.pow(_base.calcNormalSlope(), 2));
				}
			} else {
				if (_base.firstPoint.y <= _base.secondPoint.y) {
					_x -= _length / Math.sqrt(1 + Math.pow(_base.calcNormalSlope(), 2));
					_y -= _length / Math.sqrt(1 + 1 / Math.pow(_base.calcNormalSlope(), 2));
				} else {
					_x += _length / Math.sqrt(1 + Math.pow(_base.calcNormalSlope(), 2));
					_y -= _length / Math.sqrt(1 + 1 / Math.pow(_base.calcNormalSlope(), 2));
				}
			}
			sprite.graphics.lineTo(_x, _y);
			sprite.graphics.lineTo(_base.firstPoint.x, _base.firstPoint.y);
			sprite.graphics.endFill();
			sprite.graphics.beginFill(0xFFFFFF);
			//sprite.graphics.drawCircle
		}
		
		// Обновление прожектора
		public function refresh(sprite: Sprite, conversion: int): void {
			sprite.graphics.beginFill(_color.calcHex(conversion));
			sprite.graphics.moveTo(_base.firstPoint.x, _base.firstPoint.y);
			sprite.graphics.lineTo(_base.secondPoint.x, _base.secondPoint.y);
			sprite.graphics.lineTo(_x, _y);
			sprite.graphics.lineTo(_base.firstPoint.x, _base.firstPoint.y);
			sprite.graphics.endFill();
		}
	}

}