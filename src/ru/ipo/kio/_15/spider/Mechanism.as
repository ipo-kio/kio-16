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

    private var MUL:Number;

    public static const EVENT_ANGLE_CHANGED:String = 'angle changed';

    // http://www.mekanizmalar.com/mechanicalspider.html
    // ----------------
    private var p1x:Number = 41.395, p1y:Number = -26.641;
    private var p2x:Number = 27.690, p2y:Number = -19.705;
    private var p3x:Number = 27.690, p3y:Number = -31.092;

    private var _l1:Number = Math.round(dist(p1x, p1y, 36.033, -25.415));
    private var _l2:Number = Math.round(dist(36.033, -25.415, 21.501, -22.089));
    private var _l3:Number = Math.round(dist(21.501, -22.089, p2x, p2y));
    private var _l4:Number = Math.round(dist(21.501, -22.089, 10.879, -21.918));
    private var _l5:Number = Math.round(dist(10.879, -21.918, 19.432, -32.923));
    private var _l6:Number = Math.round(dist(19.432, -32.923, 27.690, -31.092));
    private var _l7:Number = Math.round(dist(10.879, -21.918, 0, 0));
    private var a1:Number = -rotationAngle(36.033, -25.415, 21.501, -22.089, 10.879, -21.918);
    private var a2:Number = rotationAngle(19.432, -32.923, 10.879, -21.918, 0, 0);
    // ----------------

    private var mx:Number, my:Number;
    private var nx:Number, ny:Number;
    private var kx:Number, ky:Number;
    private var lx:Number, ly:Number;
    private var sx:Number, sy:Number;

    private var _broken:Boolean = false;
    private var _brokenStep:int = 0;

    public function Mechanism(MUL:Number = 1.3) {
        this.MUL = MUL;

        p1x *= MUL;
        p1y *= MUL;
        p2x *= MUL;
        p2y *= MUL;
        p3x *= MUL;
        p3y *= MUL;
        _l1 *= MUL;
        _l2 *= MUL;
        _l3 *= MUL;
        _l4 *= MUL;
        _l5 *= MUL;
        _l6 *= MUL;
        _l7 *= MUL;

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
        }

        graphics.lineStyle(4, _grayed ? 0xCDDC39 : 0x03A9F4, 1);
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

        graphics.lineStyle(0);
        graphics.beginFill(0x212121);
        graphics.drawCircle(p1x * sign, p1y, 1);
        graphics.drawCircle(p2x * sign, p2y, 1);
        graphics.drawCircle(p3x * sign, p3y, 1);
        graphics.drawCircle(mx * sign, my, 1);
        graphics.drawCircle(nx * sign, ny, 1);
        graphics.drawCircle(kx * sign, ky, 1);
        graphics.drawCircle(lx * sign, ly, 1);
        graphics.drawCircle(sx * sign, sy, 1);
        graphics.endFill();
    }

    public function get angle():Number {
        return _angle;
    }

    public function set angle(value:Number):void {
        _angle = x_inverse ? -value : value;
        evaluate();
        redraw();
        dispatchEvent(new Event(EVENT_ANGLE_CHANGED));
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
        _broken = false;

        //M
        mx = p1x + _l1 * Math.cos(_angle);
        my = p1y + _l1 * Math.sin(_angle);

        //N
        var int1:Vector.<Number> = intersect(mx, my, _l2, p2x, p2y, _l3);
        if (int1 == null) {
            _broken = true;
            _brokenStep = 1;
            return;
        }

        nx = int1[0];
        ny = int1[1];

        //K
        var int2:Vector.<Number> = continueByAngle(mx, my, nx, ny, a1, _l4);
        kx = int2[0];
        ky = int2[1];

        //L
        var int3:Vector.<Number> = intersect(p3x, p3y, _l6, kx, ky, _l5);
        if (int3 == null) {
            _broken = true;
            _brokenStep = 2;
            return;
        }
        lx = int3[0];
        ly = int3[1];

        //S
        var int4:Vector.<Number> = continueByAngle(lx, ly, kx, ky, a2, _l7);
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
        if (isNaN(t1))
            return null;
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


    public function get l1():Number {
        return _l1;
    }

    public function set l1(value:Number):void {
        _l1 = value;
        evaluate();
    }

    public function get l2():Number {
        return _l2;
    }

    public function set l2(value:Number):void {
        _l2 = value;
        evaluate();
    }

    public function get l3():Number {
        return _l3;
    }

    public function set l3(value:Number):void {
        _l3 = value;
        evaluate();
    }

    public function get l4():Number {
        return _l4;
    }

    public function set l4(value:Number):void {
        _l4 = value;
        evaluate();
    }

    public function get l5():Number {
        return _l5;
    }

    public function set l5(value:Number):void {
        _l5 = value;
        evaluate();
    }

    public function get l6():Number {
        return _l6;
    }

    public function set l6(value:Number):void {
        _l6 = value;
        evaluate();
    }

    public function get l7():Number {
        return _l7;
    }

    public function set l7(value:Number):void {
        _l7 = value;
        evaluate();
    }

    public function get broken():Boolean {
        return _broken;
    }

    public function get brokenStep():int {
        return _brokenStep;
    }

    public function curve(steps:int):Vector.<Point> {
        var was_angle:Number = _angle;
        var res:Vector.<Point> = new <Point>[];

        for (var s:int = 0; s < steps; s++) {
            _angle = 2 * Math.PI * s / steps;
            evaluate();
            if (!_broken)
                res.push(s_p);
            else
                res.push(null);
        }

        _angle = was_angle;
        evaluate();

        return res;
    }

    public function get ls():Vector.<Number> {
        return new <Number>[
            l1,
            l2,
            l3,
            l4,
            l5,
            l6,
            l7
        ];
    }

    public function set ls(value:Vector.<Number>):void {
        _l1 = value[0] * MUL / 1.3;
        _l2 = value[1] * MUL / 1.3;
        _l3 = value[2] * MUL / 1.3;
        _l4 = value[3] * MUL / 1.3;
        _l5 = value[4] * MUL / 1.3;
        _l6 = value[5] * MUL / 1.3;
        _l7 = value[6] * MUL / 1.3;

        evaluate();
    }
}
}

//TODO draw path for two double sticks
//TODO if point below ground, stop