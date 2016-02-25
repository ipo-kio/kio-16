package ru.ipo.kio._16.mower.model {

public class Program {

    private var _commands: Field;

    public function Program(canSeeMower:Boolean = true) {
        var size:int = canSeeMower ? 6 : 5;
        _commands = new Field(size, size, Field.FIELD_NOP);

        _commands.setAt(0, 0, Field.FIELD_EMPTY);

        _commands.setAt(0, 1, Field.FIELD_PROGRAM_GRASS);
        _commands.setAt(0, 2, Field.FIELD_PROGRAM_MOWED_GRASS);
        _commands.setAt(0, 3, Field.FIELD_PROGRAM_TREE);
        _commands.setAt(0, 4, Field.FIELD_PROGRAM_SWAMP);
        if (canSeeMower)
            _commands.setAt(0, 5, Field.FIELD_PROGRAM_MOWER);

        _commands.setAt(1, 0, Field.FIELD_PROGRAM_GRASS);
        _commands.setAt(2, 0, Field.FIELD_PROGRAM_MOWED_GRASS);
        _commands.setAt(3, 0, Field.FIELD_PROGRAM_TREE);
        _commands.setAt(4, 0, Field.FIELD_PROGRAM_SWAMP);
        if (canSeeMower)
            _commands.setAt(5, 0, Field.FIELD_PROGRAM_MOWER);
    }

    public function get commands():Field {
        return _commands;
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

    public function getCommandAt(left_see:int, program_see:int):int {
        return _commands.getAt(see2prg(left_see), see2prg(program_see));
    }
}
}
