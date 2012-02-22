/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 12.02.12
 * Time: 11:23
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;

public class Vertex2D extends EventDispatcher {

    public static const ZERO:Vertex2D = new Vertex2D(0, 0);

    public static const MOVE:String = 'vertex move';
    private static const MOVE_EVENT:Event = new Event(MOVE);
    
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

    public function set x(value:Number):void {
        _x = value;
        dispatchEvent(MOVE_EVENT);
    }

    public function set y(value:Number):void {
        _y = value;
        dispatchEvent(MOVE_EVENT);
    }
    
    public function setXY(x:Number, y:Number):void {
        _x = x;
        _y = y;
        dispatchEvent(MOVE_EVENT);
    }
    
    public function plus(v:Vertex2D):Vertex2D {
        return new Vertex2D(_x + v.x, _y + v.y);
    }

    public function minus(v:Vertex2D):Vertex2D {
        return new Vertex2D(_x - v.x, _y - v.y);
    }
    
    public function get angle():Number {
        return Math.atan2(_y, _x);
    }
    
    public function mul(a:Number):Vertex2D {
        return new Vertex2D(_x * a, _y * a);
    }

    public function get length():Number {
        return Math.sqrt(_x * _x + _y * _y);
    }

    public function get normalize():Vertex2D {
        var l:Number = length;
        if (length < 1e-8) //TODO
            return new Vertex2D(0, 0);
        else
            return new Vertex2D(_x / l, _y / l);
    }

    override public function toString():String {
        return '(' + _x + ', ' + _y + ')';
    }
}
}