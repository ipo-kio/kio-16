package ru.ipo.kio._12.stagelights 
{
	
	
	/**
	 * ...
	 * @author ovv
	 */
	public class MRoundWorkspace implements IWorkspace{
		
		private var _x: Number;
		private var _y: Number;
		private var _radius: Number;
		
		public function MRoundWorkspace(x: Number, y: Number, radius: Number) {
			_x = x;
			_y = y;
			_radius = radius;
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
		
		public function get radius(): Number {
			return _radius;
		}
		public function set radius(value: Number): void {
			_radius = value;
		}
		
		public function inSpace(x: Number, y: Number, radius: Number): Boolean {
			return (_radius >= radius + Math.sqrt(Math.pow(_x - x, 2) + Math.pow(_y - y, 2)));
		}
		
		public function dx(x: Number, y: Number, radius: Number): Number {
			return (_x - x) / 20;
		}
		
		public function dy(x: Number, y: Number, radius: Number): Number {
			return (y - _y) / 20;
		}
		
	}

}