/**
 * Created by ilya on 29.01.15.
 */
package ru.ipo.kio._15.traincars.loc {
import flash.display.Sprite;
import flash.geom.Point;

import ru.ipo.kio._15.traincars.CurveRail;

public class RailsSet extends Sprite {

    private var rails:Vector.<CurveRail> = new <CurveRail>[];

    public function RailsSet() {
    }

    public function add(p0:Point, p1:Point, p2:Point):int {
        var prevRail:CurveRail = searchRailByLastPoint(p0);
        var prevDist:Number = prevRail == null ? 0 : prevRail.startDistance + prevRail.length;

        var rail:CurveRail = new CurveRail(p0, p1, p2, prevDist, 2, 3, 6);

        rails.push(rail);
        addChild(rail);
        return rail.length - 1;
    }

    private function searchRailByLastPoint(p:Point):CurveRail {
        for each (var r:CurveRail in rails)
            if (r.p2.equals(p))
                return r;

        return null;
    }
}
}
