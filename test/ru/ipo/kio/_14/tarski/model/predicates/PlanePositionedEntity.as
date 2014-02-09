/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import ru.ipo.kio._14.tarski.model.properties.PlanePositionable;

public class PlanePositionedEntity implements PlanePositionable{

    private var _x:int;

    private var _y:int;


    public function PlanePositionedEntity(x:int, y:int) {
        this._x = x;
        this._y = y;
    }


    public function get x():int {
        return _x;
    }

    public function get y():int {
        return _y;
    }
}
}
