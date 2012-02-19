package ru.ipo.kio._12.stagelights 
{
	/**
	 * ...
	 * @author ovv
	 */
	public class MRectWorkspace implements IWorkspace
	{
		
		private var _x: Number;
		private var _y: Number;
		private var _width: Number;
		private var _height: Number;
		
		public function MRectWorkspace(x: Number, y: Number, width: Number, height: Number) {
			_x = x;
			_y = y;
			_width = width;
			_height = height;
		}
		
		public function get x(): Number {
			return _x;
		}
		public function set x(value: Number): void {
			_x =  value;
		}
		
		public function get y(): Number {
			return _y;
		}
		public function set y(value: Number): void {
			_y =  value;
		}
		
		public function inSpace(x: Number, y: Number, radius: Number): Boolean {
			return ((x - radius > _x) && (x + radius < _x +_width) && (y - radius > _y) && (y + radius < _y + _height));
		}
		
		public function dx(x: Number, y: Number, radius: Number): Number {
			return ((_x + _width) / 2 - x) / 30;
		}
		
		public function dy(x: Number, y: Number, radius: Number): Number {
			return (y - (_y + _height) / 2) / 30;
		}
	}

}