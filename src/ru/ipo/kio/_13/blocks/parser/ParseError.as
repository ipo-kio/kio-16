/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 06.02.13
 * Time: 22:15
 */
package ru.ipo.kio._13.blocks.parser {
public class ParseError extends Error {

    private var _position:int;
    private var _length:int;

    public function ParseError(position:int, message:String) {
        super(message);
        _position = position;
        _length = 1; //now all tokens have length 1
    }

    public function get position():int {
        return _position;
    }

    public function get length():int {
        return _length;
    }
}
}
