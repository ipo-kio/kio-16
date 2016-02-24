package ru.ipo.kio._16.mower.model {

public class Program {

    public static const STATUS_OK:int = 0;
    public static const STATUS_TIME_OUT:int = 1;

    public static const MAX_STEPS:int = 1000;

    private var _commands: Field;


    public function Program(canSeeMower:Boolean = true) {
    }

    public function get commands():Field {
        return _commands;
    }
}
}
