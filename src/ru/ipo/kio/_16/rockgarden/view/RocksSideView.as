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

        trace('here');

        var anglesCircle:SegmentsList = _g.visible_circles_for_point(_location);
        var neg_point:Number;
        switch (_side) {
            // 0  pi/2 pi
            case Garden.SIDE_BOTTOM:
                anglesCircle.modify(function (x:Number):Number {
                    return Math.PI - x;
                }, true);
                neg_point = 3 * Math.PI / 2;
                break;    // pi pi/2 0
            case Garden.SIDE_LEFT:
                anglesCircle.modify(function (x:Number):Number {
                    return Math.PI / 2 - x;
                }, true);
                neg_point = Math.PI;
                break;      // pi/2 0 -pi/2
            case Garden.SIDE_TOP:
                anglesCircle.modify(function (x:Number):Number {
                    return -x;
                }, true);
                neg_point = Math.PI / 2;
                break;       // 0  3pi/2 pi
            case Garden.SIDE_RIGHT:
                anglesCircle.modify(function (x:Number):Number {
                    return 3 * Math.PI / 2 - x;
                }, true);
                neg_point = 0;
                break;     // 3pi/2 pi pi/2
        }

        graphics.clear();
        for each (var s:Segment in anglesCircle.segments)
            if (!s.pointInside(neg_point))
                if (s.value >= 0)
                    draw_rect(s.value, _width * s.start / anglesCircle.maxValue, _width * s.end / anglesCircle.maxValue);
    }

    private function draw_rect(value:int, start:Number, end:Number):void {
        RockPalette.instance.beginFill(graphics, value);
        graphics.drawRect(start, 0, end - start, _height);
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
