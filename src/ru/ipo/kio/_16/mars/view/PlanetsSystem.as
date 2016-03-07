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
    public static const SCALE:Number = VISIBLE_RADIUS / Consts.MARS_R;

    private var _timeInd:Number;

    private var sun:BodyView;

    private var earthOV:OrbitView;
    private var marsOV:OrbitView;
    private var _speedView:VectorView;

    private var _workspace:PlanetsWorkspace;

    private var _scaledLayer:Sprite = new Sprite();

    private var _planets:Vector.<Vector2D> = new <Vector2D>[];
    private var _orbits:Vector.<Orbit>;
    private var _orbitViews:Vector.<OrbitView>;
    private var _bodies:Vector.<BodyView>;

    public function PlanetsSystem(workspace:PlanetsWorkspace, speedView:VectorView, planets:Vector.<Vector2D>) {
        _workspace = workspace;
        _speedView = speedView;
        _planets = planets;

        sun = new BodyView(this, BodyView.SUN_BMP);

        _orbits = new Vector.<Orbit>(_planets.length, true);
        _orbitViews = new Vector.<OrbitView>(_planets.length, true);
        _bodies = new Vector.<BodyView>(_planets.length, true);

        initOrbits();

        earthOrbit = Orbit.solveInitial(Consts.EARTH_R, 0, 0, Consts.EARTH_Vt, 0);

        _timeInd = 0;
        updateTime();

        updateTime();

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

    private function initOrbits():void {
        var i:int = 0;
        for each (var v2d:Vector2D in _planets) {
            var orbitSpeed:Number = Math.sqrt(Consts.MU / v2d.r);
            var speed:Vector2D = Vector2D.createPolar(orbitSpeed, v2d.theta - Math.PI / 2);
            var orbit:Orbit = Orbit.solveInitial(v2d.x, v2d.y, speed.x, speed.y, 0);
            var orbitView:OrbitView = new OrbitView(this, orbit, SCALE, 0x7469ff, 1);
            var body:BodyView = new BodyView(this, '');

            _orbits[i] = orbit;
            _orbitViews[i] = orbitView;
            _bodies[i] = body;

            _scaledLayer.addChild(orbitView);
            _scaledLayer.addChild(body);

            i++;
        }
    }

    private function updateTime():void {
        for (var i:int = 0; i < _bodies.length; i++)
            _bodies[i].moveTo(_orbits[i].position(_timeInd * Consts.dt));

        updateScale();
    }

    private function updateScale():void {
        var m:Matrix = new Matrix();
        _scaledLayer.transform.matrix = m;

        for each (var bv:BodyView in _bodies)
            bv.updateTransformation();
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
}
}
