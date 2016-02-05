package ru.ipo.kio._16.mars.view {
import flash.display.Sprite;
import flash.geom.Point;

import ru.ipo.kio._16.mars.model.Consts;

import ru.ipo.kio._16.mars.model.ShipHistory;
import ru.ipo.kio._16.mars.model.ShipHistoryEntry;
import ru.ipo.kio._16.mars.model.Vector2D;

public class ShipHistoryView extends Sprite {
    private var ss:SolarSystem;
    private var history:ShipHistory;

    public function ShipHistoryView(ss:SolarSystem, history:ShipHistory) {
        this.ss = ss;
        this.history = history;

        redraw();
    }

    private function redraw():void {

        graphics.lineStyle(2, 0x999999);

        var first:Boolean = true;
        for each (var v:Vector2D in history.positions) {
            var point:Point = ss.position2point(v);
            if (first) {
                graphics.moveTo(point.x, point.y);
                first = false;
            } else
                graphics.lineTo(point.x, point.y);
        }

        graphics.lineStyle(0.5, 0x990000);
        for each (var he:ShipHistoryEntry in history.actions) {
            var pos:Point = ss.position2point(history.positions[he.time]);
            graphics.drawCircle(pos.x, pos.y, 3);
        }

        var start:Point = ss.position2point(history.positions[0]);
        var finish:Point = ss.position2point(history.positions[Consts.MAX_TIME]);

        graphics.lineStyle(0.5, 0x009900);
        graphics.drawCircle(start.x, start.y, 2);
        graphics.lineStyle(0.5, 0x009988);
        graphics.drawCircle(finish.x, finish.y, 2);

//        trace(ss.earthOrbit.position());
    }
}
}
