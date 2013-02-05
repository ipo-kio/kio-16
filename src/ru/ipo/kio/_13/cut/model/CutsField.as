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
import pl.bmnet.gpcas.geometry.PolyDefault;

import ru.ipo.kio._13.cut.view.CutsFieldView;

public class CutsField extends EventDispatcher {

    public static const CUTS_CHANGED:String = 'cuts';

    private var _cuts:Array;     //of Cuts
    private var _poly:Poly;      //polygon to cut
    private var _polygons:Array; //of ColoredPoly that are cut

    /**
     * @param cuts array of cuts
     * @param poly either Poly or PicesField
     */
    public function CutsField(cuts:Array, poly:*) {
        _cuts = cuts;

        if (poly is PiecesField) {
            _poly = new PolyDefault();
            for each (var fc:FieldCords in PiecesField(poly).outline.slice(1))
                _poly.addPointXY(fc.x * CutsFieldView.SCALE, fc.y * CutsFieldView.SCALE);

        } else
            _poly = poly;

        evaluatePolygons();

        for each (var cut:Cut in cuts)
            cut.addEventListener(Cut.CUT_MOVED, cutMoved);
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
        evaluatePolygons();

        dispatchEvent(new Event(CUTS_CHANGED));
    }

    private function evaluatePolygons():void {
        _polygons = [new ColoredPoly(_poly, true)];

        for each (var cut:Cut in _cuts)
            _polygons = doCut(cut, _polygons);
    }

    private static function doCut(cut:Cut, polygons:Array):Array {
        var p:Array = [];

        for each (var cp:ColoredPoly in polygons) {
            var intersection:Array = cut.divide(cp.poly);

            for (var a:int = 0; a <= 1; a ++) {
                var poly:Poly = intersection[a];
                if (poly == null)
                    continue;
                var newColor:Boolean = a == 0 ? cp.color : ! cp.color;

                for (var innerIndex:int = 0; innerIndex < poly.getNumInnerPoly(); innerIndex ++)
                    {
                        var innerPoly:Poly = poly.getInnerPoly(innerIndex);
                        var polygon:Poly = new PolyDefault();
                        polygon.addPoly(innerPoly);
                        p.push(new ColoredPoly(polygon, newColor));
                    }
            }
        }

        return p;
    }

    public function destroy():void {
        for each (var cut:Cut in cuts)
            cut.removeEventListener(Cut.CUT_MOVED, cutMoved);
    }
}
}
