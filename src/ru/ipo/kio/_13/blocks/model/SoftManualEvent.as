/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 13.02.13
 * Time: 20:59
 */
package ru.ipo.kio._13.blocks.model {

import flash.events.Event;

import ru.ipo.kio._13.blocks.parser.Command;

public class SoftManualEvent extends Event {

    public static const SOFT_MANUAL_ACTION:String = 'soft manual';
    private var _command:int;

    public function SoftManualEvent(command:int = -1) {
        super(SOFT_MANUAL_ACTION);
        _command = command;
    }

    public function get command():int {
        return _command;
    }
}
}
