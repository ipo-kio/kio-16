package ru.ipo.kio._16.mars.view {
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Point;

import ru.ipo.kio._16.mars.model.Consts;

import ru.ipo.kio._16.mars.model.Orbit;
import ru.ipo.kio._16.mars.model.Vector2D;

public class OrbitView extends Sprite {
    private var _ss:SpaceSystem;
    private var _o:Orbit;

    private var _scale:Number;
    private var _color:uint;

    private var _alpha:Number;
    private var view:Shape = new Shape();

    public function OrbitView(ss: SpaceSystem, o:Orbit, scale:Number, color:uint, alpha:Number) {
        _ss = ss;
        _o = o;
        _scale = scale;
        _color = color;
        _alpha = alpha;

        view = new Shape();
        addChild(view);

        redraw();
    }

    private function redraw():void {
//        var m:Matrix = new Matrix();
//        m.translate(-_o.c * _scale, 0);
//        m.rotate(-_o.theta0);
//        m.scale(_scale, _scale);
//        view.transform.matrix = m;

        view.graphics.lineStyle(1, _color, _alpha, false, LineScaleMode.NONE);
//        view.graphics.drawEllipse(-_o.a * _scale, -_o.b * _scale, 2 * _o.a * _scale, 2 * _o.b * _scale);

        var T:Number = 2 * Math.PI * Math.sqrt(_o.a * _o.a * _o.a / Consts.MU); //https://en.wikipedia.org/wiki/Orbital_period
        var dt:Number = Consts.dt / 2;
        var n:int = Math.floor(T / dt);

        var start2D:Vector2D = _o.position(0);
        var startPoint:Point = _ss.position2point(start2D);

        view.graphics.moveTo(startPoint.x, startPoint.y);
        for (var timeInd:int = 1; timeInd <= n; timeInd++) {
            var v:Vector2D = _o.position(timeInd * dt);
            var p:Point = _ss.position2point(v);
            view.graphics.lineTo(p.x, p.y);
        }
        view.graphics.lineTo(startPoint.x, startPoint.y);
    }

    public function get o():Orbit {
        return _o;
    }

    public function set o(value:Orbit):void {
        _o = o;
        redraw();
    }
}
}
