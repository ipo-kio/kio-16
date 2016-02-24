package ru.ipo.kio._16.mower.model {
import flash.utils.Dictionary;

public class ProgramTrace {
    public static const STATUS_OK:int = 0;
    public static const STATUS_TIME_OUT:int = 1;

    public static const MAX_STEPS:int = 1000;

    private var _program:Program;

    private var _initial_field: Field;
    private var _mowers:Vector.<Mower>;

    private var _trace:Vector.<State>;

    public function ProgramTrace(program:Program, initial_field:Field, mowers:Vector.<Mower>) {
        _program = program;
        _initial_field = initial_field;
        _mowers = mowers;
    }

    public function get initial_field():Field {
        return _initial_field;
    }

    public function get mowers():Vector.<Mower> {
        return _mowers;
    }

    public function get trace():Vector.<State> {
        return _trace;
    }

    public function run():void {
        trace = new Vector.<State>();

        var initial_state:State = new State(_initial_field, _mowers);

        trace.push(initial_state);

        var prev_state:State = initial_state;
        for (var step:int = 1; step <= MAX_STEPS; step++) {
            var prev_field:Field = prev_state.field;
            var new_mowers:Vector.<Mower> = new <Mower>[];

            var new_mowed_grass:Vector.<Position> = new <Position>[];

            var mower_meets_mower:Dictionary = new Dictionary();

            for each (var m:Mower in prev_state.mowers) {
                if (m.broken)
                    continue;

                var forward_i:int = m.i + m.di;
                var forward_j:int = m.j + m.dj;
                var left_i:int = m.i + m.left_di;
                var left_j:int = m.j + m.left_dj;

                var forward_see:int = prev_field.getAt(forward_i, forward_j);
                var left_see:int = prev_field.getAt(left_i, left_j);

                if (forward_see == Field.FIELD_GRASS_MOWED && prev_state.getMowerAt(forward_i, forward_j) != null)
                    forward_see = Field.FIELD_PROGRAM_MOWER;
                if (left_see == Field.FIELD_GRASS_MOWED && prev_state.getMowerAt(left_i, left_j) != null)
                    left_see = Field.FIELD_PROGRAM_MOWER;

                var c:int = _program.getCommandAt(left_see, forward_see);

                var new_mower:Mower;
                switch (c) {
                    case Field.FIELD_FORWARD:
                        var target_cell:int = prev_field.getAt(forward_i, forward_j);

                        var forward_mower:Mower = prev_state.getMowerAt(forward_i, forward_j);
                        mower_meets_mower[m] = forward_mower; //may assign null

                        if (target_cell == Field.FIELD_SWAMP || target_cell == Field.FIELD_TREE) {
                            new_mower = m.move(forward_i, forward_j);
                            new_mower.broken = true;
                        } else if (target_cell == Field.FIELD_GRASS || target_cell == Field.FIELD_GRASS_MOWED) {
                            new_mower = m.move(forward_i, forward_j);
                            if (target_cell == Field.FIELD_GRASS)
                                new_mowed_grass.push(new Position(new_mower.i, new_mower.j));
                        }
                        break;
                    case Field.FIELD_TURN_LEFT:
                        new_mower = m.turnLeft();
                        break;
                    case Field.FIELD_TURN_RIGHT:
                        new_mower = m.turnRight();
                        break;
                    case Field.FIELD_NOP:
                        new_mower = m.copy();
                }

                new_mowers.push(new_mower);
            }

            var field:Field = prev_field.deriveGrass(new_mowed_grass);

            break_mowers(new_mowers, mower_meets_mower);

            prev_state = new State(field, new_mowers);
            trace.push(prev_state);
        }
    }

    private static function break_mowers(new_mowers:Vector.<Mower>, mower_meets_mower:Dictionary):void {
        for each (var mower:Mower in new_mowers) {
            //if there are two mowers at the same place
            for each (var second:Mower in new_mowers)
                if (mower.isAt(second.i, second.j)) {
                    mower.broken = true;
                    second.broken = true;
                }

            //if mowers go through each other

            if (mower in mower_meets_mower)
                second = mower_meets_mower[mower];
                if (mower_meets_mower[second] == mower) {
                    mower.broken = true;
                    second.broken = true;
                }
        }

    }

}
}
