/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 13.02.13
 * Time: 20:59
 */
package ru.ipo.kio._13.blocks.model {

import flash.events.Event;

import ru.ipo.kio._13.blocks.parser.Command;

public class FieldChangeEvent extends Event {

    public static const FIELD_CHANGED:String = 'field changed';
    private var _animationPhase:Boolean;
    private var _command:Command;

    public function FieldChangeEvent(animationPhase:Boolean = false, command:Command = null) {
        super(FIELD_CHANGED);
        _animationPhase = animationPhase;
        _command = command;

    }

    public function get animationPhase():Boolean {
        return _animationPhase;
    }

    public function get command():Command {
        return _command;
    }
}
}
