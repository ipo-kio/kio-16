/**
 * Created by Vasiliy on 21.02.2015.
 */
package ru.ipo.kio._15.markov {
public class Level0Data {

    private var _diff:int=0;

    private var _size:int=0;

    private var _oper:int = 0;

    public function Level0Data() {
    }


    public function get diff():int {
        return _diff;
    }

    public function set diff(value:int):void {
        _diff = value;
    }

    public function get size():int {
        return _size;
    }

    public function set size(value:int):void {
        _size = value;
    }

    public function get oper():int {
        return _oper;
    }

    public function set oper(value:int):void {
        _oper = value;
    }
}
}
