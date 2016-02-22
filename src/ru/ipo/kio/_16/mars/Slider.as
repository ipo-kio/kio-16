/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 23.04.11
 * Time: 18:46
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._16.mars {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;

public class Slider extends Sprite {

    private static const HEIGHT:int = 27;
    private static const V_SKIP:int = 1;
    private static const H_SKIP:int = 0;
    private static const BUTTON_WIDTH:int = 16;
    private static const V_TEXT_SKIP: int = 2;
    private static const H_TEXT_SKIP: int = 4;

    public static const VALUE_CHANGED:String = 'slider value changed';

    private var button:Sprite;
    private var plusButton:Sprite;
    private var minusButton:Sprite;

    private var dragMouseDown:Boolean = false;
    private var dragMouseOver:Boolean = false;

    private var _from:Number;
    private var _to:Number;
    private var internalWidth:Number;

    private var _from_tf:TextField = new TextField();
    private var _to_tf:TextField = new TextField();
    private var _value_tf:TextField = new TextField();

    private var _precision:int = 0;

    private var _value_text_color:uint;
    private var _from_to_text_color:uint;

    public function Slider(from:Number, to_:Number, width:Number, value_text_color:uint=0x000000, from_to_text_color:uint=0x000000) {
        internalWidth = width;
        _from = from;
        _to = to_;
        _value_text_color = value_text_color;
        _from_to_text_color = from_to_text_color;

        init();
    }

    private function relocateValueText():void {
        var s:String = '' + value.toFixed(precision);

        //remove point at the end
        var p:Number = s.charAt(s.length - 1).charCodeAt() - '0'.charCodeAt();
        if (p < 0 || p > 9)
            s = s.substr(0, s.length - 1);

        _value_tf.text = s;

        _value_tf.x = button.x - _value_tf.width / 2 + BUTTON_WIDTH / 2;
        //TODO do centering without the "-" sign

        minusButton.y = _value_tf.y + _value_tf.height / 2;
        plusButton.y = _value_tf.y + _value_tf.height / 2;

        minusButton.x = _value_tf.x - minusButton.width / 2 - 2;
        plusButton.x = _value_tf.x + _value_tf.width + plusButton.width / 2 + 2;
    }

    private function init_text_fields():void {
        var h:Number = 16;
        var textFormatFromTo:TextFormat = new TextFormat('KioTahoma', h, _from_to_text_color);
        var textFormatValue:TextFormat = new TextFormat('KioTahoma', h, _value_text_color);
        _from_tf.embedFonts = true;
        _to_tf.embedFonts = true;
        _value_tf.embedFonts = true;

        _from_tf.defaultTextFormat = textFormatFromTo;
        _to_tf.defaultTextFormat = textFormatFromTo;
        _value_tf.defaultTextFormat = textFormatValue;

        _from_tf.selectable = false;
        _to_tf.selectable = false;
        _value_tf.selectable = false;

        _from_tf.text = '42';
        var lineMetrics:TextLineMetrics = _from_tf.getLineMetrics(0);
        var hh:Number = (lineMetrics.ascent + lineMetrics.descent + 4) / 2;
        _from_tf.text = '';

        _from_tf.width = 0; /*_from_tf.height = h;*/ _from_tf.y = -hh + (HEIGHT + 1) / 2;
        _to_tf.width = 0; /*_to_tf.height = h;*/ _to_tf.y = -hh + (HEIGHT + 1) / 2;
        _value_tf.width = 0; /*_value_tf.height = h;*/ _value_tf.y = -HEIGHT+V_TEXT_SKIP;//HEIGHT + V_TEXT_SKIP;

        _from_tf.x = - H_TEXT_SKIP; _from_tf.autoSize = TextFieldAutoSize.RIGHT;
        _to_tf.x = internalWidth + H_TEXT_SKIP; _to_tf.autoSize = TextFieldAutoSize.LEFT;
        _value_tf.autoSize = TextFieldAutoSize.CENTER;

        addChild(_from_tf);
        addChild(_to_tf);
        addChild(_value_tf);

        _from_tf.text = '' + _from;
        _to_tf.text = '' + _to;
    }

    private function init(event:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        graphics.lineStyle(2, 0x000000, 0.7);
        var center:Number = (HEIGHT + 1) / 2;
        graphics.moveTo(0, center);
        graphics.lineTo(internalWidth, center);
        graphics.drawCircle(0, center, 2);
        graphics.drawCircle(internalWidth, center, 2);

        button = new Sprite();
        drawButton();
        addEventListener(Event.ADDED_TO_STAGE, function (e:Event):void {
            button.addEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP, buttonMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, buttonMouseMove);
        });

        value = (_from + _to) / 2;
        button.y = V_SKIP;

        button.addEventListener(MouseEvent.ROLL_OVER, button_rollOverHandler);
        button.addEventListener(MouseEvent.ROLL_OUT, button_rollOutHandler);

        addChild(button);

        init_text_fields();
        initPlusMinusButtons();

        relocateValueText();
        addEventListener(VALUE_CHANGED, function(e:Event):void {
            relocateValueText();
        });
    }

    private function initPlusMinusButtons():void {
        plusButton = new Sprite();
        minusButton = new Sprite();

        plusButton.graphics.beginFill(0xCCCCCC);
        plusButton.graphics.drawCircle(0, 0, 6);
        plusButton.graphics.endFill();
        plusButton.graphics.lineStyle(2, 0x000000);
        plusButton.graphics.moveTo(-3, 0);
        plusButton.graphics.lineTo(3, 0);
        plusButton.graphics.moveTo(0, -3);
        plusButton.graphics.lineTo(0, 3);

        minusButton.graphics.beginFill(0xCCCCCC);
        minusButton.graphics.drawCircle(0, 0, 6);
        minusButton.graphics.endFill();
        minusButton.graphics.lineStyle(2, 0x000000);
        minusButton.graphics.moveTo(-3, 0);
        minusButton.graphics.lineTo(3, 0);

        addChild(plusButton);
        addChild(minusButton);

        plusButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
            value += 1;
        });
        minusButton.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {
            value -= 1;
        });
    }

    private function get isBottomSlider():Boolean {
        return internalWidth > 450;
    }

    private function drawButton():void {
        var over:Boolean = dragMouseDown || dragMouseOver;
        var g:Graphics = button.graphics;

        g.clear();
        g.lineStyle(1, 0x212121);
        g.beginFill(over ? 0xA7C65E : (isBottomSlider ? 0xFFFFFF : 0x0365F4));
        g.drawRect(0, 0, BUTTON_WIDTH, HEIGHT - 2 * V_SKIP);
    }

    private function buttonMouseMove(event:MouseEvent):void {
        if (dragMouseDown)
            dispatchEvent(new Event(VALUE_CHANGED));
    }

    private function buttonMouseUp(event:MouseEvent):void {
        button.stopDrag();
        dragMouseDown = false;
        drawButton();
    }

    private function buttonMouseDown(event:MouseEvent):void {
        button.startDrag(false, new Rectangle(H_SKIP, V_SKIP, internalWidth - 2 * H_SKIP - BUTTON_WIDTH, 0));
        dragMouseDown = true;
        drawButton();
    }

    private function value2pos(value:Number):Number {
        //from -> H_SKIP
        // to  -> internalWidth - H_SKIP - BUTTON_WIDTH
        return H_SKIP + (value - _from) * (internalWidth - 2 * H_SKIP - BUTTON_WIDTH) / (_to - _from);
    }

    private function pos2value(pos:Number):Number {
        //from -> H_SKIP
        // to  -> internalWidth - H_SKIP - BUTTON_WIDTH
        return _from + (pos - H_SKIP) * (_to - _from) / (internalWidth - 2 * H_SKIP - BUTTON_WIDTH);
    }

    public function get value():Number {
        return pos2value(button.x);
    }

    public function get valueRounded():Number {
        return Math.round(value);
    }

    public function set value(value:Number):void {
        button.x = value2pos(value);
        dispatchEvent(new Event(VALUE_CHANGED));
    }

    public function get value_no_fire():Number {
        return value;
    }

    public function set value_no_fire(value:Number):void {
        button.x = value2pos(value);
        relocateValueText();
    }

    public function reInit(from_:Number, to_:Number, value_:Number):void {
        _from = from_;
        _to = to_;

        _from_tf.text = '' + _from;
        _to_tf.text = '' + _to;

        value = value_;
    }

    private function button_rollOverHandler(event:MouseEvent):void {
        dragMouseOver = true;
        drawButton();
    }

    private function button_rollOutHandler(event:MouseEvent):void {
        dragMouseOver = false;
        drawButton();
    }

    public function get precision():int {
        return _precision;
    }

    public function set precision(value:int):void {
        _precision = value;
    }
}
}
