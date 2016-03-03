package ru.ipo.kio._16.mars.view {
import flash.display.Sprite;
import flash.geom.Point;

import ru.ipo.kio._16.mars.model.Consts;
import ru.ipo.kio._16.mars.model.Orbit;

import ru.ipo.kio._16.mars.model.ShipHistory;
import ru.ipo.kio._16.mars.model.ShipAction;
import ru.ipo.kio._16.mars.model.Vector2D;

public class ShipHistoryView extends Sprite {
    private var ss:SolarSystem;
    private var history:ShipHistory;

    private var _actionsViews:Vector.<ShipActionView> = new <ShipActionView>[];

    private var _currentShipAction:ShipAction = null;

    private var _time:int = 0;

    public function ShipHistoryView(ss:SolarSystem, history:ShipHistory) {
        this.ss = ss;
        this.history = history;

        redraw();
    }

    public function redraw():void {
        //first clear all
        graphics.clear();
        for each (var av:ShipActionView in _actionsViews) {
            removeChild(av);
            av.destroy();
        }
        _actionsViews.splice(0, _actionsViews.length);

        //draw trace
        graphics.lineStyle(4, 0xFFFFFF, 0.5);
        var first:Boolean = true;
        var time_index:int = 0;
        for each (var v:Vector2D in history.positions) {

            var point:Point = ss.position2point(v);

            if (_time == time_index) {
                graphics.lineStyle(4, 0xFFFFFF, 0.2);
                graphics.moveTo(point.x, point.y);
//                first = true;
            }

            if (first) {
                graphics.moveTo(point.x, point.y);
                first = false;
            } else
                graphics.lineTo(point.x, point.y);

            time_index++;
        }

        //draw actions
        for each (var he:ShipAction in history.actions) {
            av = new ShipActionView(ss, he);
            _actionsViews.push(av);
            if (he == _currentShipAction)
                av.selected = true;
            addChild(av);
        }

        //draw start and finish
        var start:Point = ss.position2point(history.positions[0]);
        var finish:Point = ss.position2point(history.positions[Consts.MAX_TIME]);

        graphics.lineStyle(0.5, 0x009900);
        graphics.drawCircle(start.x, start.y, 2);
        graphics.lineStyle(0.5, 0x009988);
        graphics.drawCircle(finish.x, finish.y, 2);

//        trace(ss.earthOrbit.position());

        //add orbits
//        for each (var o:Orbit in history.orbits)
//            addChild(new OrbitView(o, SolarSystem.SCALE, 0x0, 1));
    }

    public function get actionsViews():Vector.<ShipActionView> {
        return _actionsViews;
    }

    public function get currentShipAction():ShipAction {
        return _currentShipAction;
    }

    public function set currentShipAction(value:ShipAction):void {
        if (value == _currentShipAction)
            return;
        _currentShipAction = value;

        for each (var av:ShipActionView in _actionsViews)
            av.selected = av.action == _currentShipAction;
    }

    public function set time(value:int):void {
        _time = value;

        redraw();
    }
}
}
