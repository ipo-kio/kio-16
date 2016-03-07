package ru.ipo.kio._16.mars.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;

import ru.ipo.kio._16.mars.MarsWorkspace;
import ru.ipo.kio._16.mars.model.Consts;
import ru.ipo.kio._16.mars.model.Orbit;
import ru.ipo.kio._16.mars.model.ShipAction;
import ru.ipo.kio._16.mars.model.ShipHistory;
import ru.ipo.kio._16.mars.model.Vector2D;

public class SolarSystem extends Sprite implements SpaceSystem {

    public static const VISIBLE_RADIUS:Number = 280;
    public static const SCALE:Number = VISIBLE_RADIUS / Consts.MARS_R;

    private var earthOrbit:Orbit;
    public static const _marsOrbit:Orbit = Orbit.solveInitial(Consts.MARS_R, 0, 0, Consts.MARS_Vt, 0);

//    private var historyLayer:Sprite;
    private var _historyView:ShipHistoryView = null;

    private var _history:ShipHistory;

    private var _timeInd:Number;

    private var ship:BodyView;
    private var earth:BodyView;
    private var mars:BodyView;
    private var sun:BodyView;

    private var _currentShipAction:ShipAction = null;

//    private var earthPosition:Vector2D;
//    private var marsPosition:Vector2D;

    private var earthOV:OrbitView;
    private var marsOV:OrbitView;
    private var _speedView:VectorView;

    private var _workspace:MarsWorkspace;

    private var _scaledLayer:Sprite = new Sprite();

    public function SolarSystem(workspace:MarsWorkspace, speedView:VectorView, history:ShipHistory) {
        _workspace = workspace;
        _speedView = speedView;
        earthOrbit = Orbit.solveInitial(Consts.EARTH_R, 0, 0, Consts.EARTH_Vt, 0);
//        _marsOrbit = Orbit.solveInitial(Consts.MARS_R, 0, 0, Consts.MARS_Vt, 0);
        _history = history;

        _historyView = new ShipHistoryView(this, _history);
        _scaledLayer.addChild(_historyView);

//        earthPosition = new Vector2D(Consts.EARTH_R, 0);
//        marsPosition = new Vector2D(Consts.MARS_R, 0);

        earthOV = new OrbitView(this, earthOrbit, SCALE, 0x7469ff, 1);
        marsOV = new OrbitView(this, _marsOrbit, SCALE, 0xFF4eaf, 1);

        _scaledLayer.addChild(earthOV);
        _scaledLayer.addChild(marsOV);

        ship = new BodyView(this, BodyView.SHIP_BMP);
        earth = new BodyView(this, BodyView.EARTH_BMP);
        mars = new BodyView(this, BodyView.MARS_BMP);
        sun = new BodyView(this, BodyView.SUN_BMP);
        _scaledLayer.addChild(earth);
        _scaledLayer.addChild(mars);
        _scaledLayer.addChild(ship);
        _scaledLayer.addChild(sun);

        _timeInd = 0;
        updateTime();

        _speedView.addEventListener(VectorView.VALUE_CHANGED, speedView_vector_view_value_changedHandler);

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

    private function updateTime():void {
        historyView.time = _timeInd;
        earth.moveTo(earthOrbit.position(_timeInd * Consts.dt));
        mars.moveTo(_marsOrbit.position(_timeInd * Consts.dt));
        if (_history != null)
            ship.moveTo(_history.time2position(_timeInd));

        updateScale();
    }

    private function updateScale():void {
        var dx:Number = ship.x - mars.x;
        var dy:Number = ship.y - mars.y;
        var d:Number = Math.sqrt(dx * dx + dy * dy);

        var d0:Number = 50;
        var d1:Number = 5;
        var finalVisibleD:Number = VISIBLE_RADIUS / 2;
        // --- d0 --- 1
//            d0      VISIBLE_RADIUS / 2
        //d = d0, k = 1
        //d = 1, k = VISIBLE_RADIUS / 2
        if (d >= d0) {
            var k:Number = 1;
            var x0:Number = 0;
            var y0:Number = 0;
        } else if (d >= d1) {
            k = ((d - d0) * (finalVisibleD - d0) / (d1 - d0) + d0) / d;
            var t:Number = 1 - Math.pow(1 - (d - d0) / (d1 - d0), 3);
            x0 = mars.x * t;
            y0 = mars.y * t;
        } else {
            k = finalVisibleD / d1;
            x0 = mars.x;
            y0 = mars.y;
        }

        var m:Matrix = new Matrix();
        m.translate(-x0, -y0);
        m.scale(k, k);
        _scaledLayer.transform.matrix = m;

        ship.updateTransformation();
        earth.updateTransformation();
        mars.updateTransformation();
        sun.updateTransformation();
    }

    public function moveShipTo(p:Vector2D):void {
        ship.moveTo(p);
    }

    public function position2point(p:Vector2D):Point {
        return new Point(p.r * Math.cos(p.theta) * SCALE, -p.r * Math.sin(p.theta) * SCALE);
    }

    public function get history():ShipHistory {
        return _history;
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

    public function set currentShipAction(value:ShipAction):void {
        if (value == _currentShipAction)
            return;

        _currentShipAction = value;

        if (_currentShipAction == null)
            _speedView.visible = false;
        else {
            _speedView.visible = true;
            _speedView.value = _currentShipAction.dV;
        }

        _historyView.currentShipAction = value;

        _workspace.update_add_remove_buttons_state();
    }

    private function speedView_vector_view_value_changedHandler(event:Event):void {
        if (_currentShipAction != null) {
            _currentShipAction.dV = _speedView.value;
//            history.evaluatePositions();
//            _historyView.redraw();
            _workspace.historyUpdated();
            updateTime();
        }
    }

    public function get historyView():ShipHistoryView {
        return _historyView;
    }

    public function get currentShipAction():ShipAction {
        return _currentShipAction;
    }

    public static function get marsOrbit():Orbit {
        return _marsOrbit;
    }
}
}
