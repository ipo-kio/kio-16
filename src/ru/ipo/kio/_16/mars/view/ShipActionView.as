package ru.ipo.kio._16.mars.view {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.ipo.kio._16.mars.model.ShipAction;
import ru.ipo.kio._16.mars.model.Vector2D;

public class ShipActionView extends Sprite {
    private static const ACTION_COLOR:uint = 0xCC0000;
    private static const SIZE:int = 3;

    private var _ss:SolarSystem;
    private var _a:ShipAction;

    public function ShipActionView(ss:SolarSystem, a:ShipAction) {
        _ss = ss;
        _a = a;

        redraw();

        var hit_area:Sprite = new Sprite();
        hit_area.mouseEnabled = false;
        this.hitArea = hit_area;
        addChild(hit_area);

//        addEventListener(ADD, );
    }

    public function redraw():void {
        graphics.clear();

        var position:Vector2D = _ss.history.time2position(_a.time);
        var point:Point = _ss.position2point(position);

        graphics.lineStyle(2, ACTION_COLOR);
        graphics.moveTo(point.x - SIZE, point.y - SIZE);
        graphics.lineTo(point.x + SIZE, point.y + SIZE);
        graphics.moveTo(point.x + SIZE, point.y - SIZE);
        graphics.lineTo(point.x - SIZE, point.y + SIZE);

        //update hitArea
        hitArea.graphics.clear();
        hitArea.graphics.beginFill(0);
        hitArea.graphics.drawCircle(point.x, point.y, 5);
        hitArea.graphics.endFill();
    }
}
}
