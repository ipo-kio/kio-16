package ru.ipo.kio._16.mars.view {
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;

import ru.ipo.kio._16.mars.model.Orbit;

public class OrbitView extends Sprite {
    private var _o:Orbit;
    private var _scale:Number;

    private var _color:uint;
    private var _alpha:Number;

    private var view:Shape = new Shape();

    public function OrbitView(o:Orbit, scale:Number, color:uint, alpha:Number) {
        _o = o;
        _scale = scale;
        _color = color;
        _alpha = alpha;

        view = new Shape();
        addChild(view);

        redraw();
    }

    private function redraw():void {
        var m:Matrix = new Matrix();
        m.translate(-_o.c * _scale, 0);
        m.rotate(_o.theta0);
//        m.scale(_scale, _scale);
        view.transform.matrix = m;

        view.graphics.lineStyle(1, _color, _alpha);
//        graphics.lineStyle(1 / _scale, _color, _alpha);
        view.graphics.drawEllipse(-_o.a * _scale, -_o.b * _scale, 2 * _o.a * _scale, 2 * _o.b * _scale);
    }

    public function get o():Orbit {
        return _o;
    }
}
}
