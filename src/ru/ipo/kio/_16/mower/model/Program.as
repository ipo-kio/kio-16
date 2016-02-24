package ru.ipo.kio._16.mower.model {

public class Program {

    private var _commands: Field;

    public function Program(canSeeMower:Boolean = true) {
        var size:int = canSeeMower ? 5 : 4;
        _commands = new Field(size, size, Field.FIELD_NOP);

        _commands.setAt(0, 0, Field.FIELD_EMPTY);

        _commands.setAt(0, 1, Field.FIELD_PROGRAM_GRASS);
        _commands.setAt(0, 2, Field.FIELD_PROGRAM_TREE);
        _commands.setAt(0, 3, Field.FIELD_PROGRAM_SWAMP);
        if (canSeeMower)
            _commands.setAt(0, 4, Field.FIELD_PROGRAM_MOWER);

        _commands.setAt(1, 0, Field.FIELD_PROGRAM_GRASS);
        _commands.setAt(2, 0, Field.FIELD_PROGRAM_TREE);
        _commands.setAt(3, 0, Field.FIELD_PROGRAM_SWAMP);
        if (canSeeMower)
            _commands.setAt(4, 0, Field.FIELD_PROGRAM_MOWER);
    }

    public function get commands():Field {
        return _commands;
    }

    public function getCommandAt(i:int, j:int):int {
        return _commands.getAt(i + 1, j + 1);
    }
}
}
