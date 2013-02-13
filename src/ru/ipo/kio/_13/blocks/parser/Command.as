/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 22:57
 */
package ru.ipo.kio._13.blocks.parser {

public class Command implements Program {

    public static const LEFT:int = 0;
    public static const RIGHT:int = 1;
    public static const PUT:int = 2;
    public static const TAKE:int = 3;

    private var _command:int;
    private var _position:int;

    public function Command(command:int, position:int) {
        _command = command;
        _position = position;
    }

    public function execute(executor:Executor, backwards:Boolean = false):void {
        var message:String = null;
        switch (_command) {
            case LEFT:
                message = backwards ? executor.right() : executor.left();
                break;
            case RIGHT:
                message = backwards ? executor.left() : executor.right();
                break;
            case PUT:
                message = backwards ? executor.take() : executor.put();
                break;
            case TAKE:
                message = backwards ? executor.put() : executor.take();
                break;
        }

        if (message != null)
            throw new ExecutionError(_position, message);
    }

    public function getProgramIterator(from_end:Boolean = false):ProgramIterator {
        return new MyIterator(this, from_end);
    }

    public function get position():int {
        return _position;
    }
}
}

import ru.ipo.kio._13.blocks.parser.Command;
import ru.ipo.kio._13.blocks.parser.ProgramIterator;

class MyIterator implements ProgramIterator {

    private var prg:Command;
    private var ind:int; //current ind, 0 or 1

    public function MyIterator(prg:Command, from_end:Boolean) {
        this.prg = prg;
        ind = from_end ? 1 : 0;
    }

    public function hasNext():Boolean {
        return ind == 0;
    }

    public function hasPrev():Boolean {
        return ind == 1;
    }

    public function next():Command {
        ind ++;
        return prg;
    }

    public function prev():Command {
        ind --;
        return prg;
    }
}
