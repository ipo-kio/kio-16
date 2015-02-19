/**
 * Created by ilya on 16.02.15.
 */
package ru.ipo.kio._15.spider {
import flash.display.Sprite;
import flash.geom.Point;

public class Spider extends Sprite {

    private var _angle:Number = 0;
    private var left_back:Mechanism = new Mechanism();
    private var left_forward:Mechanism = new Mechanism();
    private var right_back:Mechanism = new Mechanism();
    private var right_forward:Mechanism = new Mechanism();

    public function Spider() {
        addChild(left_back);
        addChild(left_forward);
        addChild(right_back);
        addChild(right_forward);

        left_back.grayed = true;
        left_forward.grayed = true;

        left_forward.x_inverse = true;
        right_forward.x_inverse = true;

        position_mechanism(left_back);
        position_mechanism(left_forward);
        position_mechanism(right_back);
        position_mechanism(right_forward);

        angle = 0;
    }

    private static function position_mechanism(m:Mechanism):void {
        var center:Point = m.p1_p;
        m.x = -center.x;
        m.y = -center.y;
    }


    public function get angle():Number {
        return -_angle;
    }

    public function set angle(value:Number):void {
        _angle = -value;
        left_back.angle = _angle;
        right_back.angle = _angle + Math.PI;
        left_forward.angle = _angle;
        right_forward.angle = _angle + Math.PI;
    }

    public function get steps():Vector.<Point> {
        function mechanism_s(m:Mechanism):Point {
            return m.s_p.add(new Point(m.x, m.y));
        }

        return new <Point>[
            mechanism_s(right_back),
            mechanism_s(left_back),
            mechanism_s(right_forward),
            mechanism_s(left_forward)
        ];
    }

}
}
