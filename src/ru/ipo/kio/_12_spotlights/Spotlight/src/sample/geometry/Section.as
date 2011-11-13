package sample.geometry 
{
	/**
	 * ...
	 * @author Osipov Vladimir
	 */
	public class Section 
	{
		
		private var _firstPoint: Point; // Первая точка
		private var _secondPoint: Point; // Вторая точка
		
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
		
		// Возвращает центральную точку отрезка
		public function calcCenter(): Point {
			return new Point((firstPoint.x + secondPoint.x) / 2, (firstPoint.y + secondPoint.y) / 2);
		}
	
		// Возвращает коэффициент наклона отрезка
		public function calcSlope(): Number {
			return  (firstPoint.y - secondPoint.y) / (firstPoint.x - secondPoint.x);
		}
		
	    // Возвращает коэффициент наклона перпендикулярного отрезка
		public function calcNormalSlope(): Number {
			if (firstPoint.x - secondPoint.x != 0) {
				return  (firstPoint.x - secondPoint.x) / (firstPoint.y - secondPoint.y)
			} else {
				return 0;
			}
		}
		
	}

}