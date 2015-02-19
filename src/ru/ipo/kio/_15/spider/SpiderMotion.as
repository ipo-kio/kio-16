/**
 * Created by ilya on 17.02.15.
 */
package ru.ipo.kio._15.spider {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.geom.Point;

public class SpiderMotion extends Sprite {

    [Embed(source="resources/btn.png")]
    public static const ANIMATE_BUTTON_ON:Class;
    public static const ANIMATE_BUTTON_ON_IMG:BitmapData = (new ANIMATE_BUTTON_ON).bitmapData;

    [Embed(source="resources/btn.png")]
    public static const ANIMATE_BUTTON_OFF:Class;
    public static const ANIMATE_BUTTON_OFF_IMG:BitmapData = (new ANIMATE_BUTTON_OFF).bitmapData;

    public static const ANGLE_DELTA:Number = 0.1;

    private var _s:Spider;
    private var _f:Floor;

    private var floor_point_ind:int;
    private var floor_point_position:Point;
    private var angle:Number;

    private var touchesEnd:Boolean = false;

    private var slider:Slider;

    public function SpiderMotion(s:Spider, f:Floor) {
        _s = s;
        _f = f;

        addChild(_s);
        addChild(_f);

        slider = new Slider(0, 1, 400, 0x212121, 0x727272);
        addChild(slider);

        reset();
    }

    public function reset():void {
        _s.angle = 0;
        floor_point_ind = 0;
        floor_point_position = new Point(0, 0);
        angle = 0;
        touchesEnd = false;

        var steps:Vector.<Point> = _s.steps;
        var base_point:Point = steps[floor_point_ind];

        position_spider(base_point);
    }

    public function add_delta():void {
        if (touchesEnd)
            return;

        graphics.clear();
        graphics.lineStyle(0, 0x00FF00, 0);

        _s.angle += ANGLE_DELTA;

        //find max angle
        var s_steps:Vector.<Point> = _s.steps;
        var base:Point = s_steps[floor_point_ind];

        var max_ind:int = -1;
        var max_angle:Number = -Infinity;

        var new_floor_point_position:Point = null;

        for (var s_i:int = 0; s_i < 4; s_i++)
            if (s_i != floor_point_ind) {
                var s_point:Point = s_steps[s_i];
                if (s_point.x <= base.x)
                    continue;

                var point:Point = s_point
                        .add(new Point(floor_point_position.x, floor_point_position.y))
                        .subtract(base);

                var d2:Number = (s_point.x - base.x) * (s_point.x - base.x) + (s_point.y - base.y) * (s_point.y - base.y);
                var ints:Vector.<Point> = _f.intersectWithCircle(floor_point_position.x, floor_point_position.y, d2);

                graphics.drawCircle(floor_point_position.x, floor_point_position.y, Math.sqrt(d2));

                for each (var p:Point in ints)
                    if (p.x > floor_point_position.x) {
                        graphics.drawCircle(p.x, p.y, 5);
                        //angle p-floor_point_position-hor
                        var a:Number = Math.atan2(point.y - floor_point_position.y, point.x - floor_point_position.x);
                        a -= Math.atan2(p.y - floor_point_position.y, p.x - floor_point_position.x);
                        if (a > max_angle) {
                            max_ind = s_i;
                            max_angle = a;
                            new_floor_point_position = p;
                        }

                        graphics.moveTo(floor_point_position.x, floor_point_position.y);
                        graphics.lineTo(floor_point_position.x + 200 * Math.cos(a), floor_point_position.y - 200 * Math.sin(a));
                    }
            }

        if (max_ind < 0)
            return;

        angle = max_angle;

        graphics.moveTo(floor_point_position.x, floor_point_position.y);
        graphics.lineTo(floor_point_position.x + 400 * Math.cos(angle), floor_point_position.y - 400 * Math.sin(angle));

        position_spider(s_steps[floor_point_ind]);

        touchesEnd = false;
        for (s_i = 0; s_i < 4; s_i++) {
            var pp:Point = _s.transform.matrix.transformPoint(s_steps[s_i]);
            if (_f.pointOnLastSegment(pp)) {
                touchesEnd = true;
                break;
            }
        }

        if (max_ind == 0 || max_ind == 1) {
            floor_point_ind = max_ind;
            floor_point_position = new_floor_point_position;
        }
    }

    private function position_spider(s_point:Point):void {
        var m:Matrix = new Matrix();
        m.translate(-s_point.x, -s_point.y);
        m.rotate(-angle);

        m.translate(floor_point_position.x, floor_point_position.y);

        _s.transform.matrix = m;
    }

    private function get location():SpiderLocation {
        return new SpiderLocation(floor_point_ind, floor_point_position, angle, touchesEnd);
    }

    private function set location(value:SpiderLocation):void {
        floor_point_ind = value.floor_point_ind;
        floor_point_position = value.floor_point_position;
        angle = value.angle;
        touchesEnd = value.touchesEnd;

        position_spider(_s.steps[floor_point_ind]);
    }

    public function evaluatePositions():Vector.<SpiderLocation> {
        var start_time:Number = new Date().getTime();
        var currentLocation:SpiderLocation = location;

        var res:Vector.<SpiderLocation> = new <SpiderLocation>[];

        reset();
        res.push(location);

        var ok:Boolean = false;
        for (var time:int = 0; time < 60 * 10; time++) {
            add_delta();
            res.push(location);
            if (touchesEnd) {
                ok = true;
                break;
            }
        }

        location = currentLocation;

        position_spider(_s.steps[floor_point_ind]);

        trace('evaluated positions', new Date().getTime() - start_time);

        return res;
    }
}
}
