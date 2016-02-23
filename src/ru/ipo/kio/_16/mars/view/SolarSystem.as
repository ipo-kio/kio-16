package ru.ipo.kio._16.mars.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;

import ru.ipo.kio._16.mars.MarsWorkspace;

import ru.ipo.kio._16.mars.model.Consts;
import ru.ipo.kio._16.mars.model.Orbit;
import ru.ipo.kio._16.mars.model.ShipAction;
import ru.ipo.kio._16.mars.model.ShipHistory;
import ru.ipo.kio._16.mars.model.Vector2D;

public class SolarSystem extends Sprite {

    public static const VISIBLE_RADIUS:Number = 280;
    public static const SCALE:Number = VISIBLE_RADIUS / Consts.MARS_R;

    private var earthOrbit:Orbit;
    private var marsOrbit:Orbit;

    private var historyLayer:Sprite;
    private var _historyView:ShipHistoryView = null;

    private var _history:ShipHistory;

    private var _timeInd:Number;

    private var ship:BodyView;
    private var earth:BodyView;
    private var mars:BodyView;

    private var _currentShipAction:ShipAction = null;

//    private var earthPosition:Vector2D;
//    private var marsPosition:Vector2D;

    private var earthOV:OrbitView;
    private var marsOV:OrbitView;
    private var _speedView:VectorView;

    private var _workspace:MarsWorkspace;

    public function SolarSystem(workspace:MarsWorkspace, speedView:VectorView) {
        _workspace = workspace;
        _speedView = speedView;
        earthOrbit = Orbit.solveInitial(Consts.EARTH_R, 0, 0, Consts.EARTH_Vt, 0);
        marsOrbit = Orbit.solveInitial(Consts.MARS_R, 0, 0, Consts.MARS_Vt, 0);

//        earthPosition = new Vector2D(Consts.EARTH_R, 0);
//        marsPosition = new Vector2D(Consts.MARS_R, 0);

        earthOV = new OrbitView(earthOrbit, SCALE, 0x000088, 1);
        marsOV = new OrbitView(marsOrbit, SCALE, 0x880000, 1);

        addChild(earthOV);
        addChild(marsOV);

        historyLayer = new Sprite();
        addChild(historyLayer);

        ship = new BodyView(this, "ship");
        earth = new BodyView(this, 0x0000bb);
        mars = new BodyView(this, 0xbb0000);
        addChild(earth);
        addChild(mars);
        addChild(ship);

        _timeInd = 0;
        updateTime();

        _speedView.addEventListener(VectorView.VALUE_CHANGED, speedView_vector_view_value_changedHandler);

        //setup mask
        var maskSprite:Sprite = new Sprite();
        mask = maskSprite;
        maskSprite.graphics.beginFill(0xFF0000);
        var r:Number = VISIBLE_RADIUS + 4;
        maskSprite.graphics.drawRect(-r, -r, 2 * r, 2 * r);
        maskSprite.graphics.endFill();
        addChild(maskSprite);
    }

    private function updateTime():void {
        earth.moveTo(earthOrbit.position(_timeInd * Consts.dt));
        mars.moveTo(marsOrbit.position(_timeInd * Consts.dt));
        if (_history != null)
            ship.moveTo(_history.time2position(_timeInd));
    }

    public function moveShipTo(p:Vector2D):void {
        ship.moveTo(p);
    }

    public function position2point(p:Vector2D):Point {
        return new Point(p.r * Math.cos(p.theta) * SCALE, -p.r * Math.sin(p.theta) * SCALE);
    }

    public function set history(history:ShipHistory):void {
        _history = history;

        if (_historyView != null)
            historyLayer.removeChild(_historyView);

        _historyView = new ShipHistoryView(this, _history);
        historyLayer.addChild(_historyView);

        updateTime();
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
            history.evaluatePositions();
            _historyView.redraw();
            updateTime();
        }
    }

    public function get historyView():ShipHistoryView {
        return _historyView;
    }

    public function get currentShipAction():ShipAction {
        return _currentShipAction;
    }
}
}
