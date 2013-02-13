/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 12.02.13
 * Time: 20:53
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.blocks.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio._13.blocks.BlocksProblem;
import ru.ipo.kio._13.blocks.BlocksWorkspace;
import ru.ipo.kio._13.blocks.model.BlocksDebugger;
import ru.ipo.kio._13.blocks.parser.Command;

import ru.ipo.kio.api.KioApi;

public class DebuggerControls extends Sprite {

    private static const BUTTON_WIDTH:int = 80;
    private static const BUTTON_HEIGHT:int = 20;
    private static const TEXT_SIZE:int = 14;
    private static const BUTTON_H_SKIP:int = 4;
    private static const BUTTON_V_SKIP:int = 4;
    private static const BUTTON_X0:int = 4;
    private static const BUTTON_Y0:int = 4;
    private static const WIDTH:int = 500;

    private var loc:Object = KioApi.getLocalization(BlocksProblem.ID);

    private var stepsField:TextField = new TextField();
    private var messageField:TextField = new TextField();
    private var _dbg:BlocksDebugger;

    function DebuggerControls(dbg:BlocksDebugger) {
        _dbg = dbg;

        var skip:int = BUTTON_WIDTH + BUTTON_H_SKIP;
        addButton(loc.buttons.to_start, "start", BUTTON_X0, BUTTON_Y0);
        addButton(loc.buttons.step_back, "-1", BUTTON_X0 + skip, BUTTON_Y0);
        addButton(loc.buttons.step_forward, "+1", BUTTON_X0 + 2 * skip, BUTTON_Y0);
        addButton(loc.buttons.to_end, "end", BUTTON_X0 + 3 * skip, BUTTON_Y0);
        addStepsField(BUTTON_X0 + 4 * skip, BUTTON_Y0);
        addButton(loc.buttons.go, "go", WIDTH - BUTTON_WIDTH, BUTTON_Y0);
        addMessageField(BUTTON_X0, BUTTON_Y0 + BUTTON_HEIGHT + BUTTON_V_SKIP);

        _dbg.addEventListener(BlocksDebugger.STEP_CHANGED_EVENT, dbg_step_changedHandler);

        dbg_step_changedHandler();
    }

    private function set step(value:int):void {
        if (value < 0)
            value = 0;
        stepsField.text = loc.step + " " + value;
    }

    private function setMessage(message:String, isError:Boolean = true):void {
        messageField.text = message;
        var dtf:TextFormat = messageField.defaultTextFormat;
        var tf:TextFormat = new TextFormat(dtf.font, dtf.size, 0x880000);
        if (isError)
            messageField.setTextFormat(tf, 0, message.length);
    }

    private function addStepsField(x:int, y:int):void {
        stepsField.x = x;
        stepsField.y = y;

        stepsField.autoSize = TextFieldAutoSize.LEFT;
        stepsField.defaultTextFormat = new TextFormat("Sanserif", TEXT_SIZE, 0x000000);
        stepsField.text = "";

        addChild(stepsField);
    }

    private function addMessageField(x:int, y:int):void {
        messageField.x = x;
        messageField.y = y;

        messageField.autoSize = TextFieldAutoSize.LEFT;
        messageField.defaultTextFormat = new TextFormat("Sanserif", TEXT_SIZE, 0x008800);
        messageField.text = "";

        addChild(messageField);
    }

    private function addButton(value:String, action:String, x:int, y:int):void {
        var button:Button2 = new Button2(value, action, BUTTON_WIDTH, BUTTON_HEIGHT, TEXT_SIZE);

        button.x = x;
        button.y = y;
        addChild(button);
        button.addEventListener(MouseEvent.CLICK, button_clickHandler);
    }

    private function button_clickHandler(event:MouseEvent):void {
        var action:String = Button2(event.target).action;
        switch (action) {
            case "start":
                _dbg.moveToStep(0);
                break;
            case "+1":
                _dbg.stepForward();
                //do animation
                break;
            case "-1":
                _dbg.stepBack();
                //do animation
                break;
            case "end":
                _dbg.toEnd();
                break;
            case "go":
                //do animation
                break;
        }
    }

    private function dbg_step_changedHandler(event:Event = null):void {
        step = _dbg.step;

        var cmd:Command = _dbg.currentCommand;
        var editor:Editor = BlocksWorkspace.instance.editor;
        if (cmd == null)
            editor.setHighlight(-1);
        else
            editor.setHighlight(cmd.position, true);

        if (editor.editorField.parseError != null) {
            setMessage(loc.msg.parse_error + " " + editor.editorField.parseError);
            return;
        }

        switch (_dbg.state) {
            case BlocksDebugger.STATE_ERROR:
                setMessage(loc.msg.execution_error + " " + _dbg.errorMessage);
                break;
            case BlocksDebugger.STATE_FINISH:
                setMessage(loc.msg.finish, false);
                break;
            case BlocksDebugger.STATE_NORMAL:
                setMessage(loc.msg.no_errors, false);
        }
    }
}
}
