/**
 * Created with IntelliJ IDEA.
 * User: kostya
 * Date: 14.11.12
 * Time: 0:56
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.crane.model {
public class Crane {

    private var _hasCube: Boolean = false;
    public function Crane(hasCube: Boolean) {
        _hasCube = hasCube;
    }

    public function get hasCube():Boolean {
        return _hasCube;
    }

    public function set hasCube(value: Boolean):void {
        _hasCube = value;
    }


    public function toString():String {
        return "Crane{_hasCube=" + String(_hasCube) + "}";
    }
}
}
