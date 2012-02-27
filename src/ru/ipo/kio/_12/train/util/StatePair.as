/**
 * Created by IntelliJ IDEA.
 * User: vakimushkin
 * Date: 27.02.12
 * Time: 10:46
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.train.util {
import ru.ipo.kio._12.train.model.types.ArrowStateType;

public class StatePair {

    private var _number:int;

    private var _arrow:ArrowStateType;


    public function StatePair(number:int, arrow:ArrowStateType) {
        this._number = number;
        this._arrow = arrow;
    }

    public function get number():int {
        return _number;
    }

    public function set number(value:int):void {
        _number = value;
    }

    public function get arrow():ArrowStateType {
        return _arrow;
    }

    public function set arrow(value:ArrowStateType):void {
        _arrow = value;
    }
}
}
