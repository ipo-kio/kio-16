package ru.ipo.kio._16.mars.model {
public class ShipAction {

    private var _time:int;
    private var _dV:Vector2D;

    public function ShipAction(time:int, dV:Vector2D) {
        _time = time;
        _dV = dV;
    }

    public function get time():int {
        return _time;
    }

    public function get dV():Vector2D {
        return _dV;
    }

    public function set dV(dV:Vector2D):void {
        _dV = dV;
    }
}
}
