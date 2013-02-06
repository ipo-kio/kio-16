/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 26.01.13
 * Time: 15:43
 */
package ru.ipo.kio._13.cut.model {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;

import pl.bmnet.gpcas.geometry.Poly;
import pl.bmnet.gpcas.geometry.PolyDefault;
import pl.bmnet.gpcas.geometry.PolySimple;

import ru.ipo.kio._13.cut.view.CutsFieldView;

public class CutsField extends EventDispatcher {

    public static const CUTS_CHANGED:String = 'cuts';

    private var _cuts:Array;     //of Cuts
    private var _poly:Poly;      //polygon to cut
    private var _polygons:Array; //of ColoredPoly that are cut

    /**
     * @param cuts array of cuts
     * @param poly either Poly or PiecesField
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

            for (var a:int = 0; a <= 1; a++) {
                var poly:Poly = intersection[a];
                if (poly == null)
                    continue;
                var newColor:Boolean = a == 0 ? cp.color : !cp.color;

                for (var innerIndex:int = 0; innerIndex < poly.getNumInnerPoly(); innerIndex++) {
                    var innerPoly:Array/*Poly*/ = splitPoly(poly.getInnerPoly(innerIndex));
                    for each (var ip:Poly in innerPoly) {
                        var polygon:Poly = new PolyDefault();
                        polygon.addPoly(ip);
                        p.push(new ColoredPoly(polygon, newColor));
                    }
                }
            }
        }

        return p;
    }

    private static function splitPoly(poly:Poly):Array {
        //iterate all sides
        var n:int = poly.getNumPoints();
        for (var i:int = 0; i < n; i++) {
            var prev:Point = poly.getPoint(i);
            var j:int = i == n - 1 ? 0 : i + 1;
            var next:Point = poly.getPoint(j);
            //iterate all points, find if there is one on the prev-next side
            for (var k:int = 0; k < n; k++)
                if (k != i && k != j)
                    if (pointOnSegment(poly.getPoint(k), prev, next)) {
                        var firstPoly:Poly = new PolySimple();
                        var secondPoly:Poly = new PolySimple();

                        for (var l:int = k;;) {
                            firstPoly.addPoint(poly.getPoint(l));
                            if (l == i)
                                break;
                            l ++;
                            if (l == n)
                                l = 0;
                        }

                        for (l = k;;) {
                            secondPoly.addPoint(poly.getPoint(l));
                            if (l == j)
                                break;
                            l --;
                            if (l < 0)
                                l = n - 1;
                        }

                        return splitPoly(firstPoly).concat(splitPoly(secondPoly));
                    }
        }

        return [poly];
    }

    private static function pointOnSegment(p:Point, a:Point, b:Point):Boolean {
        var vecMul:Number = (a.x - p.x) * (b.y - p.y) - (a.y - p.y) * (b.x - p.x);
        var scalMul:Number = (a.x - p.x) * (b.x - p.x) + (a.y - p.y) * (b.y - p.y);

        return Math.abs(vecMul) < 1e-10 && scalMul < 0;
    }

    public function destroy():void {
        for each (var cut:Cut in cuts)
            cut.removeEventListener(Cut.CUT_MOVED, cutMoved);
    }
}
}
