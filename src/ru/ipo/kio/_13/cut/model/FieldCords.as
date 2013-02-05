/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 25.01.13
 * Time: 16:32
 */
package ru.ipo.kio._13.cut.model {
public class FieldCords {

    private var _x:int = 0;
    private var _y:int = 0;

    public function FieldCords(x:int, y:int) {
        _x = x;
        _y = y;
    }

    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }

    public function equals(value:FieldCords):Boolean {
        if (value == null)
            return false;
        return _x == value._x && _y == value._y;
    }
}
}
