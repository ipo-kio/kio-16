package ru.ipo.kio._16.mower.model {
public class State {
    private var _field:Field;
    private var _mowers:Vector.<Mower>;

    public function State(field:Field, mowers:Vector.<Mower>) {
        _field = field;
        _mowers = mowers;
    }

    public function get field():Field {
        return _field;
    }

    public function get mowers():Vector.<Mower> {
        return _mowers;
    }

    public function getMowerAt(i:int, j:int):Mower {
        for each (var mower:Mower in _mowers)
            if (mower.isAt(i, j))
                return mower;
        return null;
    }
}
}
