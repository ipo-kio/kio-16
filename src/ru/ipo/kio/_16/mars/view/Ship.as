package ru.ipo.kio._16.mars.view {
import ru.ipo.kio._16.mars.model.*;

import flash.display.Sprite;
import flash.geom.Point;

public class Ship extends Sprite {

    private var _ss:SolarSystem;

    public function Ship(ss:SolarSystem) {
        _ss = ss;
    }

    public function moveTo(p:Vector2D):void {
        var point:Point = _ss.position2point(p);
        x = point.x;
        y = point.y;
    }
}
}
