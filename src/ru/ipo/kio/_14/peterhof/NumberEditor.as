/**
 * Created by ilya on 25.01.14.
 */
package ru.ipo.kio._14.peterhof {
import flash.display.BitmapData;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import ru.ipo.kio.api.controls.GraphicsButton;

public class NumberEditor extends Sprite {

    [Embed(source="resources/plus.png")]
    public static const NUM_PL_CLS:Class;
    public static const NUM_PL_CLS_IMG:BitmapData = (new NUM_PL_CLS).bitmapData;

    [Embed(source="resources/plus_down.png")]
    public static const NUM_PL_D_CLS:Class;
    public static const NUM_PL_CLS_D_IMG:BitmapData = (new NUM_PL_D_CLS).bitmapData;

    [Embed(source="resources/plus_over.png")]
    public static const NUM_PL_O_CLS:Class;
    public static const NUM_PL_CLS_O_IMG:BitmapData = (new NUM_PL_O_CLS).bitmapData;

    [Embed(source="resources/minus.png")]
    public static const NUM_MN_CLS:Class;
    public static const NUM_MN_CLS_IMG:BitmapData = (new NUM_MN_CLS).bitmapData;

    [Embed(source="resources/minus_down.png")]
    public static const NUM_MN_D_CLS:Class;
    public static const NUM_MN_CLS_D_IMG:BitmapData = (new NUM_MN_D_CLS).bitmapData;

    [Embed(source="resources/minus_over.png")]
    public static const NUM_MN_O_CLS:Class;
    public static const NUM_MN_CLS_O_IMG:BitmapData = (new NUM_MN_O_CLS).bitmapData;

    private var _min:Number;
    private var _max:Number;
    private var _units:String;
    private var _places:int;

    private var _delta:Number;
    private var _ten:Number;

    private var _value:Number = NaN;

    private var _width:int;
    private var _height:int;

    private var _textField:TextField;
    private var _textFieldUnits:TextField;
    private var _buttonPlus:SimpleButton;
    private var _buttonMinus:SimpleButton;

    private static const NORMAL_COLOR:uint = 0x000000;
    private static const ERROR_COLOR:uint = 0xaa2222;

    public function NumberEditor(width:int, height:int, min:Number, max:Number, initial_value:Number, units:String, places:int) {
        _width = width;
        _height = NUM_PL_CLS_IMG.height;

        _min = min;
        _max = max;
        _units = units;
        _places = places;

        _ten = Math.pow(10, _places);
        _delta = 1 / _ten;

        draw();

        _textField.addEventListener(Event.CHANGE, textField_changeHandler);
        _buttonPlus.addEventListener(MouseEvent.CLICK, buttonPlus_clickHandler);
        _buttonMinus.addEventListener(MouseEvent.CLICK, buttonMinus_clickHandler);

        value = initial_value;
    }

    private function draw():void {
        const fontSize:int = 18;

        _buttonPlus = new GraphicsButton("", NUM_PL_CLS_IMG, NUM_PL_CLS_O_IMG, NUM_PL_CLS_D_IMG, "KioTahoma", 12, 12);
        _buttonMinus = new GraphicsButton("", NUM_MN_CLS_IMG, NUM_MN_CLS_O_IMG, NUM_MN_CLS_D_IMG, "KioTahoma", 12, 12);

        addChild(_buttonMinus);
        _buttonMinus.y = (_height - _buttonMinus.height) / 2;

        addChild(_buttonPlus);
        _buttonPlus.y = (_height - _buttonPlus.height) / 2;
        _buttonPlus.x = _width - _buttonPlus.width;

        _textFieldUnits = new TextField();
        _textField = new TextField();
        addChild(_textFieldUnits);
        addChild(_textField);

        _textFieldUnits.embedFonts = true;
        _textFieldUnits.defaultTextFormat = new TextFormat("KioTahoma", fontSize);
        _textFieldUnits.autoSize = TextFieldAutoSize.RIGHT;
        _textFieldUnits.x = _width - _buttonPlus.width - 4;
        _textFieldUnits.text = _units;
        _textFieldUnits.textColor = 0x000000;
        _textFieldUnits.selectable = false;
        _textFieldUnits.y = (_height - _textFieldUnits.height) / 2;

        _textField.embedFonts = true;
        _textField.type = TextFieldType.INPUT;
        _textField.defaultTextFormat = new TextFormat("KioTahoma", fontSize);
        _textField.autoSize = TextFieldAutoSize.LEFT;
        _textField.borderColor = 0xFF0000;
        _textField.x = _buttonPlus.width + 4;
        _textField.textColor = 0x000000;

        _textField.y = _textFieldUnits.y;
        _textField.height = _height - _textField.y;
    }

    public function get value():Number {
        return _value;
    }

    public function set value(value:Number):void {
        value = normalize(value);

        if (Number(_textField.text) == value)
            return;

        valueText = String(value);
    }

    private function normalize(value:Number):Number {
        value = Math.round(value * _ten) / _ten;

        if (value < _min)
            value = _min;
        if (value > _max)
            value = _max;

        return value;
    }

    private function set valueText(text:String):void {
        _textField.text = text;
        textField_changeHandler(null);
    }

    private function setValue(value:Number):void {
        var oldValue:Number = _value;

        _value = normalize(value);

        if (oldValue != value)
            dispatchEvent(new Event(Event.CHANGE));
    }

    private function textField_changeHandler(event:Event):void {
        var new_value:Number = Number(_textField.text);

        if (!isNaN(new_value))
            setValue(new_value);

        textValueUpdated();
    }

    private function textValueUpdated():void {
        _textField.textColor = has_error() ? ERROR_COLOR : NORMAL_COLOR;

        _textFieldUnits.x = _textField.x + _textField.width;
    }

    public function has_error():Boolean {
        return value != Number(_textField.text);
    }

    private function buttonPlus_clickHandler(event:MouseEvent):void {
        value += _delta;
    }

    private function buttonMinus_clickHandler(event:MouseEvent):void {
        value -= _delta;
    }
}
}
