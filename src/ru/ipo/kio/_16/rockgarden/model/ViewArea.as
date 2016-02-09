package ru.ipo.kio._16.rockgarden.model {
import flash.geom.Point;

public class ViewArea {

    private var _location:Point;
    private var _g:Garden;
    private var _side:int; //Garden.SIDE_*

    private var _segments:Vector.<Number>; //just points from 0 to PI. n + 1 point
    private var _circle_index:Vector.<int>; //indexes, n indexes

    public function ViewArea(location:Point, g:Garden) {
        _location = location;
        _g = g;
        _side = _g.location2side(_g.point2location(_location));

        evalCircles();
    }

    public function evalCircles():void {
        var anglesCircle:SegmentsList = _g.visible_circles_for_point(_location);
        switch (_side) {
                                                                                                                     // 0  pi/2 pi
            case Garden.SIDE_BOTTOM: anglesCircle.modify(function(x:Number):Number {return Math.PI - x;}); break;    // pi pi/2 0
            case Garden.SIDE_LEFT: anglesCircle.modify(function(x:Number):Number {return Math.PI / 2 - x;}); break;      // pi/2 0 -pi/2
            case Garden.SIDE_TOP: anglesCircle.modify(function(x:Number):Number {return -x;}); break;       // 0  3pi/2 pi
            case Garden.SIDE_RIGHT: anglesCircle.modify(function(x:Number):Number {return 3 * Math.PI / 2 - x;}); break;     // 3pi/2 pi pi/2
        }
    }

    public function get n():int {
        return _circle_index.length;
    }
}
}
