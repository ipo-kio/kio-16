/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 22:15
 */
package ru.ipo.kio._13.blocks.parser {
public class ExecutionError extends Error {

    private var _position:int;

    public function ExecutionError(position:int, message:String) {
        super(message);
        _position = position;
    }

    public function get position():int {
        return _position;
    }
}
}
