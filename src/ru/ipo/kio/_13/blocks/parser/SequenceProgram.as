/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 20:18
 */
package ru.ipo.kio._13.blocks.parser {

public class SequenceProgram implements Program {

    public static const EMPTY_PROGRAM:Program = new SequenceProgram();

    private var _commands:Array = []; //array of Program

    public function add(program:Program):void {
        _commands.push(program);
    }

    public function getProgramIterator(from_end:Boolean = false):ProgramIterator {
        return new MyIterator(this, from_end);
    }

    public function get commands():Array {
        return _commands;
    }
}
}

import ru.ipo.kio._13.blocks.parser.Command;
import ru.ipo.kio._13.blocks.parser.ProgramIterator;
import ru.ipo.kio._13.blocks.parser.SequenceProgram;

class MyIterator implements ProgramIterator {

    private var prg:SequenceProgram;
    private var it:ProgramIterator = null; //current iterator
    private var ind:int; //current ind, counting

    private var isEmpty:Boolean;

    public function MyIterator(prg:SequenceProgram, from_end:Boolean) {
        this.prg = prg;

        var subs:Array = prg.commands;
        var subprogramsCount:int = subs.length;

        if (subprogramsCount == 0) {
            isEmpty = true;
            return;
        }

        if (from_end) {
            ind = subprogramsCount - 1;
            it = subs[ind].getProgramIterator(true);
        } else {
            ind = 0;
            it = subs[0].getProgramIterator();
        }
    }

    public function hasNext():Boolean {
        if (isEmpty)
            return false;

        var subs:Array = prg.commands;
        var subprogramsCount:int = subs.length;

        while (! it.hasNext() && ind < subprogramsCount - 1)
            it = subs[++ind].getProgramIterator();

        return it.hasNext();
    }

    public function hasPrev():Boolean {
        if (isEmpty)
            return false;

        var subs:Array = prg.commands;

        while (! it.hasPrev() && ind > 0)
            it = subs[--ind].getProgramIterator(true);

        return it.hasPrev();
    }

    public function next():Command {
        if (! hasNext()) //need to call this because it move iterator
            return null;

        return it.next();
    }

    public function prev():Command {
        if (! hasPrev()) //need to call this because it move iterator
            return null;

        return it.prev();
    }
}