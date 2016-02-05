package ru.ipo.kio._16.mars.model {
public class Vector2D {
    private var _x:Number;
    private var _y:Number;
    private var _r:Number;
    private var _theta:Number;

    public function Vector2D(r:Number, theta:Number, x:Number, y:Number) {
        _r = r;
        _theta = theta;
        _x = x;
        _y = y;
    }

    public static function create(x:Number, y:Number):Vector2D {
        if (Math.abs(x) < Consts._EPS && Math.abs(y) < Consts._EPS)
            return new Vector2D(0, 0, x, y);
        return new Vector2D(Math.sqrt(x * x + y * y), Math.atan2(y, x), x, y);
    }

    public static function createPolar(r:Number, theta:Number):Vector2D {
        return new Vector2D(r, theta, r * Math.cos(theta), r * Math.sin(theta));
    }

    public function get r():Number {
        return _r;
    }

    public function get theta():Number {
        return _theta;
    }

    public function get x():Number {
        return _x;
    }

    public function get y():Number {
        return _y;
    }

    public function vectorMul(v2:Vector2D):Number {
        return _x * v2._y - _y * v2.x;
    }

    public function scalarMul(v2:Vector2D):Number {
        return _x * v2._x + _y * v2._y;
    }

    public function rot90():Vector2D {
//        return createPolar(_r, _theta + Math.PI / 2);
        //noinspection JSSuspiciousNameCombination
        return create(-_y, _x);
    }

    public function neg():Vector2D {
        return create(-_x, -_y);
    }

    public function normalize():Vector2D {
//        if (Math.abs(_r) < Consts._EPS)
//            return this;
        return createPolar(1, _theta);
    }

//    public function addIn(v2:Vector2D):void {
//        _x += v2._x;
//        _y += v2._y;
//    }
//
//    public function mulIn(a:Number):void {
//        _x *= a;
//        _y *= a;
//    }
}
}
