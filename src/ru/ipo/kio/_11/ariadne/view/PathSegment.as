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
import ru.ipo.kio._11.ariadne.model.IntegerPoint;
import ru.ipo.kio._11.ariadne.model.Segment;
import ru.ipo.kio._11.ariadne.model.Terra;

public class PathSegment extends Sprite {

    private var _ind:int;
    private var _land:Land;

    private var _hitArea:Sprite;

    public function PathSegment(land:Land, ind:int) {
        _ind = ind;
        _land = land;

        _hitArea = new Sprite;
        _hitArea.mouseEnabled = false;
        _hitArea.visible = false;
        addChild(_hitArea);
        hitArea = _hitArea;

        addEventListener(MouseEvent.ROLL_OVER, mouseRollOver);
        addEventListener(MouseEvent.ROLL_OUT, mouseRollOut);
        addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);

        redraw();
    }

    private function mouseDown(event:Event):void {
        AriadneData.instance.selected_segment_index = _ind;
    }

    private function mouseRollOut(event:Event):void {
        _hitArea.visible = false;
        _land.removeMouseOverSegment(this);
    }

    private function mouseRollOver(event:Event):void {
        _hitArea.visible = true;
        _land.addMouseOverSegment(this);
    }

    public function get selected():Boolean {
        return _ind == AriadneData.instance.selected_segment_index;
    }

    public function redraw():void {
        graphics.clear();
        graphics.lineStyle(selected ? 2 : 1, selected ? 0xffe91f : 0xFFFFFF);
        var p_start:Point = _land.logicalToScreen(AriadneData.instance.getPoint(_ind));
        graphics.moveTo(p_start.x, p_start.y);
        var p_finish:Point = _land.logicalToScreen(AriadneData.instance.getPoint(_ind + 1));
        graphics.lineTo(p_finish.x, p_finish.y);

        _hitArea.graphics.clear();
        _hitArea.graphics.lineStyle(8, 0xffe91f, 0.5);
        _hitArea.graphics.moveTo(p_start.x, p_start.y);
        _hitArea.graphics.lineTo(p_finish.x, p_finish.y);

        if (_land.show_ticks) {
            var ps:IntegerPoint = point_start;
            var pf:IntegerPoint = point_finish;

            graphics.lineStyle(2, 0xFFFFFF);

            var ang:Number = angle - Math.PI / 4;
            var a_c:Number = Math.cos(ang);
            var a_s:Number = Math.sin(ang);
            var a_c2:Number = - Math.sin(ang);
            var a_s2:Number = Math.cos(ang);
            var r:int = 4;

            var terra:Terra = AriadneData.instance.terra;
            var split:Array = Segment.split(terra, ps.x, ps.y, pf.x, pf.y);
            var seg_count:int = split.length;
            for (var i:int = 0; i < seg_count - 1; i++) {
                var s:Segment = split[i];
                var p:Point = _land.logicalFloatToScreen(s.finish);

                graphics.moveTo(p.x - r * a_c, p.y - r * a_s);
                graphics.lineTo(p.x + r * a_c, p.y + r * a_s);

                graphics.moveTo(p.x - r * a_c2, p.y - r * a_s2);
                graphics.lineTo(p.x + r * a_c2, p.y + r * a_s2);
            }
        }
    }

    private function get point_start():IntegerPoint {
        return AriadneData.instance.getPoint(_ind);
    }

    private function get point_finish():IntegerPoint {
        return AriadneData.instance.getPoint(_ind + 1);
    }

    public function get time():Number {
        var ps:IntegerPoint = point_start;
        var pf:IntegerPoint = point_finish;

        var terra:Terra = AriadneData.instance.terra;
        var split:Array = Segment.split(terra, ps.x, ps.y, pf.x, pf.y);
        var time:Number = 0;
        for each (var s:Segment in split)
            time += s.length / terra.velocity(s.type);
        return time * 100;
    }

    public function get length():Number {
        var ps:IntegerPoint = point_start;
        var pf:IntegerPoint = point_finish;
        var dx:int = pf.x - ps.x;
        var dy:int = pf.y - ps.y;
        return Math.sqrt(dx * dx + dy * dy);
    }

    public function get angle():Number {
        var ps:IntegerPoint = point_start;
        var pf:IntegerPoint = point_finish;
        return Math.atan2(pf.y - ps.y, pf.x - ps.x);
    }
}
}
