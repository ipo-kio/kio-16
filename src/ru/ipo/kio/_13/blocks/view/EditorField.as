/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 07.02.13
 * Time: 18:18
 */
package ru.ipo.kio._13.blocks.view {

import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import ru.ipo.kio._13.blocks.parser.ParseError;

import ru.ipo.kio._13.blocks.parser.Parser;

import ru.ipo.kio._13.blocks.parser.Program;

public class EditorField extends TextField {

    private static const BORDER_COLOR:uint = 0x0000FF;
    private static const BORDER_COLOR_ERROR:uint = 0xFF0000;
    private static const BG_COLOR:uint = 0xFFFFFF;

    private static const FONT_SIZE:int = 20;
    private static const LETTER_SPACING:Number = 2;
    private static const FONT_NAME:String = 'MONOSPACE'; //'Courier New';
    private static const TF_BRACKET:TextFormat = new TextFormat(FONT_NAME, FONT_SIZE, 0x888800, false, false, false);
    private static const TF_NUMBER:TextFormat = new TextFormat(FONT_NAME, FONT_SIZE, 0x008800, true, false, false);
    private static const TF_COMMAND:TextFormat = new TextFormat(FONT_NAME, FONT_SIZE, 0x000088, true, false, false);
    private static const TF_ERROR:TextFormat = new TextFormat(FONT_NAME, FONT_SIZE, 0x880000, false, false, true);
    private static const TF_NON_PARSED:TextFormat = new TextFormat(FONT_NAME, FONT_SIZE, 0x888888, false, false, false);

    public static const CARET_MOVED:String = 'caret moved';

    {                                             //TODO report no error for static initializer
        TF_BRACKET.letterSpacing = LETTER_SPACING;
        TF_COMMAND.letterSpacing = LETTER_SPACING;
        TF_ERROR.letterSpacing = LETTER_SPACING;
        TF_NON_PARSED.letterSpacing = LETTER_SPACING;
        TF_NUMBER.letterSpacing = LETTER_SPACING;
    }

    private var _program:Program;
    private var _parseError:String;
    private var _parser:Parser;

    public function EditorField(width:int, height:int, simple:Boolean = false) {
        autoSize = TextFieldAutoSize.NONE;
        this.width = width;
        this.height = height;
        this.border = true;
        this.borderColor = BORDER_COLOR;
        this.background = true;
        this.backgroundColor = BG_COLOR;
        this.multiline = true;
        //this.embedFonts = true; //TODO embed fonts
        this.defaultTextFormat = TF_NON_PARSED;
        this.type = TextFieldType.INPUT;
        this.wordWrap = true;

        addEventListener(Event.CHANGE, textInputHandler);

        _parser = new Parser(simple, tokenCallback);
    }

    private function tokenCallback(token:String, tokenType:int, position:int, length:int):void {
        var tf:TextFormat = null;
        switch (tokenType) {
            case Parser.TOKEN_COMMAND:
                tf = TF_COMMAND;
                break;
            case Parser.TOKEN_NUMBER:
                tf = TF_NUMBER;
                break;
            case Parser.TOKEN_PUNCTUATION:
                tf = TF_BRACKET;
                break;
        }

        setTextFormat(tf, position, position + length);
    }

    public function get program():Program {
        return _program;
    }

    public function get parseError():String {
        return _parseError;
    }

    override public function set text(value:String):void {
        super.text = value;
        dispatchEvent(new Event(Event.CHANGE));
    }

    override public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void {
        var length:int = text.length;
        if (beginIndex >= 0 && endIndex <= length && length != 0)
            super.setTextFormat(format, beginIndex, endIndex);
    }

    private function textInputHandler(event:Event):void {
        var textLength:int = text.length;

        setTextFormat(TF_NON_PARSED, 0, textLength);

        try {
            _parser.parse(text);
            _program = _parser.program;
            _parseError = null;
            borderColor = BORDER_COLOR;
        } catch (e:ParseError) {
            borderColor = BORDER_COLOR_ERROR;
            setTextFormat(TF_ERROR, e.position, e.position + e.length);
            _program = null;
            _parseError = e.message;
        }
    }

    public function appendAtCaret(s:String):void {
        var newCaretPosition:int = caretIndex + s.length;
        super.text = text.substring(0, caretIndex) + s + text.substring(caretIndex);
        setSelection(newCaretPosition, newCaretPosition);
        dispatchEvent(new Event(Event.CHANGE));
    }

    //TODO report fails to HG push if there is an extra head: writes that nothing to push
}
}
