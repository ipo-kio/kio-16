/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 09.02.13
 * Time: 13:52
 */
package ru.ipo.kio._13.blocks.model {

import ru.ipo.kio._13.blocks.parser.Command;
import ru.ipo.kio._13.blocks.parser.Program;
import ru.ipo.kio._13.blocks.parser.ProgramIterator;
import ru.ipo.kio._13.blocks.parser.SequenceProgram;

public class BlocksDebugger {

    public static const STATE_NORMAL:int = 0;
    public static const STATE_FINISH:int = 1;
    public static const STATE_ERROR:int = 2;

    public static const MAX_PROGRAM_LENGTH:int = 1000;

    private var _initialField:BlocksField; //TODO report if class is self referenced it is not considered as non-used
    private var _currentFiled:BlocksField;

    private var step:int = 0;
    private var state:int = STATE_NORMAL;

    private var _currentCommand:Command; //command that will be executed if the forward button is pressed

    private var _program:Program = SequenceProgram.EMPTY_PROGRAM;
    private var _iterator:ProgramIterator = _program.getProgramIterator();

    public function BlocksDebugger(initialField:BlocksField) {
        _initialField = initialField;
    }

    public function set program(value:Program):void {
        _program = value;

        moveToStep(0);
    }

    public function get currentCommand():Command {
        return _currentCommand;
    }

    public function mayMoveForward():Boolean {
        return state == STATE_NORMAL;
    }

    public function mayMoveBack():Boolean {
        return step > 0;
    }

    public function stepForward():void {
        if (! mayMoveForward())
            return;

        try {
            _currentCommand.execute(_currentFiled);

            _currentCommand = _iterator.next();

            if (! _iterator.hasNext())
                state = STATE_FINISH;
        } catch (e:Error) {
            state = STATE_ERROR;
        }

        step ++;
    }

    public function stepBack():void {
        if (! mayMoveBack())
            return;

        _currentCommand.execute(_currentFiled, true);

        step --;
        state = STATE_NORMAL;
    }

    public function moveToStep(step:int):void {
        _currentFiled = _initialField.clone();
        _iterator = _program.getProgramIterator();

        if (! _iterator.hasNext()) {
            this.step = -1; //does not really matters
            state = STATE_FINISH;
            _currentCommand = null;
            return;
        }

        state = STATE_NORMAL;
        _currentCommand = _iterator.next();

        step = 0;

        for (var i:int = 0; i < step; i++)
            if (mayMoveForward())
                stepForward();
    }

}
}