/**
 * Created by ilya on 25.01.15.
 */
package ru.ipo.kio._15.traincars {
import flash.display.Sprite;
import flash.geom.Point;

public class CurveRail extends Sprite {

    private var p0:Point, p1:Point, _p2:Point;

    private var points:Vector.<Number> = new <Number>[];
    private var _startDistance:Number;
    private var _tieSteps:int;
    private var _tieWidth:Number;
    private var _startK:int;

    // http://en.wikipedia.org/wiki/Bézier_curve

    public function CurveRail(p0:Point, p1:Point, p2:Point, startDistance:Number, dl:Number, tieSteps:int, tieWidth:Number) {
        this.p0 = p0;
        this.p1 = p1;
        this._p2 = p2;
        _startDistance = startDistance;
        _tieSteps = tieSteps;
        _tieWidth = tieWidth;

        var time0:Number = new Date().getTime();

        _startK = Math.ceil(startDistance / dl);
        var k0:int = _startK;
        var l:Number = startDistance + length;
        while (true) {
            var l0:Number = dl * k0;
            if (l0 > l)
                break;

            var t:Number = step(l0 - startDistance);
            if (t != Infinity)
                points.push(t);
            else
                trace('t is null');

            k0++;
        }

        trace(new Date().getTime() - time0);

        draw();
    }

    public function get startDistance():Number {
        return _startDistance;
    }

    public function get p2():Point {
        return _p2;
    }

    private function tiePoints(t:Number):Array {
        var p:Point = parametrize(t);
        var n:Point = parametrizeNorm(t);
        var p1:Point = new Point(p.x + n.x * _tieWidth / 2, p.y + n.y * _tieWidth / 2);
        var p2:Point = new Point(p.x - n.x * _tieWidth / 2, p.y - n.y * _tieWidth / 2);
        return [p1, p2];
    }

    private function draw():void {
        graphics.lineStyle(1.5, 0x000000);

        /*graphics.moveTo(p0.x, p0.y);
        graphics.curveTo(p1.x, p1.y, p2.x, p2.y);*/

        for (var pInd:int = 0; pInd < 2; pInd++) {
            var tieP:Array = tiePoints(0);
            graphics.moveTo(tieP[pInd].x, tieP[pInd].y);

            for each (var t:Number in points) {
                tieP = tiePoints(t);
                graphics.lineTo(tieP[pInd].x, tieP[pInd].y);
            }

            tieP = tiePoints(1);
            graphics.lineTo(tieP[pInd].x, tieP[pInd].y);
        }

        //draw ties
        graphics.lineStyle(1, 0x444444);
        for (var i:int = 0; i < points.length; i++)
            if ((_startK + i) % _tieSteps == 0) {
                t = points[i];
                tieP = tiePoints(t);
                graphics.moveTo(tieP[0].x, tieP[0].y);
                graphics.lineTo(tieP[1].x, tieP[1].y);
            }
    }

    public function get length():Number {
        return lengthBetween(0, 1);
    }

    public function parametrize(t:Number):Point {
        return new Point(
                (1 - t) * (1 - t) * p0.x + 2 * (1 - t) * t * p1.x + t * t * _p2.x,
                (1 - t) * (1 - t) * p0.y + 2 * (1 - t) * t * p1.y + t * t * _p2.y
        );
    }

    public function parametrizeDiff(t:Number):Point {
        return new Point(
                2 * (1 - t) * (p1.x - p0.x) + 2 * t * (_p2.x - p1.x),
                2 * (1 - t) * (p1.y - p0.y) + 2 * t * (_p2.y - p1.y)
        );
    }

    public function parametrizeNorm(t:Number):Point {
        var diff:Point = parametrizeDiff(t);
        //noinspection JSSuspiciousNameCombination
        var point:Point = new Point(diff.y, -diff.x);
        point.normalize(1);
        return point;
    }

    public function step(x:Number):Number {
        var t0:Number = 0;
        var t1:Number = 1;
        var l1:Number = lengthBetween(0, 1);

        if (x > l1)
            return Infinity;

        while (t1 - t0 > 1e-5) {
            var tt:Number = (t0 + t1) / 2;
            var lt:Number = lengthBetween(0, tt);

            if (lt > x)
                t1 = tt;
            else
                t0 = tt;
        }

        return t0;
    }

    public function lengthBetween(t1:Number, t2:Number):Number {
        var sum:Number = 0;

        var N:int = 100;
        var d:Number = (t2 - t1) / N;

        for (var i:int = 0; i <= N; i++) {
            var t:Number = (t1 * (1 - i / N) + i * t2 / N);
            var xa:Number = (1 - t) * (p1.x - p0.x) + t * (_p2.x - p1.x);
            var ya:Number = (1 - t) * (p1.y - p0.y) + t * (_p2.y - p1.y);
            var item:Number = Math.sqrt(xa * xa + ya * ya);
            if (i == 0 || i == N)
                item /= 2;
            sum += item;
        }

        return sum * d;
    }
}
}