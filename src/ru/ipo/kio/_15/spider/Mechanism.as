/**
 * Created by ilya on 13.02.15.
 */
package ru.ipo.kio._15.spider {
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

public class Mechanism extends Sprite {

    private var _angle:Number = 0; // angle
    private var _grayed:Boolean = false;
    private var _x_inverse:Boolean = false;

    private const MUL:Number = 1.5;

    // http://www.mekanizmalar.com/mechanicalspider.html
    private var p1x:Number = 41.395 * MUL, p1y:Number = -26.641 * MUL;
    private var p2x:Number = 27.690 * MUL, p2y:Number = -19.705 * MUL;
    private var p3x:Number = 27.690 * MUL, p3y:Number = -31.092 * MUL;

    private var l1:Number = dist(p1x, p1y, 36.033 * MUL, -25.415 * MUL);
    private var l2:Number = dist(36.033 * MUL, -25.415 * MUL, 21.501 * MUL, -22.089 * MUL);
    private var l3:Number = dist(21.501 * MUL, -22.089 * MUL, p2x, p2y);
    private var l4:Number = dist(21.501 * MUL, -22.089 * MUL, 10.879 * MUL, -21.918 * MUL);
    private var l5:Number = dist(10.879 * MUL, -21.918 * MUL, 19.432 * MUL, -32.923 * MUL);
    private var l6:Number = dist(19.432 * MUL, -32.923 * MUL, 27.690 * MUL, -31.092 * MUL);
    private var l7:Number = dist(10.879 * MUL, -21.918 * MUL, 0, 0);
    private var a1:Number = -rotationAngle(36.033 * MUL, -25.415 * MUL, 21.501 * MUL, -22.089 * MUL, 10.879 * MUL, -21.918 * MUL);
    private var a2:Number = rotationAngle(19.432 * MUL, -32.923 * MUL, 10.879 * MUL, -21.918 * MUL, 0, 0);

    private var mx:Number, my:Number;
    private var nx:Number, ny:Number;
    private var kx:Number, ky:Number;
    private var lx:Number, ly:Number;
    private var sx:Number, sy:Number;

    public function Mechanism() {
        evaluate();
        redraw();
    }

    private function get sign():Number {
        return _x_inverse ? -1 : 1;
    }

    private function redraw():void {
        graphics.clear();

        if (!_grayed) {
//            graphics.lineStyle(1, 0x727272);
            graphics.beginFill(0x727272);
            graphics.drawTriangles(new <Number>[
                p1x * sign, p1y,
                p2x * sign, p2y,
                p3x * sign, p3y
            ]);
            graphics.endFill();
//            graphics.moveTo(p1x * sign, p1y);
//            graphics.lineTo(p2x * sign, p2y);
//            graphics.lineTo(p3x * sign, p3y);
//            graphics.lineTo(p1x * sign, p1y);
        }

        graphics.lineStyle(4, _grayed ? 0x03A9F4 : 0xCDDC39, 1);
        graphics.moveTo(p1x * sign, p1y);
        graphics.lineTo(mx * sign, my);
        graphics.lineTo(nx * sign, ny);
        graphics.lineTo(p2x * sign, p2y);

        graphics.moveTo(nx * sign, ny);
        graphics.lineTo(kx * sign, ky);
        graphics.lineTo(lx * sign, ly);
        graphics.lineTo(p3x * sign, p3y);

        graphics.moveTo(kx * sign, ky);
        graphics.lineTo(sx * sign, sy);

        /*graphics.lineStyle(0.5, 0xFFFF00);
        graphics.drawCircle(p2x, p2y, l3);
        graphics.drawCircle(mx, my, l2);*/
    }

    public function get angle():Number {
        return _angle;
    }

    public function set angle(value:Number):void {
        _angle = x_inverse ? -value : value;
        evaluate();
        redraw();
    }

    public function get grayed():Boolean {
        return _grayed;
    }

    public function set grayed(value:Boolean):void {
        _grayed = value;
        redraw();
    }

    public function get x_inverse():Boolean {
        return _x_inverse;
    }

    public function set x_inverse(value:Boolean):void {
        _x_inverse = value;
    }

    public function get m_p():Point {
        return new Point(mx * sign, my);
    }

    public function get n_p():Point {
        return new Point(nx * sign, ny);
    }

    public function get k_p():Point {
        return new Point(kx * sign, ky);
    }

    public function get l_p():Point {
        return new Point(lx * sign, ly);
    }

    public function get s_p():Point {
        return new Point(sx * sign, sy);
    }

    public function get p1_p():Point {
        return new Point(p1x * sign, p1y);
    }

    public function get p2_p():Point {
        return new Point(p2x * sign, p2y);
    }

    public function get p3_p():Point {
        return new Point(p3x * sign, p3y);
    }

    public function evaluate():void {
        //M
        mx = p1x + l1 * Math.cos(_angle);
        my = p1y + l1 * Math.sin(_angle);

        //N
        var int1:Vector.<Number> = intersect(mx, my, l2, p2x, p2y, l3);
        nx = int1[0];
        ny = int1[1];

        //K
        var int2:Vector.<Number> = continueByAngle(mx, my, nx, ny, a1, l4);
        kx = int2[0];
        ky = int2[1];

        //L
        var int3:Vector.<Number> = intersect(p3x, p3y, l6, kx, ky, l5);
        lx = int3[0];
        ly = int3[1];

        //S
        var int4:Vector.<Number> = continueByAngle(lx, ly, kx, ky, a2, l7);
        sx = int4[0];
        sy = int4[1];
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

    public static function dist(x1:Number, y1:Number, x2:Number, y2:Number):Number {
        return Math.sqrt(dist2(x1, y1, x2, y2));
    }

    public static function dist2(x1:Number, y1:Number, x2:Number, y2:Number):Number {
        return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
    }

    private static function rotationAngle(x1:Number, y1: Number, x2:Number, y2: Number, x3:Number, y3: Number):Number {
        var m:Number = (x3 - x2) * (x1 - x2) + (y3 - y2) * (y1 - y2);
        var c:Number = m / (dist(x1, y1, x2, y2) * Mechanism.dist(x2, y2, x3, y3));
        var s:Number = Math.sqrt(1 - c * c);
        return Math.atan2(s, c);
    }

    private static function continueByAngle(x1:Number, y1:Number, x2:Number, y2:Number, a:Number, l:Number):Vector.<Number> {
        var aCos:Number = Math.cos(a);
        var aSin:Number = Math.sin(a);
        var n0x:Number = x1 - x2;
        var n0y:Number = y1 - y2;

        var d:Number = dist(x1, y1, x2, y2);

        var nx:Number = n0x * l / d;
        var ny:Number = n0y * l / d;

        // cos -sin
        // sin cos
        var mx:Number = aCos * nx - aSin * ny;
        var my:Number = aSin * nx + aCos * ny;

        return new <Number>[x2 + mx, y2 + my];
    }
}
}
