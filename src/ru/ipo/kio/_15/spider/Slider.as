/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 23.04.11
 * Time: 18:46
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._15.spider {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class Slider extends Sprite {

    private static const HEIGHT:int = 21;
    private static const V_SKIP:int = 1;
    private static const H_SKIP:int = 0;
    private static const BUTTON_WIDTH:int = 10;

    public static const VALUE_CHANGED:String = 'slider value changed';

    private var button:Sprite;

    private var dragMouseDown:Boolean = false;

    private var _from:Number;
    private var _to:Number;
    private var internalWidth:Number;

    public function Slider(from:Number, to_:Number, width:Number) {
        internalWidth = width;
        _from = from;
        _to = to_;

        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
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
        button.graphics.lineStyle(1, 0x555555);
        button.graphics.beginFill(0xAAAAAA);
        button.graphics.drawRect(0, 0, BUTTON_WIDTH, HEIGHT - 2 * V_SKIP);
        button.addEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDown);
        stage.addEventListener(MouseEvent.MOUSE_UP, buttonMouseUp);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, buttonMouseMove);

        value = (_from + _to) / 2;
        button.y = V_SKIP;

        addChild(button);
    }

    private function buttonMouseMove(event:MouseEvent):void {
        if (dragMouseDown)
            dispatchEvent(new Event(VALUE_CHANGED));
    }

    private function buttonMouseUp(event:MouseEvent):void {
        button.stopDrag();
        dragMouseDown = false;
    }

    private function buttonMouseDown(event:MouseEvent):void {
        button.startDrag(false, new Rectangle(H_SKIP, V_SKIP, internalWidth - 2 * H_SKIP - BUTTON_WIDTH, 0));
        dragMouseDown = true;
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

    public function set value(value:Number):void {
        button.x = value2pos(value);
        dispatchEvent(new Event(VALUE_CHANGED));
    }
}
}
