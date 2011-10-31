package ru.ipo.kio._11_students.CrossedCountry {
/**
 * ...
 * @author Anna
 */

import flash.geom.*;

public class LMath {

    public function LMath() {

    }

    public function bezier3(p0:int, p1:int, p2:int, t:Number):Number {
        return (1 - t) * (1 - t) * p0 + 2 * t * (1 - t) * p1 + t * t * p2;
    }

    public function returnRotation(point1:Point, point2:Point):Number {
        var myX:int, myY:int;
        myX = point1.x - point2.x;
        myY = point1.y - point2.y
        return 90 - Math.atan2(myX, myY) * 180 / Math.PI;
    }

    public function rotateForCentre(centr:Point, point:Point, angel:Number):Point {
        var m3D:Matrix3D = new Matrix3D();
        m3D.appendRotation(angel, new Vector3D(0, 0, 1));
        var myPivotPoint:Vector3D = new Vector3D(centr.x, centr.y, 0);
        var pointVec:Vector3D = new Vector3D(point.x, point.y, 0);
        pointVec.decrementBy(myPivotPoint);//вычитание векторов

        pointVec = m3D.transformVector(pointVec);//ротация

        pointVec.incrementBy(myPivotPoint);//сложение векторов
        return new Point(pointVec.x, pointVec.y);
    }

    public function lineCross(b:Point, e:Point, b1:Point, e1:Point):Boolean {
        //взято с http://progs-maker.narod.ru/algor.html
        var x1:Number = b.x;
        var y1:Number = b.y;
        var x2:Number = e.x;
        var y2:Number = e.y;
        var x3:Number = b1.x;
        var y3:Number = b1.y;
        var x4:Number = e1.x;
        var y4:Number = e1.y;

        var maxx1:Number = Math.max(x1, x2);
        var maxy1:Number = Math.max(y1, y2);
        var minx1:Number = Math.min(x1, x2);
        var miny1:Number = Math.min(y1, y2);
        var maxx2:Number = Math.max(x3, x4);
        var maxy2:Number = Math.max(y3, y4);
        var minx2:Number = Math.min(x3, x4);
        var miny2:Number = Math.min(y3, y4);

        var dx21:Number = x2 - x1, dy21:Number = y2 - y1; // Длина проекций первой линии на ось x и y
        var dx43:Number = x4 - x3, dy43:Number = y4 - y3; // Длина проекций второй линии на ось x и y
        var dx13:Number = x1 - x3, dy13:Number = y1 - y3;

        var div:Number, mul:Number;
        div = dy43 * dx21 - dx43 * dy21;
        if (div == 0)
            return false; // Линии параллельны...

        if (div > 0) {
            mul = dx43 * dy13 - dy43 * dx13;
            if (mul < 0 || mul > div)
                return false; // Первый отрезок пересекается за своими границами...
            mul = dx21 * dy13 - dy21 * dx13;
            if (mul < 0 || mul > div) return false; // Второй отрезок пересекается за своими границами...
        } else {
            mul = - (dx43 * dy13 - dy43 * dx13);
            if (mul < 0 || mul > -div)
                return false; // Первый отрезок пересекается за своими границами...
            mul = - (dx21 * dy13 - dy21 * dx13);
            if (mul < 0 || mul > -div)
                return false; // Второй отрезок пересекается за своими границами...
        }
        return true;
    }

    public function lineIntersect(lineAP1:Point, lineAP2:Point, lineBP1:Point, lineBP2:Point):Point {
        //http://forum.vingrad.ru/faq/topic-157574.html
        var lDetlineA:Number, lDetlineB:Number, lDetDivInv:Number,
                lDiffLA:Point, lDiffLB:Point,
                result:Point = new Point;
        lDetlineA = lineAP1.x * lineAP2.y - lineAP1.y * lineAP2.x;
        lDetlineB = lineBP1.x * lineBP2.y - lineBP1.y * lineBP2.x;

        lDiffLA = lineAP1.subtract(lineAP2);
        lDiffLB = lineBP1.subtract(lineBP2);

        lDetDivInv = 1 / ((lDiffLA.x * lDiffLB.y) - (lDiffLA.y * lDiffLB.x));

        result.x = ((lDetlineA * lDiffLB.x) - (lDiffLA.x * lDetlineB)) * lDetDivInv;
        result.y = ((lDetlineA * lDiffLB.y) - (lDiffLA.y * lDetlineB)) * lDetDivInv;
        return result;
    }


}

}