/**
 * Created by ilya on 12.02.15.
 */
package ru.ipo.kio._15.spider {
import flash.display.CapsStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class Stick extends Sprite {

    private var x1:Number;
    private var y1:Number;
    private var x2:Number;
    private var y2:Number;

    private var _color:uint;
    private var _selected:Boolean = false;
    private var _over:Boolean = false;

    public static const SELECTED_CHANGED_EVENT:String = "selectedChanged";
    public static const OVER_CHANGED_EVENT:String = "overChanged";

    public function Stick(color:uint) {
        _color = color;
        redraw();

        addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
        addEventListener(MouseEvent.CLICK, clickHandler);
    }

    public function setCoordinates(x1:Number, y1:Number, x2:Number, y2:Number):void {
        this.x1 = x1;
        this.x2 = x2;
        this.y1 = y1;
        this.y2 = y2;
        redraw();
    }

    private function redraw():void {
        graphics.clear();

        graphics.lineStyle(10, selected ? 0x474747 : 0xA5A5A5, 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND);
        graphics.moveTo(x1, y1);
        graphics.lineTo(x2, y2);
        graphics.lineStyle(6, selected ? 0xA3A3A3 : 0xE8E8E8, 1, true, LineScaleMode.NORMAL, CapsStyle.ROUND);
        graphics.moveTo(x1, y1);
        graphics.lineTo(x2, y2);

        graphics.lineStyle(0);
        graphics.beginFill(0x303030);
        graphics.drawCircle(x1, y1, 1);
        graphics.drawCircle(x2, y2, 1);
        graphics.endFill();

        if (over) {
            graphics.lineStyle(12, 0xCDDC39, 0.4, true, LineScaleMode.NORMAL, CapsStyle.ROUND);
            graphics.moveTo(x1, y1);
            graphics.lineTo(x2, y2);
        }
    }


    public function get selected():Boolean {
        return _selected;
    }

    public function set selected(value:Boolean):void {
        if (_selected == value) return;
        _selected = value;
        redraw();
        dispatchEvent(new Event(SELECTED_CHANGED_EVENT));
    }

    public function get over():Boolean {
        return _over;
    }

    public function set over(value:Boolean):void {
        if (_over == value) return;
        _over = value;
        redraw();
        dispatchEvent(new Event(OVER_CHANGED_EVENT));
    }

    private function rollOverHandler(event:MouseEvent):void {
        over = true;
    }

    private function rollOutHandler(event:MouseEvent):void {
        over = false;
    }

    private function clickHandler(event:MouseEvent):void {
        selected = !selected;
    }

    public function get size():Number {
        return Math.round(Math.sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)));
    }
}
}
