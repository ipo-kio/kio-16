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

    public function execute(executor:Executor):void {
        var message:String = null;
        switch (_command) {
            case LEFT:
                message = executor.left();
                break;
            case RIGHT:
                message = executor.right();
                break;
            case PUT:
                message = executor.put();
                break;
            case TAKE:
                message = executor.take();
                break;
        }

        if (message != null)
            throw new ExecutionError(_position, message);
    }
}
}
