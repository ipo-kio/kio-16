/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 25.02.11
 * Time: 19:53
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.ariadne.model {
public class RationalPoint {

    private var _x:Rational;
    private var _y:Rational;

    public function RationalPoint(x:Rational, y:Rational) {
        _x = x;
        _y = y;
    }

    public function get x():Rational {
        return _x;
    }

    public function get y():Rational {
        return _y;
    }

    public function equals(p:RationalPoint):Boolean {
        return _x.equals(p._x) && _y.equals(p._y);
    }

    public function toString():String {
        return "RationalPoint{_x=" + String(_x) + ",_y=" + String(_y) + "}";
    }
}
}
