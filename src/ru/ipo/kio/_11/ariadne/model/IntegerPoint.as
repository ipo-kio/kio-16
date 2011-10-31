/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 26.02.11
 * Time: 18:40
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.ariadne.model {
public class IntegerPoint {

    private var _x:int;
    private var _y:int;

    public function IntegerPoint(x:int, y:int) {
        _x = x;
        _y = y;
    }

    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }

    public function equals(p:IntegerPoint):Boolean {
        return p && p._x == _x && p._y == _y;
    }
}
}
