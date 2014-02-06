/**
 * Created by user on 06.02.14.
 */
package ru.ipo.kio._14.stars {
public class Line {

    private var _s1:Star;
    private var _s2:Star;

    public function Line(s1:Star, s2:Star) {
        this._s1 = s1;
        this._s2 = s2;
    }

    public function get s1():Star {
        return _s1;
    }

    public function get s2():Star {
        return _s2;
    }

    public function get distance():Number {
        var dx:Number = _s1.x - _s2.x;
        var dy:Number = _s1.y - _s2.y;
        return Math.sqrt(dx * dx + dy * dy);
    }
}
}
