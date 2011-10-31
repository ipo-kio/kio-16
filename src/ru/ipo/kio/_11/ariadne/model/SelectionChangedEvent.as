/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 27.02.11
 * Time: 13:58
 */
package ru.ipo.kio._11.ariadne.model {
import flash.events.Event;

public class SelectionChangedEvent extends Event {

    private var _previous_index:int;
    private var _new_index:int;


    public function SelectionChangedEvent(type:String, previous_index:int, new_index:int) {
        super(type);
        _previous_index = previous_index;
        _new_index = new_index;
    }

    public function get previous_index():int {
        return _previous_index;
    }

    public function get new_index():int {
        return _new_index;
    }

}
}
