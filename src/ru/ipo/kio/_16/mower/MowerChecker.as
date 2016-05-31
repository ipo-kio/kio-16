package ru.ipo.kio._16.mower {
import com.adobe.serialization.json.JSON_k;

import ru.ipo.kio._16.mower.model.Field;
import ru.ipo.kio._16.mower.model.Mower;
import ru.ipo.kio._16.mower.model.Program;
import ru.ipo.kio._16.mower.model.ProgramTrace;
import ru.ipo.kio._16.mower.model.State;
import ru.ipo.kio.base.ExternalProblemChecker;

public class MowerChecker implements ExternalProblemChecker {
    private var _initial_mowers:Vector.<Mower> = new <Mower>[
        new Mower(1, 1, 0, 1, false),
        new Mower(16, 20, 0, -1, false)
    ];
    private var _program:Program;
    private var _program_trace:ProgramTrace;
    private var _field:Field;

    public function MowerChecker(level:int) {
        _program = new Program(_initial_mowers.length >= 2, level + 1);
        _field = new Field(18, 22, MowerWorkspace.INITIAL_FIELD_CELLS);

        for each (var mower:Mower in _initial_mowers)
            _field.setAt(mower.i, mower.j, Field.FIELD_GRASS_MOWED);
    }

    public function set solution(solution:Object):void {
        _program.as_object = solution;
        trace('this is the solution to test: ', JSON_k.encode(solution));
        var initial_state:State = new State(_field, _initial_mowers);
        _program_trace = new ProgramTrace(_program, initial_state);
        _program_trace.run();
    }

    public function get result():Object {
        var state:State = _program_trace.lastState;
        if (state == null)
            return {m: 0, s: 0};
        return {m: state.field.countCells(Field.FIELD_GRASS_MOWED), s: _program_trace.last_grass_change};
    }
}
}
