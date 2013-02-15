/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 08.02.13
 * Time: 19:15
 */
package ru.ipo.kio._13.blocks.view {

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.MouseEvent;

import ru.ipo.kio._13.blocks.BlocksWorkspace;

public class SoftKeyboard extends Sprite {

    [Embed(source="../resources/left.png")]
    public static const LEFT_CLS:Class;

    [Embed(source="../resources/right.png")]
    public static const RIGHT_CLS:Class;

    [Embed(source="../resources/take.png")]
    public static const TAKE_CLS:Class;

    [Embed(source="../resources/put.png")]
    public static const PUT_CLS:Class;

    [Embed(source="../resources/space.png")]
    public static const SPACE_CLS:Class;

    [Embed(source="../resources/br_left.png")]
    public static const BR_LEFT_CLS:Class;

    [Embed(source="../resources/br_right.png")]
    public static const BR_RIGHT_CLS:Class;

    [Embed(source="../resources/undo.png")]
    public static const UNDO_CLS:Class;

    public static const X0:int = 0;
    public static const Y0:int = 4;
    public static const DX:int = 44;
    public static const DY:int = 44;

    private var actionButtons:Array = []; //of buttons
    private var otherButtons:Array = []; //of buttons

    private var _editor:Editor;

    private var _controlsRegime:Boolean = false;

    public function SoftKeyboard(editor:Editor, simple:Boolean) {
        _editor = editor;
        actionButtons.push(addButton(LEFT_CLS, 'left', X0, Y0, true));
        actionButtons.push(addButton(RIGHT_CLS, 'right', X0 + DX, Y0, true));
        actionButtons.push(addButton(TAKE_CLS, 'take', X0 + 2 * DX, Y0));
        actionButtons.push(addButton(PUT_CLS, 'put', X0 + 3 * DX, Y0));

        otherButtons.push(addButton(SPACE_CLS, 'space', X0 + 5 * DX, Y0));
        if (! simple) {
            otherButtons.push(addButton(BR_LEFT_CLS, 'br left', X0 + 6 * DX, Y0));
            otherButtons.push(addButton(BR_RIGHT_CLS, 'br right', X0 + 7 * DX, Y0));
        }
        otherButtons.push(addButton(UNDO_CLS, 'undo', X0 + 9 * DX, Y0, true));

        if (! simple)
            for (var i:int = 0; i < 10; i++)
                otherButtons.push(addButton("" + i, "num" + i, X0 + i * DX, Y0 + DY));
    }

    private function addButton(value:*, action:String, x:int, y:int, otherType:Boolean = false):SimpleButton {
        if (value is String)
            var button:SimpleButton = otherType ? new Button(value, action) : new Button2(value, action, 40, 40, 20);
        else
            button = otherType ? new Button(value, action) : new Button2(value, action);

        button.x = x;
        button.y = y;
        addChild(button);
        button.addEventListener(MouseEvent.CLICK, button_clickHandler);

        return button;
    }

    private function button_clickHandler(event:MouseEvent):void {
        var action:String = event.target.action;
        var manual:Boolean = BlocksWorkspace.instance.manualRegime;
        switch (action) {
            case 'left':
                 if (manual)
                 {} else
                _editor.appendAtCaret('L');
                break;
            case 'right':
                if (manual)
                {} else
                _editor.appendAtCaret('R');
                break;
            case 'take':
                if (manual)
                {} else
                _editor.appendAtCaret('T');
                break;
            case 'put':
                if (manual)
                {} else
                _editor.appendAtCaret('P');
                break;
            case 'br left':
                _editor.appendAtCaret('(');
                break;
            case 'br right':
                _editor.appendAtCaret(')');
                break;
            case 'space':
                _editor.appendAtCaret(' ');
                break;
            case 'undo':
                _editor.undo(); //TODO make disabled if can not undo
                break;
        }

        if (action.indexOf("num") == 0)
            _editor.appendAtCaret(action.substr(3)); //3 = num.length

        _editor.requestFocus();
    }

    public function get controlsRegime():Boolean {
        return _controlsRegime;
    }

    public function set controlsRegime(value:Boolean):void {
        _controlsRegime = value;

        for each (var button:SimpleButton in otherButtons) {
            button.enabled = ! _controlsRegime;
            button.mouseEnabled = ! _controlsRegime;
        }
    }
}
}
