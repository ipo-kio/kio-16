package GeometricSamples 
{
	/**
	 * ...
	 * @author ovv
	 */
	public class Section 
	{
		
		private var _firstPoint: Point; // Начало отрезка
		private var _secondPoint: Point; // Конец отрезка
		
		public function Section(firstPoint: Point, secondPoint: Point) {
			_firstPoint = firstPoint;
			_secondPoint = secondPoint;
		}
		
		public function get firstPoint(): Point {
			return _firstPoint;
		}
		public function get secondPoint(): Point  {
			return _secondPoint;
		}
		public function set firstPoint(firstPoint: Point): void {
			_firstPoint = firstPoint;
		}
		public function set secondPoint(secondPoint: Point): void {
			_secondPoint = secondPoint;
		}
		
		// Возвращает центр отрезка
		public function calcCenter(): Point {
			return new Point((firstPoint.x + secondPoint.x) / 2, (firstPoint.y + secondPoint.y) / 2);
		}
	
		// Возвращает коэффициент наклона отрезка
		public function calcSlope(): Number {
			if (_firstPoint.x - _secondPoint.x != 0) {
				return  (_firstPoint.y - _secondPoint.y) / (_firstPoint.x - _secondPoint.x);
			} else {
				return 0;
			}
		}
		// Возвращает коэффициент наклона перпендикулятрного отрезка
		public function calcNormalSlope(): Number {
			if (calcSlope() == 0) {
				return 0;
			} else {
				return 1 / calcSlope();
			}
		}
		
	}

}