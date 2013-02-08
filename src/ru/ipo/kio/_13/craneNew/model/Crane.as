/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 06.02.13
 * Time: 2:34
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.craneNew.model {
import flash.events.Event;
import flash.events.EventDispatcher;

public class Crane extends EventDispatcher{
    public static const EVENT_CRANE_POSITION_CHANGED: String = "crane changed position";
    private var _i:int;
    private var _j:int;
    private var takenCube: Cube;

    public function Crane(i:int, j:int, cube: Cube = null) {
        _i = i;
        _j = j;
        takenCube = cube;
    }


    override public function toString():String {
        return "Crane{_pos=" + String(_i + ", " + _j) + "}";
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
        var j_old: int = _j;
        _j = value;
        dispatchEvent(new MyEvent(EVENT_CRANE_POSITION_CHANGED, i,  j_old));
    }
}
}
