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

import ru.ipo.kio._13.blocks.BlocksProblem;

import ru.ipo.kio._13.blocks.BlocksWorkspace;
import ru.ipo.kio._13.blocks.model.FieldChangeEvent;
import ru.ipo.kio._13.blocks.parser.Command;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.controls.ButtonBuilder;

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

    [Embed(source="../resources/diamond_bt_norm.png")]
    public static const EMPTY_CLS:Class;

    [Embed(source="../resources/diamond_bt_over.png")]
    public static const HIGHLIGHT_CLS:Class;

    [Embed(source="../resources/diamond_bt_push.png")]
    public static const PRESSED_CLS:Class;

    private static const X0:int = 306;
    private static const Y0:int = 4;
    private static const DX:int = 44;
    private static const DY:int = 44;

    private static const FOUR_CENTER_X:int = 676;
    private static const FOUR_CENTER_Y:int = -54;
    private static const BIG_BUTTON_SIZE:int = 104;

    private var actionButtons:Array = []; //of buttons
    private var otherButtons:Array = []; //of buttons

    private var _editor:Editor;

    private var _controlsRegime:Boolean = false;

    private static const api:KioApi = KioApi.instance(BlocksProblem.ID);

    public function SoftKeyboard(editor:Editor, simple:Boolean) {
        _editor = editor;
        actionButtons.push(addButton(LEFT_CLS, 'left', FOUR_CENTER_X - BIG_BUTTON_SIZE, FOUR_CENTER_Y - BIG_BUTTON_SIZE / 2, true));
        actionButtons.push(addButton(RIGHT_CLS, 'right', FOUR_CENTER_X, FOUR_CENTER_Y - BIG_BUTTON_SIZE / 2, true));
        actionButtons.push(addButton(TAKE_CLS, 'take', FOUR_CENTER_X - BIG_BUTTON_SIZE / 2, FOUR_CENTER_Y, true));
        actionButtons.push(addButton(PUT_CLS, 'put', FOUR_CENTER_X - BIG_BUTTON_SIZE / 2, FOUR_CENTER_Y - BIG_BUTTON_SIZE, true));

        otherButtons.push(addButton(SPACE_CLS, 'space', X0 + DX, Y0));
        if (! simple) {
            otherButtons.push(addButton(BR_LEFT_CLS, 'br left', X0 + 2 * DX, Y0));
            otherButtons.push(addButton(BR_RIGHT_CLS, 'br right', X0 + 3 * DX, Y0));
        }
        otherButtons.push(addButton(UNDO_CLS, 'undo', X0 + 5 * DX, Y0));

        if (! simple)
            for (var i:int = 0; i < 10; i++)
                otherButtons.push(addButton("" + i, "num" + i, X0 + i * DX, Y0 + DY));
    }

    private function addButton(value:*, action:String, x:int, y:int, diamond:Boolean = false):SimpleButton {
        var buttonBuilder:ButtonBuilder = new ButtonBuilder(action);
        buttonBuilder.upColor = 0xEEEEEE;
        buttonBuilder.downColor = 0xAAAAAA;
        buttonBuilder.upHoverColor = 0xEEEE00;
        buttonBuilder.downHoverColor = 0xAAAA00;
        buttonBuilder.borderColor = 0x444444;
        buttonBuilder.innerBorderColor = 0x888888;
        buttonBuilder.font = "MONOSPACE";
        buttonBuilder.embedFont = false;
        buttonBuilder.fontSize = 20;
        buttonBuilder.fontColor = 0x000000;

        if (diamond) {
            buttonBuilder.bgNormal = EMPTY_CLS;
            buttonBuilder.bgOver = HIGHLIGHT_CLS;
            buttonBuilder.bgPush = PRESSED_CLS;
            buttonBuilder.diamondForm = diamond;
        }

        if (value is String) {
            buttonBuilder.title = value;
            buttonBuilder.width = 40;
            buttonBuilder.height = 40;
            var button:SimpleButton = buttonBuilder.build();
        } else {
            buttonBuilder.imgClass = value;
            button = buttonBuilder.build();
        }

        button.x = x;
        button.y = y;
        addChild(button);
        button.addEventListener(MouseEvent.CLICK, button_clickHandler);

        return button;
    }

    private function button_clickHandler(event:MouseEvent):void {
        var action:String = event.target.action;
        var manual:Boolean = BlocksWorkspace.instance.manualRegime;

        api.log('button ' + action + (manual ? ' manual' : ''));

        switch (action) {
            case 'left':
                 if (manual)
                    _editor.dispatchEvent(new FieldChangeEvent(true, Command.LEFT));
                 else
                     _editor.appendAtCaret('L');
                break;
            case 'right':
                if (manual)
                    _editor.dispatchEvent(new FieldChangeEvent(true, Command.RIGHT));
                else
                    _editor.appendAtCaret('R');
                break;
            case 'take':
                if (manual)
                    _editor.dispatchEvent(new FieldChangeEvent(true, Command.TAKE));
                else
                    _editor.appendAtCaret('T');
                break;
            case 'put':
                if (manual)
                    _editor.dispatchEvent(new FieldChangeEvent(true, Command.PUT));
                else
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
