/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 22:57
 */
package ru.ipo.kio._13.blocks.parser {
import flash.errors.IllegalOperationError;

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

    public function mayExecute(executor:Executor, backwards:Boolean = false):String {
        switch (_command) {
            case LEFT:
                return backwards ? executor.mayRight() : executor.mayLeft();
                break;
            case RIGHT:
                return backwards ? executor.mayLeft() : executor.mayRight();
                break;
            case PUT:
                return backwards ? executor.mayTake() : executor.mayPut();
                break;
            case TAKE:
                return backwards ? executor.mayPut() : executor.mayTake();
                break;
        }

        return null;
    }

    public function execute(executor:Executor, backwards:Boolean = false):void {
        var message:String = mayExecute(executor, backwards);

        if (message != null)
            throw new ExecutionError(_position, message);

        switch (_command) {
            case LEFT:
                if (backwards)
                    executor.right();
                else
                    executor.left();
                break;
            case RIGHT:
                if (backwards)
                    executor.left();
                else
                    executor.right();
                break;
            case PUT:
                if (backwards)
                    executor.take();
                else
                    executor.put();
                break;
            case TAKE:
                if (backwards)
                    executor.put();
                else
                    executor.take();
                break;
        }

    }

    public function getProgramIterator(from_end:Boolean = false):ProgramIterator {
        return new MyIterator(this, from_end);
    }

    public function get position():int {
        return _position;
    }

    public function get command():int {
        return _command;
    }

    public function get invertedCommand():int {
        switch (_command) {
            case LEFT:
                return RIGHT;
            case RIGHT:
                return LEFT;
            case TAKE:
                return PUT;
            case PUT:
                return TAKE;
        }
        throw IllegalOperationError('Can not invert unknown command');
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
