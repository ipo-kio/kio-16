/**
 * Created by ilya on 29.01.15.
 */
package ru.ipo.kio._15.traincars {
import flash.display.Sprite;
import flash.geom.Point;

import ru.ipo.kio._15.traincars.CurveRail;

public class RailsSet extends Sprite {

    private var rails:Vector.<CurveRail> = new <CurveRail>[];
//    private var graph:Vector.<Vector.<int>> = new <Vector.<int>>[];

    public function RailsSet() {
    }

    public function add(p0:Point, p1:Point, p2:Point):int {
        var prevRail:CurveRail = searchRailByLastPoint(p0);
        var prevDist:Number = prevRail == null ? 0 : prevRail.startDistance + prevRail.length;

        var rail:CurveRail = new CurveRail(p0, p1, p2, prevDist);

        rails.push(rail);
        addChild(rail);

        return rails.length - 1;
    }

    //returns [point left, point right, left way indicies, right way indicies]
    public function addVerticalSwitch(start:Point, h:Number, w:Number):Array {
        var h4:Number = h / 4;
        var w2:Number = w / 2;
        var e1:Point = new Point(start.x + w2, start.y + 2 * h4); // right
        var e2:Point = new Point(start.x - w2, start.y + 2 * h4); // left
        var i1:int = add(start, new Point(start.x, start.y + h4), e1); // right
        var i2:int = add(start, new Point(start.x, start.y + h4), e2); // left

        var f1:Point = new Point(start.x + 2 * w2, start.y + 4 * h4); // right
        var f2:Point = new Point(start.x - 2 * w2, start.y + 4 * h4); // left
        var i3:int = add(e1, new Point(start.x + 2 * w2, start.y + 3 * h4), f1); // rigth
        var i4:int = add(e2, new Point(start.x - 2 * w2, start.y + 3 * h4), f2); // left

        return [f2, f1, [i2, i4], [i1, i3]];
    }

    public function addLine(p0:Point, p2:Point):int {
        var p1:Point = new Point((p0.x + p2.x) / 2, (p0.y + p2.y) / 2);
        return add(p0, p1, p2);
    }

    private function searchRailByLastPoint(p:Point):CurveRail {
        for each (var r:CurveRail in rails)
            if (r.p2.equals(p))
                return r;

        return null;
    }

    public function rail(i:int):CurveRail {
        return rails[i];
    }

    public function get size():int {
        return rails.length;
    }
}
}
