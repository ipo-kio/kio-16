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
import flash.text.TextFieldType;

import ru.ipo.kio._13.blocks.BlocksWorkspace;

import ru.ipo.kio.api.KioApi;

public class Editor extends Sprite {

    private var _editorField:EditorField;
    private var _keyboard:SoftKeyboard;
    private var leftBracket:SymbolSelector;
    private var rightBracket:SymbolSelector;
    private var highlight:SymbolSelector = null;

    private var actionsQueue:Array = ["", 0]; //Array of String
    private const MAX_ACTIONS_COUNT:int = 100;

    private var _enabled:Boolean = true;

    private var api:KioApi;
    private var _workspace:BlocksWorkspace;

    public function Editor(workspace:BlocksWorkspace, width:int, height:int, simple:Boolean = false) {
        _workspace = workspace;
        this.api = _workspace.api;
        _editorField = new EditorField(width, height, simple);
        addChild(_editorField);
        var _scroll:UIScrollBar = new UIScrollBar();
        _scroll.height = height;
        addChild(_scroll);
        _scroll.scrollTarget = _editorField;
        _scroll.direction = "vertical";
        _scroll.move(width, 0);

        leftBracket = new SymbolSelector(_editorField, -1, 1, 0x888888);
        rightBracket = new SymbolSelector(_editorField, -1, 1, 0x888888);
        highlight = new SymbolSelector(_editorField, -1, 2, 0x000088, 0.3);

        addChild(leftBracket);
        addChild(rightBracket);
        addChild(highlight);

        _editorField.addEventListener(Event.CHANGE, editor_changeHandler);

        _editorField.addEventListener(MouseEvent.MOUSE_DOWN, caretMovedHandler);
        _editorField.addEventListener(KeyboardEvent.KEY_UP, caretMovedHandler);
        _editorField.addEventListener(Event.SCROLL, caretMovedHandler);
        _editorField.addEventListener(Event.CHANGE, caretMovedHandler);

        _keyboard = new SoftKeyboard(this, simple, _workspace);
        _keyboard.x = 0;
        _keyboard.y = height;
        addChild(_keyboard);
    }

    private function caretMovedHandler(event:Event):void {
        if (event instanceof KeyboardEvent)
            api.log('key in editor pressed');

        var caretIndex:int = _editorField.caretIndex - 1;

        var text:String = _editorField.text;
        var length:int = text.length;
        if (caretIndex < 0 || caretIndex >= length) {
            leftBracket.index = -1;
            rightBracket.index = -1;
            return;
        }

        //test it to be a bracket
        var left_bracket_ind:int = -1;
        var right_bracket_ind:int = -1;
        if (_editorField.text.charAt(caretIndex) == '(') {
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
                ind++;
            }
        } else if (_editorField.text.charAt(caretIndex) == ')') {
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
                ind--;
            }
        }

        leftBracket.index = left_bracket_ind;
        rightBracket.index = right_bracket_ind;
    }

    public function removeHighlight():void {
        highlight.index = -1;
    }

    public function setHighlight(index:int, scrollVisible:Boolean = false):void {
        highlight.index = index;
        if (scrollVisible)
            highlight.scrollVisible();
    }

    private function editor_changeHandler(event:Event):void {
        removeHighlight(); //TODO this is probably not necessary

        actionsQueue.push(_editorField.text);
        actionsQueue.push(_editorField.caretIndex);
        if (actionsQueue.length > 2 * MAX_ACTIONS_COUNT) {
            actionsQueue.shift();
            actionsQueue.shift();
        }
    }

    public function get canUndo():Boolean {
        return actionsQueue.length > 2;
    }

    public function undo():void {
        if (api.problem.level == 0) {
            var text:String = _editorField.text;
            var len:int = text.length;
            if (len > 0)
                _editorField.text = text.substring(0, len - 1);
            return;
        }

        if (!canUndo)
            return;
        actionsQueue.pop(); //the last value is always the same as current
        actionsQueue.pop();
        /*var caret:int = */
        actionsQueue.pop();
        _editorField.text = actionsQueue.pop();
//        _editor.setSelection(caret, caret);
    }

    public function appendAtCaret(s:String):void {
        _editorField.appendAtCaret(s);
    }

    public function appendText(s:String):void {
        _editorField.appendText(s);
        _editorField.dispatchEvent(new Event(Event.CHANGE));
    }

    public function requestFocus():void {
        stage.focus = _editorField;
    }

    public function get editorField():EditorField {
        return _editorField;
    }

    public function set enabled(enabled:Boolean):void {
        _enabled = enabled;

        _keyboard.controlsRegime = !enabled;
        _editorField.type = enabled ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
    }
}
}
