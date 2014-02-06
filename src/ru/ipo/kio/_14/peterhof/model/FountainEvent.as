/**
 * Created by ilya on 19.01.14.
 */
package ru.ipo.kio._14.peterhof.model {
import flash.events.Event;

public class FountainEvent extends Event {

    public static const ADDED:String = 'added';
    public static const REMOVED:String = 'removed';
    public static const SELECTION_CHANGED:String = 'selection changed';
    public static const CHANGED:String = 'changed';

    private var _fountain:Fountain;
    private var _previousFountain:Fountain;

    public function FountainEvent(eventType:String, fountain:Fountain, previousFountain:Fountain = null) {
        super(eventType);
        _fountain = fountain;
        _previousFountain = previousFountain;
    }

    public function get fountain():Fountain {
        return _fountain;
    }

    public function get previousFountain():Fountain {
        return _previousFountain;
    }
}
}
