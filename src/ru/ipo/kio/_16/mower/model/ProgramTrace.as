package ru.ipo.kio._16.mower.model {
import flash.utils.Dictionary;

public class ProgramTrace {
    public static const STATUS_OK:int = 0;
    public static const STATUS_TIME_OUT:int = 1;

    public static const MAX_STEPS:int = 1000;

    private var _program:Program;

//    private var _initial_field: Field;
//    private var _mowers:Vector.<Mower>;
    private var _initial_state:State;

    private var _fullTrace:Vector.<State>;

    public function ProgramTrace(program:Program, initial_state:State) {
        _program = program;
        _initial_state = initial_state;
    }

    public function get initial_state():State {
        return _initial_state;
    }

    public function get fullTrace():Vector.<State> {
        return _fullTrace;
    }

    public function get statesCount():int {
        return _fullTrace.length;
    }

    public function get lastState():State {
        if (statesCount == 0)
            return null;
        return _fullTrace[fullTrace.length - 1];
    }

    public function run():void {
        _fullTrace = new Vector.<State>();

        _fullTrace.push(_initial_state);

        var prev_state:State = _initial_state;
        var all_was_nops:Boolean = false;
        for (var step:int = 1; step <= MAX_STEPS && !final_state(prev_state) && !all_was_nops; step++) {
            var prev_field:Field = prev_state.field;
            var new_mowers:Vector.<Mower> = new <Mower>[];

            var new_mowed_grass:Vector.<Position> = new <Position>[];

            var mower_meets_mower:Dictionary = new Dictionary();
            var mower_to_old_mower:Dictionary = new Dictionary();
            var mower_to_new_mower:Dictionary = new Dictionary();

            var nops_count:int = 0;
            for each (var m:Mower in prev_state.mowers) {
                if (m.broken) {
                    new_mowers.push(m.copy());
                    continue;
                }

                //warning code duplication (1)
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
                            trace("broke it here");
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
                        nops_count++;
                }

                new_mowers.push(new_mower);
                mower_to_old_mower[new_mower] = m;
                mower_to_new_mower[m] = new_mower;
                all_was_nops = nops_count == new_mowers.length;
            }

            var field:Field = prev_field.deriveGrass(new_mowed_grass);

            break_mowers(new_mowers, mower_meets_mower, mower_to_old_mower, mower_to_new_mower);

            prev_state = new State(field, new_mowers);
            _fullTrace.push(prev_state);
        }
    }

    private static function final_state(state:State):Boolean {
        var has_unbroken_mowers:Boolean = false;
        for each (var m:Mower in state.mowers)
            if (!m.broken) {
                has_unbroken_mowers = true;
                break;
            }

        var has_grass:Boolean = false;

        http://a-label.as/a/link
        for (var i:int = 0; i < state.field.m; i++)
            for (var j:int = 0; j < state.field.n; j++)
                if (state.field.getAt(i, j) == Field.FIELD_GRASS) {
                    has_grass = true;
                    break http;
                }

        return !has_grass || !has_unbroken_mowers;
    }

    private static function break_mowers(new_mowers:Vector.<Mower>, mower_meets_mower:Dictionary, mower_to_old_mower:Dictionary, mower_to_new_mower:Dictionary):void {
        for each (var mower:Mower in new_mowers) {
            //if there are two mowers at the same place
            for each (var second:Mower in new_mowers)
                if (mower != second && mower.isAt(second.i, second.j)) {
                    mower.broken = true;
                    second.broken = true;
                }

            //if mowers go through each other

            var old_mower:Mower = mower_to_old_mower[mower];
            if (old_mower in mower_meets_mower) {
                var old_second:Mower = mower_meets_mower[old_mower];
                second = mower_to_new_mower[old_second];

                if (mower_meets_mower[old_second] == old_mower) {
                    mower.broken = true;
                    second.broken = true;
                }
            }
        }
    }
}
}