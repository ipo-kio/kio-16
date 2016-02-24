package ru.ipo.kio._16.mower.model {
public class Position {

    private var _i:int;
    private var _j:int;

    public function Position(i:int, j:int) {
        _i = i;
        _j = j;
    }

    public function get i():int {
        return _i;
    }

    public function get j():int {
        return _j;
    }
}
}
