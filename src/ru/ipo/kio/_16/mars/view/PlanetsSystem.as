package ru.ipo.kio._16.mars.view {
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;

import ru.ipo.kio._16.mars.PlanetsWorkspace;
import ru.ipo.kio._16.mars.model.Consts;
import ru.ipo.kio._16.mars.model.Orbit;
import ru.ipo.kio._16.mars.model.Vector2D;

public class PlanetsSystem extends Sprite implements SpaceSystem {

    public static const VISIBLE_RADIUS:Number = 280;
    public static const SCALE:Number = VISIBLE_RADIUS / (Consts.AU * Consts.planets_orbits[3]);
    public static var ONE_SCALE_FACTOR:Number;
    public static const MAX_SCALE_LEVEL:int = 8;

    private var _timeInd:Number;

    private var sun:BodyView;

    private var _workspace:PlanetsWorkspace;

    private var _scaledLayer:Sprite = new Sprite();

    private var _all_orbits:Vector.<OrbitView>;
    private var _orbits:Vector.<Orbit>;
    private var _orbitViews:Vector.<OrbitView>;
    private var _bodies:Vector.<BodyView>;

    private var _scale_level:int = 0;

    public function PlanetsSystem(workspace:PlanetsWorkspace) {
        _workspace = workspace;

        init_all_orbits();

        ONE_SCALE_FACTOR = Math.pow(Consts.planets_orbits[3] / Consts.planets_orbits[Consts.planets_orbits.length - 1] / 1.1, 1 / MAX_SCALE_LEVEL);

        sun = new BodyView(this, BodyView.SUN_BMP);
        _scaledLayer.addChild(sun);

        _orbits = new Vector.<Orbit>(Consts.planets_names.length, true);
        _orbitViews = new Vector.<OrbitView>(Consts.planets_names.length, true);
        _bodies = new Vector.<BodyView>(Consts.planets_names.length, true);

        initOrbits();

        _timeInd = 0;
        updateTime();

        //setup mask
        //setup mask
        var maskSprite:Sprite = new Sprite();
        mask = maskSprite;
        maskSprite.graphics.beginFill(0xFF0000);
        var r:Number = VISIBLE_RADIUS + 4;
        maskSprite.graphics.drawRect(-r, -r, 2 * r, 2 * r);
        maskSprite.graphics.endFill();
        addChild(maskSprite);

        addChild(_scaledLayer);
    }

    private function init_all_orbits():void {
        _all_orbits = new <OrbitView>[];
        for (var i:int = 0; i < Consts.planets_names.length; i++) {
            var r:Number = Consts.planets_orbits[i];
            var r1:Number = i == 0 ? 0 : Consts.planets_orbits[i - 1];
            var cnt:Number = Consts.orbits_between[i];
            for (var j:int = 1; j <= cnt; j++) {
                var o:Orbit = Orbit.createOrbitByInitial(Vector2D.createPolar(Consts.AU * ((r - r1) / cnt * j + r1), 0));
                var ov:OrbitView = new OrbitView(this, o, SCALE, 0xFFFFFF, 0.2, true);
                _all_orbits.push(ov);
                _scaledLayer.addChild(ov);
            }
        }
    }

    private function initOrbits():void {
        for (var i:int = 0; i < Consts.planets_names.length; i++) {
            var orbInd:int = i + 5;
            var orbPhi:int = 2 * i;
            var v2d:Vector2D = Vector2D.createPolar(_all_orbits[orbInd].o.a, orbPhi * Math.PI / 180);
            var orbit:Orbit = Orbit.createOrbitByInitial(v2d);
            orbit.ind = orbInd;
            orbit.phi = orbPhi;
            var orbitView:OrbitView = new OrbitView(this, orbit, SCALE, 0x7469ff, 1);
            var body:BodyView = new BodyView(this, Consts.planet_view[i]);
            body.enableMouse();

            _orbits[i] = orbit;
            _orbitViews[i] = orbitView;
            _bodies[i] = body;

            _scaledLayer.addChild(orbitView);
            _scaledLayer.addChild(body);
        }
    }

    private function updateTime():void {
        for (var i:int = 0; i < _bodies.length; i++)
            _bodies[i].moveTo(_orbits[i].position(_timeInd * Consts.dt));
    }

    public function get scale_level():int {
        return _scale_level;
    }

    public function set scale_level(value:int):void {
        if (_scale_level == value)
            return;
        if (value < 0 || value > MAX_SCALE_LEVEL)
            return;
        _scale_level = value;

        updateScaleLevel();
    }

    private function updateScaleLevel():void {
        var m:Matrix = new Matrix();
        var s:Number = Math.pow(ONE_SCALE_FACTOR, _scale_level);
        m.scale(s, s);
        _scaledLayer.transform.matrix = m;

        for each (var bv:BodyView in _bodies) {
            var size:Number = lin_interpolate(scale_level, 0, 1, MAX_SCALE_LEVEL, 1 / 10);
            var d:Number = Math.sqrt(bv.x * bv.x + bv.y * bv.y) * s;
            if (d >= 20)
                size = 1;
            bv.updateTransformation(size); //scale level = 0 => 1, scale level = SCALE_COUNT => 1/10
        }
    }

    private static function lin_interpolate(x:int, x0:Number, fx0:Number, x1:Number, fx1:Number):Number {
        return (x - x0) / (x1 - x0) * (fx1 - fx0) + fx0;
    }

    public function position2point(p:Vector2D):Point {
        return new Point(p.r * Math.cos(p.theta) * SCALE, -p.r * Math.sin(p.theta) * SCALE);
    }

    public function get timeInd():Number {
        return _timeInd;
    }

    public function set time(value:Number):void {
        if (_timeInd == value)
            return;
        _timeInd = value;

        updateTime();
    }

    public function get all_orbits():Vector.<OrbitView> {
        return _all_orbits;
    }

    public function setOrbitForBody(body:BodyView, orbit:Orbit):void {
        for (var i:int = 0; i < _bodies.length; i++) {
            if (_bodies[i] == body) {
                _orbits[i] = orbit;
                _orbitViews[i].o = orbit;
                break;
            }
        }

        updateScaleLevel();
        updateTime();
        _workspace.updatePlanetsInfo();
    }

    public function get orbits():Vector.<Orbit> {
        return _orbits;
    }

    public function get bodies():Vector.<BodyView> {
        return _bodies;
    }

    public function viewsUpdated():void {
        _workspace.viewsUpdated();
    }
}
}
