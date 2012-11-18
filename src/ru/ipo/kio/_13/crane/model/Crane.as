/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 14.11.12
 * Time: 0:56
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.model {
public class Crane {
    private var _pos: Position;
    private var _hasCube: Boolean = false;

    public function Crane(i: int, j: int, hasCube: Boolean) {
        _pos = new Position(i, j);
        _hasCube = hasCube;
    }

    public function get hasCube():Boolean {
        return _hasCube;
    }

    public function set hasCube(value: Boolean):void {
        _hasCube = value;
    }


    public function toString():String {
        return "Crane{_pos=" + String(_pos) + ",_hasCube=" + String(_hasCube) + "}";
    }

    public function get pos():Position {
        return _pos;
    }

    public function set pos(value:Position):void {
        _pos = value;
    }
}
}
