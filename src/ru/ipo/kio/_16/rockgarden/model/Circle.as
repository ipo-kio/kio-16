package ru.ipo.kio._16.rockgarden.model {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;

public class Circle extends EventDispatcher {

    private var _x:Number;
    private var _y:Number;
    private var _r:Number;
    private var _index:int;

    private var _enabled:Boolean = true;

    public function Circle(x:Number, y:Number, r:Number, index:int) {
        _x = x;
        _y = y;
        _r = r;
        _index = index;
    }

    public function get x():Number {
        return _x;
    }

    public function get y():Number {
        return _y;
    }

    public function get r():Number {
        return _r;
    }

    public function get center():Point {
        return new Point(_x, _y);
    }

    public function set r(r:Number):void {
        _r = r;
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function set center(center:Point):void {
        _x = center.x;
        _y = center.y;
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function get enabled():Boolean {
        return _enabled;
    }

    public function set enabled(value:Boolean):void {
        _enabled = value;
    }

    public function intersects(c2:Circle):Boolean {
        var d:Point = center.subtract(c2.center);
        var r_sum:Number = _r + c2.r;
        return d.x * d.x + d.y * d.y < r_sum * r_sum;
    }

    public function get index():int {
        return _index;
    }

    public function set x(x:Number):void {
        _x = x;
    }

    public function set y(y:Number):void {
        _y = y;
    }
}
}
