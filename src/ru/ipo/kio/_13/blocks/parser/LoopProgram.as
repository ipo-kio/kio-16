/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 20:18
 */
package ru.ipo.kio._13.blocks.parser {

public class LoopProgram implements Program {

    private var _program:Program;
    private var _count:int; //may not be zero

    public function LoopProgram(program:Program, count:int) {
        _program = program;
        _count = count;
    }

    public function getProgramIterator(from_end:Boolean = false):ProgramIterator {
        return new MyIterator(this, from_end);
    }

    public function get count():int {
        return _count;
    }

    public function get program():Program {
        return _program;
    }
}
}

import ru.ipo.kio._13.blocks.parser.Command;
import ru.ipo.kio._13.blocks.parser.LoopProgram;
import ru.ipo.kio._13.blocks.parser.ProgramIterator;

class MyIterator implements ProgramIterator {

    private var prg:LoopProgram;
    private var ind:int;
    private var it:ProgramIterator;

    public function MyIterator(prg:LoopProgram, from_end:Boolean) {
        this.prg = prg;

        ind = from_end ? prg.count - 1 : 0;
        it = prg.getProgramIterator(from_end)
    }

    public function hasNext():Boolean {
        while (! it.hasNext() && ind + 1 < prg.count) {
            ind ++;
            it = prg.program.getProgramIterator();
        }

        return it.hasNext();
    }

    public function hasPrev():Boolean {
        while (! it.hasPrev() && ind > 0) {
            ind --;
            it = prg.program.getProgramIterator(true);
        }

        return it.hasPrev();
    }

    public function next():Command {
        if (! hasNext()) //needed to move pointer
            return null;

        return it.next();
    }

    public function prev():Command {
        if (! hasPrev()) //needed to move
            return null;

        return it.prev();
    }
}