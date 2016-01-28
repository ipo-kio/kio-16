package ru.ipo.kio._16.rockgarden.model {
import flash.geom.Point;

public class Line {

    private var _a:Number;
    private var _b:Number;
    private var _c:Number;

    public function Line(a:Number, b:Number, c:Number) {
        _a = a;
        _b = b;
        _c = c;
    }

    public function get a():Number {
        return _a;
    }

    public function get b():Number {
        return _b;
    }

    public function get c():Number {
        return _c;
    }

    public function apply(p:Point):Number {
        return _a * p.x + _b * p.y + _c;
    }

    public function toString():String {
        return a.toFixed(2) + "x + " + b.toFixed(2) + "y + " + c.toFixed(2);
    }
}
}
