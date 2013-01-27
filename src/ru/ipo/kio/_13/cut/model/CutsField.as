/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 26.01.13
 * Time: 15:43
 */
package ru.ipo.kio._13.cut.model {
import flash.events.Event;
import flash.events.EventDispatcher;

import pl.bmnet.gpcas.geometry.Poly;

public class CutsField extends EventDispatcher {

    public static const CUTS_CHANGED:String = 'cuts';

    private var _cuts:Array;     //of Cuts
    private var _poly:Poly;      //polygon to cut
    private var _polygons:Array; //of ColoredPoly that are cut

    private var _resetProcess:Boolean = false;

    public function CutsField(cuts:Array, poly:Poly) {
        _cuts = cuts;
        _poly = poly;

        evaluatePolygons();

        for each (var cut:Cut in cuts)
            cut.addEventListener(Cut.CUT_MOVED, cutMoved);
    }

    public function resetCuts(x1:int, x2:int, y1:int, dy:int):void {
        try {
            for each (var cut:Cut in _cuts) {
                cut.p1 = new FieldCords(x1, y1);
                cut.p2 = new FieldCords(x2, y1);

                y1 += dy;
            }

        } finally {
            //whatever happens, we should make reset back
            _resetProcess = false;
        }

        cutMoved();
    }

    public function get cuts():Array {
        return _cuts;
    }

    public function get poly():Poly {
        return _poly;
    }

    public function get polygons():Array {
        return _polygons;
    }

    private function cutMoved(event:Event = null):void {
        if (_resetProcess)
            return;

        evaluatePolygons();

        dispatchEvent(new Event(CUTS_CHANGED));
    }

    private function evaluatePolygons():void {
        _polygons = [new ColoredPoly(_poly, true)];

        for each (var cut:Cut in _cuts)
            _polygons = doCut(cut, _polygons);

        trace('total polygons after cut:', _polygons.length);
    }

    private static function doCut(cut:Cut, polygons:Array):Array {
        var p:Array = [];

        for each (var cp:ColoredPoly in polygons) {
            var intersection:Array = cut.divide(cp.poly);
            if (intersection[0] != null && intersection[1] != null) {
                p.push(new ColoredPoly(intersection[0], cp.color));
                p.push(new ColoredPoly(intersection[1], ! cp.color));
            } else if (intersection[0] != null)
                p.push(cp);
            else
                p.push(cp.swap());
        }

        return p;
    }
}
}
