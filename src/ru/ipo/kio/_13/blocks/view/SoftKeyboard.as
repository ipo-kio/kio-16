/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 08.02.13
 * Time: 19:15
 */
package ru.ipo.kio._13.blocks.view {

import flash.display.Sprite;
import flash.events.MouseEvent;

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

    public static const X0:int = 2;
    public static const Y0:int = 2;
    public static const DX:int = 42;
    public static const DY:int = 42;

    private var _editor:Editor;

    public function SoftKeyboard(editor:Editor, simple:Boolean) {
        _editor = editor;
        addButton(LEFT_CLS, 'left', X0, Y0);
        addButton(RIGHT_CLS, 'right', X0 + DX, Y0);
        addButton(TAKE_CLS, 'take', X0 + 2 * DX, Y0);
        addButton(PUT_CLS, 'put', X0 + 3 * DX, Y0);
        addButton(SPACE_CLS, 'space', X0 + 5 * DX, Y0);
        if (! simple) {
            addButton(BR_LEFT_CLS, 'br left', X0 + 6 * DX, Y0);
            addButton(BR_RIGHT_CLS, 'br right', X0 + 7 * DX, Y0);
        }
        addButton(UNDO_CLS, 'undo', X0 + 9 * DX, Y0);

        if (! simple)
            for (var i:int = 0; i < 10; i++)
                addButton("" + i, "num" + i, X0 + i * DX, Y0 + DY);
    }

    private function addButton(value:*, action:String, x:int, y:int):void {
        var button:Button = new Button(value, action);
        button.x = x;
        button.y = y;
        addChild(button);
        button.addEventListener(MouseEvent.CLICK, button_clickHandler);
    }

    private function button_clickHandler(event:MouseEvent):void {
        var action:String = Button(event.target).action;
        switch (action) {
            case 'left':
                _editor.appendAtCaret('L');
                break;
            case 'right':
                _editor.appendAtCaret('R');
                break;
            case 'take':
                _editor.appendAtCaret('T');
                break;
            case 'put':
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
}
}
