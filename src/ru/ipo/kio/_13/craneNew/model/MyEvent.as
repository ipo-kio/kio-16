/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 06.02.13
 * Time: 3:48
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.craneNew.model {
import flash.events.Event;

public class MyEvent extends Event{
    private var _x_old: int;
    private var _y_old: int;
    public function MyEvent(type: String, x_old, y_old: int) {
        super(type);
        _x_old = x_old;
        _y_old = y_old;

    }

    public function get x_old():int {
        return _x_old;
    }

    public function get y_old():int {
        return _y_old;
    }
}
}
