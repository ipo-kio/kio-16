package ru.ipo.kio._16.mower.model {

public class Program {

    private var _commands: Vector.<Field>;
    private var _states: Vector.<Field>;
    private var _size:int;
    private var _states_num:int;

    public function Program(canSeeMower:Boolean, states_num:int) {
        _states_num = states_num;
        _size = canSeeMower ? 6 : 5;

        _commands = new <Field>[];
        _states = new <Field>[];

        for (var state:int = 0; state < _states_num; state++) {
            var _commands_:Field = new Field(_size, _size, Field.FIELD_FORWARD);

            _commands_.setAt(0, 0, Field.FIELD_EMPTY);

            _commands_.setAt(0, 1, Field.FIELD_PROGRAM_GRASS);
            _commands_.setAt(0, 2, Field.FIELD_PROGRAM_MOWED_GRASS);
            _commands_.setAt(0, 3, Field.FIELD_PROGRAM_TREE);
            _commands_.setAt(0, 4, Field.FIELD_PROGRAM_SWAMP);
            if (canSeeMower)
                _commands_.setAt(0, 5, Field.FIELD_PROGRAM_MOWER);

            _commands_.setAt(1, 0, Field.FIELD_PROGRAM_GRASS);
            _commands_.setAt(2, 0, Field.FIELD_PROGRAM_MOWED_GRASS);
            _commands_.setAt(3, 0, Field.FIELD_PROGRAM_TREE);
            _commands_.setAt(4, 0, Field.FIELD_PROGRAM_SWAMP);
            if (canSeeMower)
                _commands_.setAt(5, 0, Field.FIELD_PROGRAM_MOWER);

            _commands.push(_commands_);

            var _states_:Field = new Field(_size, _size, 0);
            for (var i:int = 1; i < _size; i++)
                for (var j:int = 1; j < _size; j++)
                    _states_.setAt(i, j, state + 1);
            _states_.setAt(0, 0, state + 1);

            _states.push(_states_);
        }
    }

    public function get commands():Vector.<Field> {
        return _commands;
    }

    public function get states():Vector.<Field> {
        return _states;
    }

    public static function see2prg(see:int):int {
        switch (see) {
            case Field.FIELD_GRASS:
                return 1;
            case Field.FIELD_GRASS_MOWED:
                return 2;
            case Field.FIELD_TREE:
                return 3;
            case Field.FIELD_SWAMP:
                return 4;
            case Field.FIELD_PROGRAM_MOWER:
                return 5;
        }
        return see;
    }

    public function getCommandAt(left_see:int, forward_see:int, state:int):Command {
        var i:int = see2prg(left_see);
        var j:int = see2prg(forward_see);

        var action:int = _commands[state - 1].getAt(i, j);
        var new_state:int = _states[state - 1].getAt(i, j);

        return new Command(action, new_state, i, j);
    }

    public function get states_num():int {
        return _states_num;
    }

    public function get as_object():Object {
        var cc:Array = [];
        var ss:Array = [];

        for (var state:int = 0; state < _states.length; state++) {
            var c:Array = [];
            var s:Array = [];

            for (var i:int = 1; i < _size; i++) {
                var c_line:Array = [];
                var s_line:Array = [];
                c.push(c_line);
                s.push(s_line);
                for (var j:int = 1; j < _size; j++) {
                    c_line.push(_commands[state].getAt(i, j));
                    s_line.push(_states[state].getAt(i, j));
                }
            }

            cc.push(c);
            ss.push(s);
        }

        return {c: cc, s: ss};
    }

    public function set as_object(o:Object):void {
//        o = null;
        if (!o)
            return;
        var c:Array = o.c;
        var s:Array = o.s;
        if (!c || !s)
            return;

        if (c.length != states_num)
            return;

        for (var state:int = 0; state < _states_num; state++)
            for (var i:int = 1; i < _size; i++)
                for (var j:int = 1; j < _size; j++) {
                    _commands[state].setAt(i, j, c[state][i - 1][j - 1]);
                    _states[state].setAt(i, j, s[state][i - 1][j - 1]);
                }
    }
}
}
