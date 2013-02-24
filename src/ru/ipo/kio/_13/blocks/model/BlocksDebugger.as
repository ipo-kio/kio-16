/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 09.02.13
 * Time: 13:52
 */
package ru.ipo.kio._13.blocks.model {

import flash.events.Event;
import flash.events.EventDispatcher;

import ru.ipo.kio._13.blocks.BlocksProblem;

import ru.ipo.kio._13.blocks.BlocksWorkspace;

import ru.ipo.kio._13.blocks.parser.Command;
import ru.ipo.kio._13.blocks.parser.ExecutionError;
import ru.ipo.kio._13.blocks.parser.Program;
import ru.ipo.kio._13.blocks.parser.ProgramIterator;
import ru.ipo.kio._13.blocks.parser.SequenceProgram;
import ru.ipo.kio._13.blocks.view.Editor;
import ru.ipo.kio.api.KioApi;

public class BlocksDebugger extends EventDispatcher {

    public static const MAX_STEPS:int = 1000;

    public static const STATE_NORMAL:int = 0;
    public static const STATE_FINISH:int = 1;
    public static const STATE_ERROR:int = 2;

    private var _initialField:BlocksField; //TODO report if class is self referenced it is not considered as non-used
    private var _currentField:BlocksField;

    private var _step:int = 0;
    private var _state:int = STATE_NORMAL;
    private var _errorMessage:String = null;

    private var _currentCommand:Command; //command that will be executed if the forward button is pressed

    private var _program:Program = SequenceProgram.EMPTY_PROGRAM;
    private var _iterator:ProgramIterator = _program.getProgramIterator();

    private var _programIsRunning:Boolean = false;

    private static const api:KioApi = KioApi.instance(BlocksProblem.ID);

    public function BlocksDebugger(initialField:BlocksField) {
        this.initialField = initialField;

        BlocksWorkspace.instance.editor.editorField.addEventListener(Event.CHANGE, changeHandler);
        BlocksWorkspace.instance.editor.addEventListener(SoftManualEvent.SOFT_MANUAL_ACTION, softManualHandler);
    }

    public function get initialField():BlocksField {
        return _initialField;
    }

    public function get currentField():BlocksField {
        return _currentField;
    }

    public function set initialField(value:BlocksField):void {
        _initialField = value;

        moveToStep(0);
    }

    public function set program(value:Program):void {
        _program = value;

        if (_program == null)
            _program = SequenceProgram.EMPTY_PROGRAM;

        _iterator = _program.getProgramIterator();

        moveToStep(0);
    }

    public function validateFieldBlocks():String {
        if (api.problem.level != 2)
            return null;

        var blocks:int = 0;
        for (var col:int = 0; col < _initialField.boundary; col++)
            blocks += _initialField.getColumn(col).length;

        if (blocks != 10)
            return api.localization.field_errors.left_blocks_fail;

        blocks = 0;
        for (col = _initialField.boundary; col < _initialField.cols; col++)
            blocks += _initialField.getColumn(col).length;

        if (blocks != 10)
            return api.localization.field_errors.right_blocks_fail;

        return null;
    }

    public function get currentCommand():Command {
        return _currentCommand;
    }

    public function mayMoveForward():Boolean {
        return _state == STATE_NORMAL;
    }

    public function mayMoveBack():Boolean {
        return _step > 0;
    }

    public function get step():int {
        return _step;
    }

    public function get state():int {
        return _state;
    }

    public function get errorMessage():String {
        return _errorMessage;
    }

    public function ensureNotAnimated():void {
        if (_programIsRunning) {
            _programIsRunning = false;
            animationFinished();
        }
    }

    public function stepForward(animation:Boolean = false):void {
        if (!mayMoveForward()) {
            ensureNotAnimated();
            return;
        }

        var animationStarted:Boolean = false;

        try {

            if (animation && _currentCommand.mayExecute(_currentField) == null) {
                dispatchEvent(new FieldChangeEvent(true, _currentCommand.command));
                animationStarted = true;
            }

            _currentCommand.execute(_currentField);

            if (!_iterator.hasNext()) {
                _state = STATE_FINISH;
                _currentCommand = null; //not necessary but helpful for debugging
            } else
                _currentCommand = _iterator.next();
        } catch (e:ExecutionError) {
            _state = STATE_ERROR;
            _errorMessage = e.message;
        }

        _step++;

        if (! animationStarted)
            dispatchEvent(new FieldChangeEvent());
    }

    public function stepBack(animation:Boolean = false):void {
        ensureNotAnimated();

        if (!mayMoveBack())
            return;

        var dispatchedAnimationEvent:Boolean = animation;

        switch (_state) {
            case STATE_FINISH:
                _iterator.prev();
                _currentCommand = _iterator.next();

                if (animation)
                    dispatchEvent(new FieldChangeEvent(true, _currentCommand.invertedCommand));

                _currentCommand.execute(_currentField, true);

                break;
            case STATE_ERROR:
                dispatchedAnimationEvent = false;
                break;
            case STATE_NORMAL:
                _iterator.prev(); //should return the same as _currentCommand
                _iterator.prev();
                _currentCommand = _iterator.next();

                if (animation)
                    dispatchEvent(new FieldChangeEvent(true, _currentCommand.invertedCommand));

                _currentCommand.execute(_currentField, true);

                break;
        }

        _step--;
        _state = STATE_NORMAL;

        if (!dispatchedAnimationEvent)
            dispatchEvent(new FieldChangeEvent());
    }

    public function animationFinished():void {
        if (_programIsRunning) {
            if (mayMoveForward()) {
                dispatchEvent(new FieldChangeEvent());
                stepForward(true);
            } else {
                _programIsRunning = false;
                dispatchEvent(new FieldChangeEvent());
            }
        } else
            dispatchEvent(new FieldChangeEvent());
    }

    public function moveToStep(step:int):void {
        ensureNotAnimated();

        _currentField = _initialField.clone();
        _iterator = _program.getProgramIterator();

        if (!_iterator.hasNext()) {
            this._step = -1; //does not really matters
            _state = STATE_FINISH;
            _currentCommand = null;

            dispatchEvent(new FieldChangeEvent());

            return;
        }

        _state = STATE_NORMAL;
        _currentCommand = _iterator.next();

        this._step = 0;

        for (var i:int = 0; i < step; i++)
            if (mayMoveForward())
                stepForward();

        dispatchEvent(new FieldChangeEvent());
    }

    public function toEnd():void {
        ensureNotAnimated();

        while (mayMoveForward() && _step < MAX_STEPS)
            stepForward();

        dispatchEvent(new FieldChangeEvent());
    }

    private function changeHandler(event:Event):void {
        program = BlocksWorkspace.instance.editor.editorField.program;
    }

    public function go():void {
        _programIsRunning = true;
        stepForward(true);
    }

    public function stop():void {
        _programIsRunning = false;
        animationFinished();
    }

    public function get programIsRunning():Boolean {
        return _programIsRunning;
    }

    private function softManualHandler(event:SoftManualEvent):void {
        var editor:Editor = BlocksWorkspace.instance.editor;

        if (event.command < 0) {
            var text:String = editor.editorField.text;
            var len:int = text.length;
            if (len > 0)
                editor.editorField.text = text.substring(0, len - 1);
            toEnd();
            return;
        }

        try {
            var manualCommand:Command = new Command(event.command, -1);
            manualCommand.execute(_currentField);
        } catch (e:Error) {
            return;
        }

        switch (event.command) {
            case Command.LEFT:
                editor.appendText('L');
                break;
            case Command.RIGHT:
                editor.appendText('R');
                break;
            case Command.TAKE:
                editor.appendText('T');
                break;
            case Command.PUT:
                editor.appendText('P');
                break;
        }

        toEnd();
        stepBack(false);
        stepForward(true);
    }
}
}