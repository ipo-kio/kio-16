/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 22.02.11
 * Time: 16:13
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.digit {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

public class DigitElement extends Sprite {

    private var _breakable:Boolean = false;
    private var _broken:Boolean = false;
    private var _on:Boolean = false;
    private var _mouse_over:Boolean = false;

    private var on_bmp:BitmapData;
    private var off_bmp:BitmapData;
    private var on_over_bmp:BitmapData;
    private var off_over_bmp:BitmapData;
    private var br_bmp:BitmapData;
    private var br_over_bmp:BitmapData;

    private var _digit:Digit;
    private var _ind:int;

    public function DigitElement(digit:Digit, ind:int, on:BitmapData, off:BitmapData, on_over:BitmapData, off_over:BitmapData, br:BitmapData, br_over:BitmapData) {
        _ind = ind;
        _digit = digit;

        on_bmp = on;
        off_bmp = off;
        on_over_bmp = on_over;
        off_over_bmp = off_over;
        br_bmp = br;
        br_over_bmp = br_over;

        addEventListener(MouseEvent.ROLL_OVER, mouseRollOver);
        addEventListener(MouseEvent.ROLL_OUT, mouseRollOut);
        addEventListener(MouseEvent.CLICK, mouseClick);

        redraw();
    }

    private function mouseClick(event:Event):void {
        if (broken)
            _digit.broken_index = -1;
        else
            _digit.broken_index = _ind;
    }

    private function mouseRollOut(event:Event):void {
        mouse_over = false;
    }

    private function mouseRollOver(event:Event):void {
        mouse_over = true;
    }

    public function get breakable():Boolean {
        return _breakable;
    }

    public function set breakable(value:Boolean):void {
        _breakable = value;
        if (!_breakable) {
            broken = false;
            mouse_over = false;
        }
    }

    public function get broken():Boolean {
        return _broken;
    }

    public function set broken(value:Boolean):void {
        if (_breakable) {
            _broken = value;
            redraw();
        }
    }

    public function get on():Boolean {
        return _on;
    }

    public function set on(value:Boolean):void {
        _on = value;
        redraw();
    }

    public function get mouse_over():Boolean {
        return _mouse_over;
    }

    public function set mouse_over(value:Boolean):void {
        if (_breakable) {
            _mouse_over = value;
            redraw();
        }
    }

    public function redraw():void {
        //choose bitmap
        var bmp:BitmapData;
        if (_broken) {
            if (_mouse_over)
                    bmp = br_over_bmp;
                else
                    bmp = br_bmp;
        } else {
            if (_on) {
                if (_mouse_over)
                    bmp = on_over_bmp;
                else
                    bmp = on_bmp;
            } else {
                if (_mouse_over)
                    bmp = off_over_bmp;
                else
                    bmp = off_bmp;
            }
        }

        graphics.clear();
        graphics.beginBitmapFill(bmp);
        graphics.drawRect(0, 0, bmp.width, bmp.height);
        graphics.endFill();
    }
}
}
