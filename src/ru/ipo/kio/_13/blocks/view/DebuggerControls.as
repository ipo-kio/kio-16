/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 12.02.13
 * Time: 20:53
 */
package ru.ipo.kio._13.blocks.view {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio._13.blocks.BlocksProblem;
import ru.ipo.kio._13.blocks.BlocksWorkspace;
import ru.ipo.kio._13.blocks.model.BlocksDebugger;
import ru.ipo.kio._13.blocks.model.FieldChangeEvent;
import ru.ipo.kio._13.blocks.parser.Command;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.controls.ActionButton;
import ru.ipo.kio.api.controls.ButtonBuilder;

public class DebuggerControls extends Sprite {

    private static const BUTTON_WIDTH:int = 100;
    private static const BUTTON_HEIGHT:int = 24;
    private static const TEXT_SIZE:int = 16;
    private static const BUTTON_H_SKIP:int = 4;
    private static const BUTTON_V_SKIP:int = 4;
    private static const BUTTON_X0:int = 4;
    private static const BUTTON_Y0:int = 4;

    private var loc:Object = KioApi.getLocalization(BlocksProblem.ID);

    private var stepsField:TextField = new TextField();
    private var messageField:TextField = new TextField();
    private var _dbg:BlocksDebugger;

    private var buttons:Array = [];

    private var goButton:SimpleButton;
    private var stopButton:SimpleButton;

    private var manualButton:SimpleButton;
    private var stopManualButton:SimpleButton;

    private var _manualRegime:Boolean = true;
    private var _enabled:Boolean = true;

    private var api:KioApi;
    private var _workspace:BlocksWorkspace;

    function DebuggerControls(dbg:BlocksDebugger, workspace:BlocksWorkspace) {
        _workspace = workspace;
        api = _workspace.api;

        _dbg = dbg;

        var level:int = api.problem.level;

        var skip:int = BUTTON_WIDTH + BUTTON_H_SKIP;
        addButton(loc.buttons.to_start, "start", BUTTON_X0, BUTTON_Y0);
        addButton(loc.buttons.step_back, "-1", BUTTON_X0 + skip, BUTTON_Y0);
        addButton(loc.buttons.step_forward, "+1", BUTTON_X0 + 2 * skip, BUTTON_Y0);
        var loc_to_end:String = level == 0 ? loc.buttons.to_end_0 : loc.buttons.to_end;
        addButton(loc_to_end, "end", BUTTON_X0 + 3 * skip, BUTTON_Y0);
        goButton = addButton(loc.buttons.go, "go", BUTTON_X0 + 4 * skip, BUTTON_Y0);
        stopButton = addButton(loc.buttons.stop, "stop", BUTTON_X0 + 4 * skip, BUTTON_Y0);

        if (level == 0) {
            addButton(loc.buttons.clear, "clear", BUTTON_X0 + 5 * skip, BUTTON_Y0, true);
        } else {
            manualButton = addButton(loc.buttons.manual, "man", BUTTON_X0 + 5 * skip, BUTTON_Y0, true);
            stopManualButton = addButton(loc.buttons.stop_manual, "stop man", BUTTON_X0 + 5 * skip, BUTTON_Y0, true);
            stopManualButton.visible = false;
        }

        addStepsField(BUTTON_X0, BUTTON_Y0 + BUTTON_HEIGHT + BUTTON_V_SKIP + 2);

        //remove the two last buttons
        buttons.pop();
        buttons.pop();

        addMessageField(BUTTON_X0 + skip, BUTTON_Y0 + BUTTON_HEIGHT + BUTTON_V_SKIP + 2);

        stopButton.visible = false;

        _dbg.addEventListener(FieldChangeEvent.FIELD_CHANGED, fieldChangedHandler);

        fieldChangedHandler();
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
        stepsField.defaultTextFormat = new TextFormat("KioArial", TEXT_SIZE, 0x000000);
        stepsField.embedFonts = true;
        stepsField.text = "";

        addChild(stepsField);
    }

    private function addMessageField(x:int, y:int):void {
        messageField.x = x;
        messageField.y = y;

        messageField.autoSize = TextFieldAutoSize.LEFT;
        messageField.defaultTextFormat = new TextFormat("KioArial", TEXT_SIZE, 0x006600, true);
        messageField.text = "";
        messageField.embedFonts = true;
        messageField.selectable = false;

        addChild(messageField);
    }

    private function addButton(value:String, action:String, x:int, y:int, great:Boolean = false):SimpleButton {
        var buttonBuilder:ButtonBuilder = new ButtonBuilder(action);
        if (! great) {
            buttonBuilder.upColor = 0xEEEEEE;
            buttonBuilder.downColor = 0xAAAAAA;
        } else if (api.problem.level == 0) {
            buttonBuilder.upColor = 0xf84d65;
            buttonBuilder.downColor = 0xf80d25;
        } else {
            buttonBuilder.upColor = 0x22EE22;
            buttonBuilder.downColor = 0x22AA22;
        }
        buttonBuilder.upHoverColor = 0xEEEE00;
        buttonBuilder.downHoverColor = 0xAAAA00;
        buttonBuilder.borderColor = 0x444444;
        buttonBuilder.innerBorderColor = 0x888888;
        buttonBuilder.font = "KioArial";
        buttonBuilder.embedFont = true;
        buttonBuilder.fontSize = TEXT_SIZE;
        buttonBuilder.fontColor = 0x000000;
        buttonBuilder.title = value;
        buttonBuilder.width = BUTTON_WIDTH;
        buttonBuilder.height = BUTTON_HEIGHT;

        var button:SimpleButton = buttonBuilder.build();

        button.x = x;
        button.y = y;
        addChild(button);
        button.addEventListener(MouseEvent.CLICK, button_clickHandler);

        buttons.push(button);

        return button;
    }

    private function button_clickHandler(event:MouseEvent):void {
        var action:String = ActionButton(event.target).action;



        processAction(action);
    }

    public function processAction(action:String):void {
        api.log('debug controls ' + action);
        switch (action) {
            case "start":
                _dbg.moveToStep(0);
                break;
            case "+1":
                _dbg.ensureNotAnimated();
                _dbg.stepForward(true);
                //do animation
                break;
            case "-1":
                _dbg.stepBack(true);
                //do animation
                break;
            case "end":
                _dbg.toEnd();
                break;
            case "go":
                stopButton.visible = true;
                goButton.visible = false;
                _dbg.go();
                break;
            case "stop":
                stopButton.visible = false;
                goButton.visible = true;
                _dbg.stop();
                break;
            case "man":
                _dbg.ensureNotAnimated();

                manualButton.visible = false;
                stopManualButton.visible = true;

                _workspace.manualRegime = true;
                break;
            case "stop man":
                manualButton.visible = true;
                stopManualButton.visible = false;

                _workspace.manualRegime = false;
                break;
            case "clear":
                _workspace.editor.editorField.text = "";
                break;
        }
    }

    private function fieldChangedHandler(event:FieldChangeEvent = null):void {
        //this method just modifies a view, no internal state is changed, so this method may be called after a while

        if (event != null && event.animationPhase)
            return;

        step = _dbg.step;

        var cmd:Command = _dbg.currentCommand;
        var editor:Editor = _workspace.editor;
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

        if (! _dbg.programIsRunning) {
            stopButton.visible = false;
            goButton.visible = true;
        }
    }

    public function get manualRegime():Boolean {
        return _manualRegime;
    }

    public function set manualRegime(value:Boolean):void {
        _manualRegime = value;

        setEnabled();
    }

    public function get enabled():Boolean {
        return _enabled;
    }

    public function set enabled(value:Boolean):void {
        _enabled = value;

        setEnabled();
    }

    private function setEnabled():void {
        for each (var button:SimpleButton in buttons) {
            button.enabled = _enabled && !_manualRegime;
            button.mouseEnabled = _enabled && !_manualRegime;
        }

        manualButton.enabled = _enabled;
        manualButton.mouseEnabled = _enabled;
        stopManualButton.enabled = _enabled || _manualRegime;
        stopManualButton.mouseEnabled = _enabled || _manualRegime;
    }
}
}
