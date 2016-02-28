package ru.ipo.kio._16.mower.model {
public class Command {

    private var _action:int;
    private var _state:int;
    private var _i_lookup:int;
    private var _j_lookup:int;

    public function Command(action:int, state:int, i_lookup:int, j_lookup:int) {
        _action = action;
        _state = state;
        _i_lookup = i_lookup;
        _j_lookup = j_lookup;
    }

    public function get action():int {
        return _action;
    }

    public function get state():int {
        return _state;
    }

    public function get i_lookup():int {
        return _i_lookup;
    }

    public function get j_lookup():int {
        return _j_lookup;
    }
}
}
