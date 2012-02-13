/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 12.02.12
 * Time: 11:23
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond {
public class Vertex2D {

    public static const ZERO:Vertex2D = new Vertex2D(0, 0);
    
    private var _x:Number;
    private var _y:Number;
    
    public function Vertex2D(x:Number, y:Number) {
        _x = x;
        _y = y;
    }
    
    public function get x():Number {
        return _x;
    }

    public function get y():Number {
        return _y;
    }


    public function toString():String {
        return '(' + _x + ', ' + _y + ')';
    }
}
}