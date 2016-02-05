package ru.ipo.kio._16.mars.model {
public class ShipHistoryEntry {

    private var _time:int;
    private var _dV:Vector2D;

    public function ShipHistoryEntry(time:int, dV:Vector2D) {
        _time = time;
        _dV = dV;
    }

    public function get time():int {
        return _time;
    }

    public function get dV():Vector2D {
        return _dV;
    }
}
}
