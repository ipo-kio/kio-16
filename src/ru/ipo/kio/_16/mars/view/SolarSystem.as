package ru.ipo.kio._16.mars.view {
import flash.display.Sprite;
import flash.geom.Point;

import ru.ipo.kio._16.mars.model.Consts;
import ru.ipo.kio._16.mars.model.Orbit;
import ru.ipo.kio._16.mars.model.ShipHistory;
import ru.ipo.kio._16.mars.model.Vector2D;

public class SolarSystem extends Sprite {

    public static const SCALE:Number = 280 / Consts.MARS_R;

    private var earthOrbit:Orbit;
    private var marsOrbit:Orbit;

    private var ship:Ship;
    private var historyLayer:Sprite;
    private var historyView:ShipHistoryView = null;

    private var _history:ShipHistory;

//    private var earthPosition:Vector2D;
//    private var marsPosition:Vector2D;

    private var earthOV:OrbitView;
    private var marsOV:OrbitView;

    public function SolarSystem() {
        earthOrbit = Orbit.solveInitial(Consts.EARTH_R, 0, 0, Consts.EARTH_Vt);
        marsOrbit = Orbit.solveInitial(Consts.MARS_R, 0, 0, Consts.MARS_Vt);

//        earthPosition = new Vector2D(Consts.EARTH_R, 0);
//        marsPosition = new Vector2D(Consts.MARS_R, 0);

        earthOV = new OrbitView(earthOrbit, SCALE, 0x000088, 1);
        marsOV = new OrbitView(marsOrbit, SCALE, 0x880000, 1);

        addChild(earthOV);
        addChild(marsOV);

        historyLayer = new Sprite();
        addChild(historyLayer);

        ship = new Ship(this);
        addChild(ship);
    }

    public function moveShipTo(p:Vector2D):void {
        ship.moveTo(p);
    }

    public function position2point(p:Vector2D):Point {
        return new Point(p.r * Math.cos(p.theta) * SCALE, -p.r * Math.sin(p.theta) * SCALE);
    }

    public function set history(history:ShipHistory):void {
        _history = history;

        if (historyView != null)
            historyLayer.removeChild(historyView);

        historyView = new ShipHistoryView(this, _history);
        historyLayer.addChild(historyView);
    }

    public function get history():ShipHistory {
        return _history;
    }
}
}
