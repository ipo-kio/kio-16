/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 26.01.13
 * Time: 18:27
 */
package ru.ipo.kio._13.cut.model {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Point;

import pl.bmnet.gpcas.geometry.Poly;

public class ColoredPoly extends EventDispatcher {

    public static const COLOR_CHANGED:String = 'cl ch';

    private var _poly:Poly;
    private var _color:Boolean;
    private var _area:Number;

    public function ColoredPoly(poly:Poly, color:Boolean) {
        _poly = poly;
        _color = color;

        evalArea();
    }

    public function get poly():Poly {
        return _poly;
    }

    public function set poly(value:Poly):void {
        _poly = value;
    }

    public function get color():Boolean {
        return _color;
    }

    public function get area():Number {
        return _area;
    }

    public function get isNormal():Boolean {
        return _area >= 16;
    }

    public function set color(value:Boolean):void {
        if (value == _color)
            return;
        _color = value;
        dispatchEvent(new Event(COLOR_CHANGED));
    }

    public function swap():ColoredPoly {
        return new ColoredPoly(_poly, ! color);
    }

    private function evalArea():void {
        _area = 0;
        var n:int = _poly.getNumPoints();
        var prev:Point = _poly.getPoint(n - 1);
        for (var i:int = 0; i < n; i++) {
            var next:Point = _poly.getPoint(i);

            _area += prev.x * next.y - prev.y * next.x;

            prev = next;
        }

        _area = Math.abs(_area) / 2;
    }

}
}
