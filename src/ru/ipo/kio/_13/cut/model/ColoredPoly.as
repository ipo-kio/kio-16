/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 26.01.13
 * Time: 18:27
 */
package ru.ipo.kio._13.cut.model {
import flash.events.Event;
import flash.events.EventDispatcher;

import pl.bmnet.gpcas.geometry.Poly;

public class ColoredPoly extends EventDispatcher {

    public static const COLOR_CHANGED:String = 'cl ch';

    private var _poly:Poly;
    private var _color:Boolean;

    public function ColoredPoly(poly:Poly, color:Boolean) {
        _poly = poly;
        _color = color;
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

    public function set color(value:Boolean):void {
        if (value == _color)
            return;
        _color = value;
        dispatchEvent(new Event(COLOR_CHANGED));
    }

    public function swap():ColoredPoly {
        return new ColoredPoly(_poly, ! color);
    }
}
}
