/**
 * Created by ilya on 19.02.15.
 */
package ru.ipo.kio._15.spider {
import flash.geom.Point;

public class SpiderLocation {

    private var _floor_point_ind:int;
    private var _floor_point_position:Point;
    private var _angle:Number;
    private var _touchesEnd:Boolean;

    public function SpiderLocation(floor_point_ind:int, floor_point_position:Point, angle:Number, touchesEnd:Boolean) {
        this._floor_point_ind = floor_point_ind;
        this._floor_point_position = floor_point_position;
        this._angle = angle;
        this._touchesEnd = touchesEnd;
    }

    public function get floor_point_ind():int {
        return _floor_point_ind;
    }

    public function get floor_point_position():Point {
        return _floor_point_position;
    }

    public function get angle():Number {
        return _angle;
    }

    public function get touchesEnd():Boolean {
        return _touchesEnd;
    }
}
}
