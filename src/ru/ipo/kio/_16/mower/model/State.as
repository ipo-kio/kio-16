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

    public function getCommand(program:Program, m:Mower):int {
        var forward_i:int = m.i + m.di;
        var forward_j:int = m.j + m.dj;
        var left_i:int = m.i + m.left_di;
        var left_j:int = m.j + m.left_dj;

        var forward_see:int = _field.getAt(forward_i, forward_j);
        var left_see:int = _field.getAt(left_i, left_j);

        if (forward_see == Field.FIELD_GRASS_MOWED && getMowerAt(forward_i, forward_j) != null)
            forward_see = Field.FIELD_PROGRAM_MOWER;
        if (left_see == Field.FIELD_GRASS_MOWED && getMowerAt(left_i, left_j) != null)
            left_see = Field.FIELD_PROGRAM_MOWER;

        return program.getCommandAt(left_see, forward_see);
    }
}
}
