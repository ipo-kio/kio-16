package com.blackbox
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author rnby.mike
	 */
	public class Segment 
	{
		private var _beginingOfSegment:Point;
		private var _endingOfSegment:Point;
		private var _enterPoint:EnterPoint;
		private var _exitPoint:ExitPoint;		
		
		public function Segment(pt1:Point, pt2:Point, enterPoint:EnterPoint, exitPoint:ExitPoint) 
		{
			_beginingOfSegment = pt1;
			_endingOfSegment = pt2;
			this._enterPoint = enterPoint; 
			this._exitPoint = exitPoint;
		}
		
		public function get enterPoint():EnterPoint
		{
			return _enterPoint;
		}
		
		public function get exitPoint():ExitPoint
		{
			return _exitPoint;
		}
		
		public function get beginingOfSegment():Point
		{
			return _beginingOfSegment;
		}
		
		public function get endingOfSegment():Point
		{
			return _endingOfSegment;
		}
	}

}