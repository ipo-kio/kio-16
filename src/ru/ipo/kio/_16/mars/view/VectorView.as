package ru.ipo.kio._16.mars.view {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

import ru.ipo.kio._16.mars.model.Vector2D;

public class VectorView extends Sprite {

    public static const VALUE_CHANGED:String = 'vector view value changed';

    public static const SPEED_DS:Number = 1000;

    private var _value:Vector2D;
    private var _anglesNumber:int;
    private var _radiusesNumber:int;
    private var _maxValue:Number;
    private var _size:Number;

    private var _delta_R:Number;
    private var _delta_Phi:Number;
    private var _mul:Number;

    private var _arrow_color:uint;
    private var _arrow_layer:Sprite;

    private var _editable:Boolean = true;
    private var _text_top:Boolean = false;

    private var _r_edit:TextField;
    private var _theta_edit:TextField;

    private var _r_edit_title:TextField;
    private var _theta_edit_title:TextField;
    private var _precisionDigits:int;
    private var _textColor:uint;

    public function VectorView(anglesNumber:int, radiusesNumber:int, maxValue:Number, size:Number, arrow_color:uint, text_top:Boolean, precisionDigits:int, textColor:uint) {
        _anglesNumber = anglesNumber;
        _radiusesNumber = radiusesNumber;
        _maxValue = maxValue;
        _size = size;
        _arrow_color = arrow_color;

        _text_top = text_top;
        _precisionDigits = precisionDigits;
        _textColor = textColor;

        _delta_R = _maxValue / _radiusesNumber;
        _delta_Phi = 2 * Math.PI / _anglesNumber;
        _mul = size / maxValue;

        initBg();

        _arrow_layer = new Sprite();
        addChild(_arrow_layer);

        init_hit_area();

        _arrow_layer.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        _arrow_layer.addEventListener(MouseEvent.CLICK, mouseClickHandler);

        init_editors();
    }

    private function init_editors():void {
        _r_edit = new TextField();
        _theta_edit = new TextField();

        addChild(_r_edit);
        addChild(_theta_edit);

        var fontSize:int = 14;
        var backgroundColor:uint = 0x444444;
        _r_edit.background = true;
        _theta_edit.background = true;
        _r_edit.backgroundColor = backgroundColor;
        _theta_edit.backgroundColor = backgroundColor;

        _r_edit.width = 80;
        _theta_edit.width = 80;
        _r_edit.height = fontSize + 4;
        _theta_edit.height = fontSize + 4;

        var textFormat:TextFormat = new TextFormat('KioArial', fontSize, _textColor);
        textFormat.align = TextFormatAlign.RIGHT;
        _r_edit.defaultTextFormat = textFormat;
        _theta_edit.defaultTextFormat = textFormat;

        _r_edit.embedFonts = true;
        _theta_edit.embedFonts = true;

        _r_edit.type = TextFieldType.INPUT;
        _theta_edit.type = TextFieldType.INPUT;

        _r_edit.addEventListener(FocusEvent.FOCUS_OUT, edit_focusOutHandler);
        _r_edit.addEventListener(KeyboardEvent.KEY_DOWN, edit_keyDownHandler);

        _theta_edit.addEventListener(FocusEvent.FOCUS_OUT, edit_focusOutHandler);
        _theta_edit.addEventListener(KeyboardEvent.KEY_DOWN, edit_keyDownHandler);

        //km/h and degs
        var _r_edit_title:TextField = new TextField();
        var _theta_edit_title:TextField = new TextField();

        addChild(_r_edit_title);
        addChild(_theta_edit_title);

        var textFormat2:TextFormat = new TextFormat('KioArial', fontSize, _textColor);
        textFormat2.align = TextFormatAlign.RIGHT;
        _r_edit_title.defaultTextFormat = textFormat2;
        _theta_edit_title.defaultTextFormat = textFormat2;

        _r_edit.embedFonts = true;
        _theta_edit.embedFonts = true;

        _r_edit_title.autoSize = TextFieldAutoSize.LEFT;
        _theta_edit_title.autoSize = TextFieldAutoSize.LEFT;

        _r_edit_title.text = 'км/ч';
        _theta_edit_title.text = '°';

        //place everything

        /*_r_edit_title.x = -_r_edit_title.width - 4;
        _r_edit_title.y = _size + 2;
        _r_edit.x = _r_edit_title.x - _r_edit.width;
        _r_edit.y = _r_edit_title.y;

        _theta_edit.x = 2;
        _theta_edit.y = _r_edit.y;
        _theta_edit_title.x = _theta_edit.x + _theta_edit.width;
        _theta_edit_title.y = _theta_edit.y;*/

        _r_edit.x = -_r_edit.width / 2;
        _theta_edit.x = -_theta_edit.width / 2;
        var skip:int = 2;
        if (_text_top)
            _r_edit.y = -_size - _r_edit.height - skip - _theta_edit.height - skip;
        else
            _r_edit.y = _size + skip;

        _theta_edit.y = _r_edit.y + _r_edit.height + skip;

        _r_edit_title.x = _r_edit.x + _r_edit.width;
        _r_edit_title.y = _r_edit.y;
        _theta_edit_title.x = _theta_edit.x + _theta_edit.width;
        _theta_edit_title.y = _theta_edit.y;
    }

    private function init_hit_area():void {
        var hit_area:Sprite = new Sprite();
        hit_area.mouseEnabled = false;
        hit_area.visible = false;
        _arrow_layer.hitArea = hit_area;

        hit_area.graphics.beginFill(0x0FF000);
        hit_area.graphics.drawCircle(0, 0, _size + 10);
        hit_area.graphics.endFill();

        addChild(hit_area);
    }

    private function initBg():void {
//        graphics.beginFill(0xFFFFFF);
//        graphics.drawCircle(0, 0, _size + 4);
//        graphics.endFill();
//
        graphics.lineStyle(1, 0xFFFFFF, 0.2);
        var n:int = 10; //Math.floor(_maxValue / SPEED_DS);
        for (var i:int = 1; i <= n; i++)
            graphics.drawCircle(0, 0, _size * i / n);
    }

    public function get value():Vector2D {
        return _value;
    }

    public function set value(value:Vector2D):void {
        _value = value;

        showTextValues();

        redrawArrow();
    }

    private function showTextValues():void {
        _r_edit.text = (value.r * 3.6).toFixed(_precisionDigits); //to km/h
        _theta_edit.text = (value.theta * 180 / Math.PI).toFixed(_precisionDigits);
    }

    private function redrawArrow():void {
        var g:Graphics = _arrow_layer.graphics;
        g.clear();

        g.lineStyle(2, _arrow_color);
        var point:Point = value2position(_value);
        g.moveTo(0, 0);
        g.lineTo(point.x, point.y);

        var p:Point = point.clone();
        p.normalize(10);

        var c18:Number = Math.cos(Math.PI / 10);
        var s18:Number = Math.sin(Math.PI / 10);

        g.moveTo(point.x, point.y);
        g.lineTo(point.x - c18 * p.x + s18 * p.y, point.y - s18 * p.x - c18 * p.y);
        g.moveTo(point.x, point.y);
        g.lineTo(point.x - c18 * p.x - s18 * p.y, point.y + s18 * p.x - c18 * p.y);
    }

    private function value2position(vector:Vector2D):Point {
        var vector2D:Vector2D = roundVector(vector);

        return new Point(vector2D.x * _mul, -vector2D.y * _mul);
    }

    private function roundVector(vector:Vector2D):Vector2D {
        //round R
        var dR:int = Math.round(vector.r / _delta_R);
        if (dR < 0)
            dR = 0;
        if (dR > _radiusesNumber)
            dR = _radiusesNumber;

        var r:Number = dR * _delta_R;

        //round Phi
        var th:Number = vector.theta;
        while (th < 0)
            th += Math.PI * 2;
        var dPhi:int = Math.round(th / _delta_Phi);
        dPhi = dPhi % _anglesNumber;

        var phi:Number = dPhi * _delta_Phi;

        return Vector2D.createPolar(r, phi);
    }

    private function positionXY2value(x:Number, y:Number):Vector2D {
        var d:Number = Math.sqrt(x * x + y * y);
        var r:Number = _maxValue * d / _size;
        var phi:Number = Math.atan2(-y, x);

        return roundVector(Vector2D.createPolar(r, phi));
    }

    private function position2value(p:Point):Vector2D {
        return positionXY2value(p.x, p.y);
    }

    private function mouseMoveHandler(event:MouseEvent):void {
        if (event.buttonDown)
            newMousePosition(event);
    }

    private function mouseClickHandler(event:MouseEvent):void {
        newMousePosition(event);
    }

    private function newMousePosition(event:MouseEvent):void {
        if (!_editable)
            return;

        var vector2D:Vector2D = positionXY2value(event.localX, event.localY);
        value = vector2D;
        dispatchEvent(new Event(VALUE_CHANGED));
    }

    public function get editable():Boolean {
        return _editable;
    }

    public function set editable(value:Boolean):void {
        _editable = value;
        if (_editable) {
            _r_edit.type = TextFieldType.INPUT;
            _theta_edit.type = TextFieldType.INPUT;
            _r_edit.background = true;
            _theta_edit.background = true;
        } else {
            _r_edit.type = TextFieldType.DYNAMIC;
            _theta_edit.type = TextFieldType.DYNAMIC;
            _r_edit.background = false;
            _theta_edit.background = false;
        }
    }

    private function edit_keyDownHandler(event:KeyboardEvent):void {
        if (event.keyCode == 13)
            textChangedByUser();
    }

    private function edit_focusOutHandler(event:FocusEvent):void {
        textChangedByUser();
    }

    private function textChangedByUser():void {
        var rN:Number = text2number(_r_edit.text, 1, 0, _maxValue * 3.6);
        var thetaN:Number = text2number(_theta_edit.text, 1, 0, 359);

        if (isNaN(rN) || isNaN(thetaN))
            showTextValues();

        rN /= 3.6;
        thetaN *= Math.PI / 180;

        value = Vector2D.createPolar(rN, thetaN);
        showTextValues();
        dispatchEvent(new Event(VALUE_CHANGED));
    }

    private static function text2number(t:String, digits:Number, minValue:Number, maxValue:Number):Number {
        t = t.replace(/,/g, '.');
//        var s:Array = t.split(".");
//        if (s.length > 2)
//            return NaN;
//
//        if (s.length == 1) {
//            return parseFloat(t);
//        }

        var r:Number = parseFloat(t);
        if (isNaN(r))
            return NaN;

        r = Math.round(r / digits) * digits;

        if (r < minValue)
            r = minValue;
        if (r > maxValue)
            r = maxValue;

        return r;
    }
}
}
