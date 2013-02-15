/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 09.02.13
 * Time: 1:03
 */
package ru.ipo.kio._13.blocks.model {
public class Block {

    private static const FORBIDDEN_ORDER:Array = []; //array of pairs (x,y) don't put x on y

    private var _color:int;

    public function Block(color:int) {
        _color = color;
    }

    public function get color():int {
        return _color;
    }

    public function set color(value:int):void {
        _color = value;
    }

    public static function registerForbiddenPair(x:int, y:int):void {
        FORBIDDEN_ORDER.push([x, y]);
    }

    public function mayBeUnder(block:Block):Boolean {
        for each (var pair:Array in FORBIDDEN_ORDER)
            if (pair[0] == block._color && pair[1] == _color)
                return false;
        return true;
    }
}
}
