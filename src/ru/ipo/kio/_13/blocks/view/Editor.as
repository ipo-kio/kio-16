/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 07.02.13
 * Time: 21:43
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.blocks.view {
import fl.controls.UIScrollBar;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

public class Editor extends Sprite {

    private var _editor:EditorField;
    private var _scroll:UIScrollBar;
    private var _keyboard:SoftKeyboard;
    private var leftBracket:SymbolSelector;
    private var rightBracket:SymbolSelector;
    private var highlight:SymbolSelector = null;

    private var actionsQueue:Array = ["", 0]; //Array of String
    private const MAX_ACTIONS_COUNT:int = 20;

    public function Editor(width:int, height:int, simple:Boolean = false) {
        _editor = new EditorField(width, height, simple);
        addChild(_editor);
        _scroll = new UIScrollBar();
        _scroll.height = height;
        addChild(_scroll);
        _scroll.scrollTarget = _editor;
        _scroll.direction = "vertical";
        _scroll.move(width, 0);

        leftBracket = new SymbolSelector(_editor, -1, 1, 0x888888);
        rightBracket = new SymbolSelector(_editor, -1, 1, 0x888888);
        highlight = new SymbolSelector(_editor, -1, 2, 0x000088);

        addChild(leftBracket);
        addChild(rightBracket);

        _editor.addEventListener(Event.CHANGE, editor_changeHandler);

        _editor.addEventListener(MouseEvent.MOUSE_DOWN, caretMovedHandler);
        _editor.addEventListener(KeyboardEvent.KEY_UP, caretMovedHandler);
        _editor.addEventListener(Event.SCROLL, caretMovedHandler);
        _editor.addEventListener(Event.CHANGE, caretMovedHandler);

        _keyboard = new SoftKeyboard(this, simple);
        _keyboard.x = 0;
        _keyboard.y = height;
        addChild(_keyboard);
    }

    private function caretMovedHandler(event:Event):void {
        var caretIndex:int = _editor.caretIndex - 1;

        var text:String = _editor.text;
        var length:int = text.length;
        if (caretIndex < 0 || caretIndex >= length) {
            leftBracket.index = -1;
            rightBracket.index = -1;
            return;
        }

        //test it to be a bracket
        var left_bracket_ind:int = -1;
        var right_bracket_ind:int = -1;
        if (_editor.text.charAt(caretIndex) == '(') {
            left_bracket_ind = caretIndex;
            right_bracket_ind = -1;
            var ind:int = caretIndex + 1;
            var cnt:int = 1;
            while (ind < length) {
                var s:String = text.charAt(ind);
                if (s == ')')
                    cnt--;
                else if (s == '(')
                    cnt++;
                if (cnt == 0) {
                    right_bracket_ind = ind;
                    break;
                }
                ind ++;
            }
        } else if (_editor.text.charAt(caretIndex) == ')') {
            left_bracket_ind = -1;
            right_bracket_ind = caretIndex;
            ind = caretIndex - 1;
            cnt = -1;
            while (ind >= 0) {
                s = text.charAt(ind);
                if (s == ')')
                    cnt--;
                else if (s == '(')
                    cnt++;
                if (cnt == 0) {
                    left_bracket_ind = ind;
                    break;
                }
                ind --;
            }
        }

        leftBracket.index = left_bracket_ind;
        rightBracket.index = right_bracket_ind;
    }

    public function removeHighlight():void {
        highlight.index = -1;
    }

    public function setHighlight(index:int):void {
        highlight.index = index;
    }

    private function editor_changeHandler(event:Event):void {
        removeHighlight();

        actionsQueue.push(_editor.text);
        actionsQueue.push(_editor.caretIndex);
        if (actionsQueue.length > 2 * MAX_ACTIONS_COUNT) {
            actionsQueue.shift();
            actionsQueue.shift();
        }
    }

    public function get canUndo():Boolean {
        return actionsQueue.length > 2;
    }

    public function undo():void {
        if (!canUndo)
            return;
        actionsQueue.pop(); //the last value is always the same as current
        actionsQueue.pop();
        /*var caret:int = */actionsQueue.pop();
        _editor.text = actionsQueue.pop();
//        _editor.setSelection(caret, caret);
    }

    public function appendAtCaret(s:String):void {
        _editor.appendAtCaret(s);
    }

    public function requestFocus():void {
        stage.focus = _editor;
    }
}
}
