package ru.ipo.kio._16.mower.model {
public class Mower {
    private var _i:int;
    private var _j:int;

    private var _di:int;
    private var _dj:int;

    private var _broken:Boolean = false;

    public function Mower(i:int, j:int, di:int, dj:int, broken:Boolean) {
        _i = i;
        _j = j;
        _di = di;
        _dj = dj;
        _broken = broken;
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

    public function left_di():int {
        return -_dj;
    }

    public function left_dj():int {
        return _di;
    }

    public function get broken():Boolean {
        return _broken;
    }

    public function set broken(value:Boolean):void {
        _broken = value;
    }

    public function break_():Mower {
        return new Mower(_i, _j, _di, _dj, true);
    }

    public function move(new_i:int, new_j:int):Mower {
        return new Mower(new_i, new_j, _di, _dj, false);
    }

    public function turnLeft():Mower {
        return new Mower(_i, _j, left_di(), left_dj(), false);
    }

    public function turnRight():Mower {
        return new Mower(_i, _j, -left_di(), -left_dj(), false);
    }

    public function copy():Mower {
        return new Mower(_i, _j, _di, _dj, false);
    }
}
}
