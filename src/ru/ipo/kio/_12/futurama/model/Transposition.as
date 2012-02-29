/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 25.02.12
 * Time: 9:12
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.futurama.model {
public class Transposition {

    private var _e1:int;
    private var _e2:int;

    public function Transposition(e1:int, e2:int) {
        _e1 = Math.min(e1, e2);
        _e2 = Math.max(e1, e2);
    }

    public function get e1():int {
        return _e1;
    }

    public function get e2():int {
        return _e2;
    }

    public function apply(a:Array):void {
        var t:int = a[_e1];
        a[_e1] = a[_e2];
        a[_e2] = t;
    }
    
    public function equals(t:Transposition):Boolean {
        return t._e1 == _e1 && t._e2 == _e2 || t._e1 == _e2 && t._e2 == _e1;
    }
}
}
