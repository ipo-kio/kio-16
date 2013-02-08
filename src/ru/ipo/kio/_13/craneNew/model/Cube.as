/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 14.11.12
 * Time: 0:52
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.craneNew.model {
import flash.events.Event;
import flash.events.EventDispatcher;

public class Cube extends  EventDispatcher{
    public static const EVENT_COLOR_CHANGED: String = "color changed";
    public var _color:int;
    public static const RED:int = 0xFF0000;
    public static const GREEN: int = 0x003300;
    public static const YELLOW: int = 0xFFFF00;
    public static const BLUE: int = 0x0000FF;
    private var _i: int;
    private var _j: int;

    public function Cube(x: int, y: int, color :int = RED) {
        _i = x;
        _j = y;
        _color = color;

    }

    public function get color():int {
        return _color;
    }

    public function set color(value:int):void {
        _color = value;
        dispatchEvent(new Event(EVENT_COLOR_CHANGED));
    }

    public function get i():int {
        return _i;
    }

    public function set i(value:int):void {
        _i = value;
    }

    public function get j():int {
        return _j;
    }

    public function set j(value:int):void {
        _j = value;
    }

    public override function toString():String {
        var col: String;
        switch (color){
            case Cube.RED:
                col = "RED";
                break;
            case Cube.YELLOW:
                col = "YELLOW";
                break;
            case Cube.BLUE:
                col = "BLUE";
                break;
            case Cube.GREEN:
                col = "GREEN";
                break;
            default: "no";
        }
        return super.toString() + "{_color=" + String(col) + ",_i=" + String(_i) + ",_j=" + String(_j) + "}";
    }
}
}
