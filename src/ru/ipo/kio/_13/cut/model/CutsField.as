/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 26.01.13
 * Time: 15:43
 */
package ru.ipo.kio._13.cut.model {
import pl.bmnet.gpcas.geometry.Poly;

public class CutsField {

    private var _cuts:Array; //of Cuts
    private var _poly:Poly; //polygon to cut
    private var _polygons:Array; //of ColoredPoly that are cut

    public function CutsField(cuts:Array, poly:Poly) {
        _cuts = cuts;
        _poly = poly;

        evaluatePolygons();
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
