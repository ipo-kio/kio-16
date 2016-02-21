package ru.ipo.kio._16.mars.view {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.ipo.kio._16.mars.model.ShipAction;
import ru.ipo.kio._16.mars.model.Vector2D;

public class ShipActionView extends Sprite {
    private static const ACTION_COLOR:uint = 0xCC0000;
    private static const ACTION_COLOR_S:uint = 0x00CC00;
    private static const SIZE:int = 3;

    private var _ss:SolarSystem;
    private var _a:ShipAction;

    private var _selected:Boolean = false;
    private var _over:Boolean = false;

    public function ShipActionView(ss:SolarSystem, a:ShipAction) {
        _ss = ss;
        _a = a;

        var hit_area:Sprite = new Sprite();
        hit_area.mouseEnabled = false;
        hit_area.visible = false;
        this.hitArea = hit_area;
        addChild(hit_area);

        addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
        addEventListener(MouseEvent.CLICK, clickHandler);

        redraw();
    }

    public function destroy():void {
        removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
        removeEventListener(MouseEvent.CLICK, clickHandler);
    }

    public function redraw():void {
        graphics.clear();

        var position:Vector2D = _ss.history.time2position(_a.time);
        var point:Point = _ss.position2point(position);

        graphics.lineStyle(2, _selected || _over ? ACTION_COLOR_S : ACTION_COLOR);
        graphics.moveTo(point.x - SIZE, point.y - SIZE);
        graphics.lineTo(point.x + SIZE, point.y + SIZE);
        graphics.moveTo(point.x + SIZE, point.y - SIZE);
        graphics.lineTo(point.x - SIZE, point.y + SIZE);

        hitArea.graphics.clear();
        hitArea.graphics.beginFill(0xFF0000);
        hitArea.graphics.drawCircle(point.x, point.y, 5);
        hitArea.graphics.endFill();
    }

    private function rollOverHandler(event:MouseEvent):void {
        _over = true;
        redraw();
    }

    private function rollOutHandler(event:MouseEvent):void {
        _over = false;
        redraw();
    }

    public function get selected():Boolean {
        return _selected;
    }

    public function set selected(value:Boolean):void {
        if (_selected == value)
            return;
        _selected = value;

        redraw();
    }

    private function clickHandler(event:MouseEvent):void {
        _ss.currentShipAction = _a;
    }


    public function get action():ShipAction {
        return _a;
    }
}
}
