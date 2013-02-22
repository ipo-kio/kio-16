/**
 *
 * @author: Vasiliy
 * @date: 03.01.13
 */
package ru.ipo.kio._13.clock.utils {
import flash.geom.Point;

public class MathUtils {

    public static const SIMPLE_NUMBERS:Array = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97];

    public function MathUtils(pvt:PrivateClass) {
    }

    public static function rotate(point:Point, alpha:Number):Point{
      return new Point(point.x*Math.cos(alpha)+point.y*Math.sin(alpha), -point.x*Math.sin(alpha)+point.y*Math.cos(alpha));
    }

    public static function distance(x:int, y:int, x2:int, y2:int):int {
        return Math.pow(Math.pow(x-x2,2)+Math.pow(y-y2,2),0.5);
    }
}
}

internal class PrivateClass{
    public function PrivateClass(){
    }
}
