package ru.ipo.kio._16.mars.model {
public class MarsResult {

    private var _day:int;
    private var _mars_dist:Number;
    private var _mars_speed:Number;
    private var _fuel:Number;

    public function MarsResult(day:int, mars_dist:Number, mars_speed:Number, fuel:Number) {
        _day = day;
        _mars_dist = mars_dist;
        _mars_speed = mars_speed;
        _fuel = fuel;
    }

    public function get mars_dist():Number {
        return _mars_dist;
    }

    public function get mars_speed():Number {
        return _mars_speed;
    }

    public function get fuel():Number {
        return _fuel;
    }

    public function get isClose():Boolean {
        return _mars_dist < Consts.MAX_DIST;
    }

    public function get isSlow():Boolean {
        return _mars_speed < Consts.MAX_SPEED;
    }

    public function get day():int {
        return _day;
    }

    public function get as_object():Object {
        return {
            d: _day,
            md: _mars_dist,
            ms: _mars_speed,
            f: _fuel
        };
    }

    public static function create_from_object(o:Object):MarsResult {
        return new MarsResult(o.d, o.md, o.ms, o.f);
    }

    public function compareTo(mr:MarsResult):int {
        if (isClose && !mr.isClose)
            return 1;
        else if (!isClose && mr.isClose)
            return -1;

        if (!isClose) {
            if (mars_dist < mr.mars_dist)
                return 1;
            else if (mars_dist > mr.mars_dist)
                return -1;
            else
                return 0;
        }

        //now two are close
        if (isSlow && !mr.isSlow)
            return 1;
        else if (!isSlow && mr.isSlow)
            return -1;

        if (!isSlow) {
            if (mars_speed < mr.mars_speed)
                return 1;
            else if (mars_speed > mr.mars_speed)
                return -1;
            else
                return 0;
        }

        if (fuel < mr.fuel)
            return 1;
        else if (fuel > mr.fuel)
            return -1;
        else
            return 0;
    }

}
}
