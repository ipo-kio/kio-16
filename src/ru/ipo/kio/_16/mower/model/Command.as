package ru.ipo.kio._16.mower.model {
public class Command {

    private var _action:int;
    private var _state:int;

    public function Command(action:int, state:int) {
        this._action = action;
        this._state = state;
    }

    public function get action():int {
        return _action;
    }

    public function get state():int {
        return _state;
    }
}
}
