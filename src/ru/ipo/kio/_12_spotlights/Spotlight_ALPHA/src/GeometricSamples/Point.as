package GeometricSamples 
{
	/**
	 * ...
	 * @author ovv
	 */
	public class Point 
	{
		
		private var _x: Number; // Координата точки по оси X
		private var _y: Number; // Координата точки по оси Y
		
		public function Point(x: Number = 0, y: Number = 0) {
			_x = x;
			_y = y;
		}

		public function get x(): Number {
			return _x;
		}
		public function get y(): Number {
			return _y;
		}
		public function set x(x: Number): void {
			_x = x;
		}
		public function set y(y: Number): void {
			_y = y;
		}
	
	}

}