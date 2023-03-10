package ru.ipo.kio._16.mower.model {
public class State {
    private var _field:Field;
    private var _mowers:Vector.<Mower>;
    private var _unmowed_grass:int;

    public function State(field:Field, mowers:Vector.<Mower>, unmowed_grass:int = -1) {
        _field = field;
        _mowers = mowers;

        if (unmowed_grass < 0)
            unmowed_grass = field.countCells(Field.FIELD_GRASS);

        _unmowed_grass = unmowed_grass;
    }

    public function get field():Field {
        return _field;
    }

    public function get mowers():Vector.<Mower> {
        return _mowers;
    }

    public function get unmowed_grass():int {
        return _unmowed_grass;
    }

    public function getMowerAt(i:int, j:int):Mower {
        for each (var mower:Mower in _mowers)
            if (mower.isAt(i, j))
                return mower;
        return null;
    }

    public function getCommand(program:Program, m:Mower):Command {
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

        return program.getCommandAt(left_see, forward_see, m.state);
    }
}
}
