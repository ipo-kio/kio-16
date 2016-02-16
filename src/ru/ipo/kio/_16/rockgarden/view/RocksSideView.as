package ru.ipo.kio._16.rockgarden.view {
import ru.ipo.kio._16.rockgarden.model.*;

import flash.display.Shape;
import flash.geom.Point;

public class RocksSideView extends Shape {

    private var _location:Point = null;
    private var _g:Garden;
    private var _side:int; //Garden.SIDE_*

    private var _width:Number;
    private var _height:Number;

    public function RocksSideView(g:Garden, width:Number, height:Number) {
        _g = g;
        _width = width;
        _height = height;

        redraw();
    }

    public function redraw():void {
        if (_location == null)
            return;

        var anglesCircle:SegmentsList = _g.visible_circles_for_point(_location);
        switch (_side) {
            // 0  pi/2 pi
            case Garden.SIDE_BOTTOM:
                anglesCircle.modify(function (x:Number):Number {
                    return Math.PI - x;
                }, true);
                break;    // pi pi/2 0
            case Garden.SIDE_LEFT:
                anglesCircle.modify(function (x:Number):Number {
                    return Math.PI / 2 - x;
                }, true);
                break;      // pi/2 0 -pi/2
            case Garden.SIDE_TOP:
                anglesCircle.modify(function (x:Number):Number {
                    return -x;
                }, true);
                break;       // 0  3pi/2 pi
            case Garden.SIDE_RIGHT:
                anglesCircle.modify(function (x:Number):Number {
                    return 3 * Math.PI / 2 - x;
                }, true);

                break;     // 3pi/2 pi pi/2
        }

        var neg_point:Number = 3 * Math.PI / 2;

        graphics.clear();
        var maxDist:Number = Math.sqrt(_g.W * _g.W + _g.H * _g.H);
        for each (var s:Segment in anglesCircle.segments)
            if (s.value >= 0 && !s.pointInside(neg_point)) {
                var c:Circle = _g.getCircleByIndex(s.value);
                var dx:Number = c.x - _location.x;
                var dy:Number = c.y - _location.y;
                var d:Number = Math.sqrt(dx * dx + dy * dy) - c.r * 0.95;

                var circle_height:Number = _height * (maxDist - d) / maxDist;
                draw_rect(s.value, _width * s.start / Math.PI, _width * s.end / Math.PI, circle_height);
            }

        //draw border
        graphics.lineStyle(1, 0xFF0000);
        graphics.moveTo(0, _height);
        graphics.lineTo(_width, _height);
    }

    private function draw_rect(value:int, start:Number, end:Number, height:Number):void {
        graphics.lineStyle(1, 0xFF0000);
        RockPalette.beginFill(graphics, value);
        graphics.drawRect(start, _height - height, end - start, height);
        graphics.endFill();
    }

    public function get location():Point {
        return _location;
    }

    public function set location(value:Point):void {
        _location = value;
        if (_location != null)
            _side = _g.location2side(_g.point2location(_location));
        redraw();
    }
}
}
