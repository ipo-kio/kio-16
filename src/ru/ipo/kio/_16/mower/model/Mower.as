package ru.ipo.kio._16.mower.model {
public class Mower {
    private var _i:int;
    private var _j:int;

    private var _di:int;
    private var _dj:int;

    private var _broken:Boolean = false;

    private var _state:int;

    public function Mower(i:int, j:int, di:int, dj:int, broken:Boolean, state:int = 1) {
        _i = i;
        _j = j;
        _di = di;
        _dj = dj;
        _broken = broken;
        _state = state;
    }

    public function get i():int {
        return _i;
    }

    public function get j():int {
        return _j;
    }

    public function get di():int {
        return _di;
    }

    public function get dj():int {
        return _dj;
    }

    public function isAt(i:int, j:int):Boolean {
        return i == _i && j == _j;
    }

    //up -1, 0
    //left 0, -1

    public function get left_di():int {
        return -_dj;
    }

    public function get left_dj():int {
        return _di;
    }

    public function get broken():Boolean {
        return _broken;
    }

    public function set broken(value:Boolean):void {
        _broken = value;
    }

    public function break_():Mower {
        return new Mower(_i, _j, _di, _dj, true, _state);
    }

    public function move(new_i:int, new_j:int, state:int = -1):Mower {
        return new Mower(new_i, new_j, _di, _dj, _broken, getState(state));
    }

    public function turnLeft(state:int = -1):Mower {
        return new Mower(_i, _j, left_di, left_dj, false, getState(state));
    }

    public function turnRight(state:int = -1):Mower {
        return new Mower(_i, _j, -left_di, -left_dj, false, getState(state));
    }

    public function copy(state:int = -1):Mower {
        return new Mower(_i, _j, _di, _dj, _broken, getState(state));
    }

    public function get state():int {
        return _state;
    }

    public function getState(s:int):int {
        if (s >= 0)
            return s;
        else
            return _state;
    }
}
}
