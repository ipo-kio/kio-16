/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 27.02.11
 * Time: 11:21
 */
package ru.ipo.kio._11.ariadne.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.ipo.kio._11.ariadne.model.AriadneData;

public class PathPoint extends Sprite {
    private var _ind:int;
    private var _land:Land;

    private static const RADIUS:int = 4;

    public function PathPoint(land:Land, ind:int) {
        _ind = ind;
        _land = land;

        addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);

        redraw();
    }

    private function mouseDownHandler(event:Event):void {
        AriadneData.instance.selected_point_index = _ind;
    }

    public function get selected():Boolean {
        return _ind == AriadneData.instance.selected_point_index;
    }

    public function get selectable():Boolean {
        return _ind > 0 && _ind + 1 < AriadneData.instance.pointsCount;
    }

    public function redraw():void {
        var p:Point = _land.logicalToScreen(AriadneData.instance.getPoint(_ind));

        graphics.clear();
        graphics.beginFill(selectable ? (selected ? 0x24e02f : 0xffe91f) : 0xffffff);
        graphics.drawCircle(p.x, p.y, RADIUS);
        graphics.endFill();
    }
}
}
