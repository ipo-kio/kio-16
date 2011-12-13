package com.blackbox
{
	import flash.geom.Point;
	import com.blackbox.*;
	/**
	 * ...
	 * @author rnby.mike
	 */
	public class Box 
	{
		private static var _instance:Box;
		private var listOfSegments:Vector.<Point> = new Vector.<Point>;
			
		public function Box(pvt:PrivateClass) 
		{
			//TODO придумать хорошую форму ящика
			
		}
		
		public static function getInstance():Box
		{
			if (Box._instance == null)
			{
				Box._instance = new Box(new PrivateClass());
			}
			else
			{
				trace("Sorry, already have a box");
			}
			return Box._instance;
		}
		
		/**
		 * Подсчет углов, о которые трется веревка
		 * 
		 * @param	pt1 - конец веревки
		 * @param	pt2 - другой конец веревки
		 * @return  массив вершин, о которые трется веревка
		 */
		private function isHook(pt1:Point, pt2:Point):Vector.<Point>
		{
			var listOfHooks:Vector.<Point> = new Vector.<Point>;
			
			for each(var segment:Segment in listOfSegments) 
			{
				if (cross(pt1, pt2, segment.beginingOfSegment, segment.endingOfSegment))
				{	
					listOfHooks.push(segment.endingOfSegment);
					this.isHook(pt1, segment.endingOfSegment);
					this.isHook(segment.endingOfSegment, pt2);
				}
			}
			return listOfHooks;
		}
		
		/**
		 * 
		 * @param	pt1 - точка прямой
		 * @param	pt2 - точка прямой
		 * @param	pt3 - конец отрезка, проверямый на пересечение с прямой
		 * @param	pt4 - другой конец отрезка, проверямый на пересечение с прямой
		 */
		private function cross(pt1:Point, pt2:Point, pt3:Point, pt4:Point):Boolean
		{
			if ((pt3.y - ((pt3.x - pt1.x)(pt2.y - pt1.y)) / (pt2.x - pt1.x) - pt1.y) * (pt4.y - ((pt4.x - pt1.x)(pt2.y - pt1.y)) / (pt2.x - pt1.x) - pt1.y) < 0)
				return true;
			else
				return false;
		}		
	}

}

internal class PrivateClass
{
	public function PrivateClass() {
		
	}
}