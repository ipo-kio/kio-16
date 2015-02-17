/**
 * Created by ilya on 17.02.15.
 */
package ru.ipo.kio._15.spider {
import flash.display.Sprite;
import flash.geom.Point;

public class Floor extends Sprite {

    private var _points:Vector.<Point>;

    public function Floor() {
        _points = new <Point>[];
        _points.push(
                new Point(0, 0),
                new Point(100, 0),
                new Point(200, -20),
                new Point(300, 0),
                new Point(400, -30),
                new Point(450, -30),
                new Point(500, 10),
                new Point(600, -10),
                new Point(700, -30),
                new Point(780, 0)
        );

        redraw();
    }

    private function redraw():void {
        graphics.lineStyle(2, 0x00000);
        graphics.moveTo(_points[0].x, _points[0].y);
        for (var i:int = 1; i < _points.length; i++) {
            var point:Point = _points[i];
            graphics.lineTo(point.x, point.y);
        }
    }

    public function get points():Vector.<Point> {
        return _points;
    }

    public function intersectWithCircle(x:Number, y:Number, r2:Number):Vector.<Point> {
        var res:Vector.<Point> = new <Point>[];

        for (var i:int = 0; i < _points.length - 1; i++) {
            var p1:Point = _points[i];
            var p2:Point = _points[i + 1];
            for each (var point:Point in intersectSegmentWithCircle(x, y, r2, p1, p2))
                res.push(point);
        }

        return res;
    }

    public static function intersectSegmentWithCircle(x:Number, y:Number, r2:Number, p1:Point, p2:Point):Vector.<Point> {
        function a2p(alpha:Number):Point {
            if (alpha < 0 || alpha > 1)
                return null;
            return new Point(
                    p1.x * alpha + p2.x * (1 - alpha),
                    p1.y * alpha + p2.y * (1 - alpha)
            );
        }

        var c:Point = new Point(x, y);
        var a:Point = p1.subtract(c);
        var b:Point = p2.subtract(c);

        var a_2:Number = a.x * a.x + a.y * a.y;
        var b_2:Number = b.x * b.x + b.y * b.y;
        var ab:Number = a.x * b.x + a.y * b.y;

        // A * alpha^2 + B * alpha + C = 0
        var A:Number = a_2 + b_2 - 2 * ab; // not 0
        var B:Number = -2 * b_2 + 2 * ab;
        var C:Number = b_2 - r2;

        var D:Number = B * B - 4 * A * C;

        var res:Vector.<Point> = new <Point>[];
        if (D < 0)
            return res;

        if (D == 0) {
            var j:Point = a2p(-B / (2 * A));
            if (j != null)
                res.push(j);
            return res;
        }

        j = a2p((-B - Math.sqrt(D)) / (2 * A));
        if (j != null)
            res.push(j);
        j = a2p((-B + Math.sqrt(D)) / (2 * A))
        if (j != null)
            res.push(j);

        return res;
    }

    /**
     * lower, upper or on the floor
     * @param x x coordinate
     * @param y y coordinate
     * @return < 0 means lower, = 0 means on, > 0 means over
     */
    public function pointPosition(x:Number, y:Number):Number {
        for (var i:int = 0; i < _points.length; i++) {
            if (i < _points.length - 1) {
                var p1:Point = _points[i];
                var p2:Point = _points[i + 1];
            } else {
                p1 = _points[i - 1];
                p2 = _points[i];
            }

            if (p2.x > x || i == _points.length - 1) {
                var t1x:Number = p2.x - p1.x;
                var t1y:Number = p2.y - p1.y;
                var t2x:Number = x - p1.x;
                var t2y:Number = y - p1.y;

                return t1x * t2y - t2x * t1y;
            }
        }

        return 0; // can not occur;
    }
}
}
