/**
 * Created by ilya on 13.02.15.
 */
package ru.ipo.kio._15.spider {
import flash.display.Sprite;
import flash.events.Event;

public class Mechanism extends Sprite {

    private var _angle:Number = 0; // angle

    private const MUL:Number = 5;

    private var p1x:Number = 41.395 * MUL, p1y:Number = -26.641 * MUL;
    private var p2x:Number = 27.690 * MUL, p2y:Number = -19.705 * MUL;
    private var p3x:Number = 27.690 * MUL, p3y:Number = -31.092 * MUL;

    private var l1:Number = dist(p1x, p1y, 36.033 * MUL, -25.415 * MUL);
    private var l2:Number = dist(36.033 * MUL, -25.415 * MUL, 21.501 * MUL, -22.089 * MUL);
    private var l3:Number = dist(21.501 * MUL, -22.089 * MUL, p2x, p2y);

    private var mx:Number, my:Number;
    private var nx:Number, ny:Number;

    public function Mechanism() {
        evaluate();
        redraw();

        addEventListener(Event.ENTER_FRAME, animate);
    }

    private function animate(event:Event):void {
        angle += 0.03;
    }

    private function redraw():void {
        graphics.clear();

        graphics.lineStyle(1, 0x000000);
        graphics.moveTo(p1x, p1y);
        graphics.lineTo(p2x, p2y);
        graphics.lineTo(p3x, p3y);
        graphics.lineTo(p1x, p1y);

        graphics.lineStyle(2, 0x440000);
        graphics.moveTo(p1x, p1y);
        graphics.lineTo(mx, my);
        graphics.lineTo(nx, ny);
        graphics.lineTo(p2x, p2y);

        graphics.lineStyle(0.5, 0xFFFF00);
        graphics.drawCircle(p2x, p2y, l3);
        graphics.drawCircle(mx, my, l2);
    }

    public function get angle():Number {
        return _angle;
    }

    public function set angle(value:Number):void {
        _angle = value;
        evaluate();
        redraw();
    }

    public function evaluate():void {
        //M
        mx = p1x + l1 * Math.cos(_angle);
        my = p1y + l1 * Math.sin(_angle);

        var int1:Vector.<Number> = intersect(mx, my, l2, p2x, p2y, l3);
        nx = int1[0];
        ny = int1[1];
    }

    private static function intersect(x1:Number, y1:Number, r1:Number, x2:Number, y2:Number, r2:Number):Vector.<Number> {
        var d:Number = dist(x1, y1, x2, y2);

        var dSum:Number = (r1 * r1 - r2 * r2) / d;
        var d1:Number = (d + dSum) / 2;

        var lx:Number = (x2 - x1) * d1 / d;
        var ly:Number = (y2 - y1) * d1 / d;

        var t1:Number = Math.sqrt(r1 * r1 - d1 * d1);
        var nx:Number = (y1 - y2) * t1 / d;
        var ny:Number = (x2 - x1) * t1 / d;

        return new <Number>[x1 + lx + nx, y1 + ly + ny, x1 + lx - nx, y1 + ly - ny];
    }

    private static function dist(x1:Number, y1:Number, x2:Number, y2:Number):Number {
        return Math.sqrt(dist2(x1, x2, y1, y2));
    }

    private static function dist2(x1:Number, x2:Number, y1:Number, y2:Number):Number {
        return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
    }
}
}
