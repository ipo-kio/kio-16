/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 26.01.13
 * Time: 15:44
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.cut.model {

import flash.geom.Point;

import pl.bmnet.gpcas.geometry.Poly;
import pl.bmnet.gpcas.geometry.PolyDefault;
import pl.bmnet.gpcas.geometry.PolySimple;

public class Cut {

    private static const R:int = 1000;

    private var _1:FieldCords;
    private var _2:FieldCords;
    private var leftPoly:Poly;
    private var rightPoly:Poly;

    public function Cut(p1:FieldCords, p2:FieldCords) {
        _1 = p1;
        _2 = p2;

        //evaluate both polys

        var isHorizontal:Boolean = Math.abs(_1.x - _2.x) > Math.abs(_1.y - _2.y);

        var a:int = _2.y - _1.y;
        var b:int = _1.x - _2.x;
        var c:int = _2.x * _1.y - _1.x * _2.y;
        // a x + b y + c = 0
        // y = (- c - a x) / b
        // x = (- c - b y) / a

        if (isHorizontal) {
            var int1_x:Number = R;
            var int1_y:Number = (- c - a * int1_x) / b;
            var int2_x:Number = -R;
            var int2_y:Number = (- c - a * int2_x) / b;
        } else {
            int1_y = R;
            int1_x = (- c - b * int1_y) / a;
            int2_y = -R;
            int2_x = (- c - b * int2_y) / a;
        }

        leftPoly = new PolyDefault();
        leftPoly.addPointXY(int1_x, int1_y);
        leftPoly.addPointXY(int2_x, int2_y);

        rightPoly = new PolyDefault();
        rightPoly.addPointXY(int1_x, int1_y);
        rightPoly.addPointXY(int2_x, int2_y);

        if (isHorizontal) {
            leftPoly.addPointXY(-R, R);
            leftPoly.addPointXY(R, R);
            rightPoly.addPointXY(-R, -R);
            rightPoly.addPointXY(R, -R);
        } else {
            leftPoly.addPointXY(-R, -R);
            leftPoly.addPointXY(-R, R);
            rightPoly.addPointXY(R, -R);
            rightPoly.addPointXY(R, R);
        }
    }

    public function get p1():FieldCords {
        return _1;
    }

    public function get p2():FieldCords {
        return _2;
    }

    /**
     * Crosses polygon with a line
     * @param poly
     * @return arrays of two polys, they may be null if there is no intersection
     */
    public function divide(poly:Poly):Array {
        var left:Poly = poly.intersection(leftPoly);
        var right:Poly = poly.intersection(rightPoly);

        if (left.isEmpty())
            left = null;

        if (right.isEmpty())
            right = null;

        return [left, right];
    }

    public function toTheLeft(poly:Poly):Boolean {
        var right:Poly = rightPoly.intersection(poly);
        return right.isEmpty();
    }

    public function intersectWith(xMax:Number, yMax:Number):Array {
        var square:Poly = new PolyDefault();
        square.addPointXY(0, 0);
        square.addPointXY(0, yMax);
        square.addPointXY(xMax, yMax);
        square.addPointXY(xMax, 0);

        var intersection:Poly = leftPoly.intersection(square);

        if (intersection.isEmpty())
            return null;

        var n:int = intersection.getNumPoints();
        var prev:Point = intersection.getPoint(n - 1);
        for (var i:int = 0; i < n; i++) {
            var next:Point = intersection.getPoint(i);
            var isHorizontalSide:Boolean = cmp(prev.y, next.y) && (cmp(prev.y, 0) || cmp(prev.y, yMax));
            var isVerticalSide:Boolean = cmp(prev.x, next.x) && (cmp(prev.x, 0) || cmp(prev.x, xMax));

            if (!isHorizontalSide && !isVerticalSide)
                return [prev, next];

            prev = next;
        }

        return null;
    }

    private function cmp(a:Number, b:Number):Boolean {
        return Math.abs(a - b) < 1e-8;
    }
}
}
