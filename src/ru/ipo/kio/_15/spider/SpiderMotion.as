/**
 * Created by ilya on 17.02.15.
 */
package ru.ipo.kio._15.spider {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;

import ru.ipo.kio.api.controls.GraphicsButton;

public class SpiderMotion extends Sprite {

    [Embed(source="resources/kn-1.png")]
    public static const ANIMATE_BUTTON_ON_1:Class;
    public static const ANIMATE_BUTTON_ON_1_IMG:BitmapData = (new ANIMATE_BUTTON_ON_1).bitmapData;

    [Embed(source="resources/kn-2.png")]
    public static const ANIMATE_BUTTON_ON_2:Class;
    public static const ANIMATE_BUTTON_ON_2_IMG:BitmapData = (new ANIMATE_BUTTON_ON_2).bitmapData;

    [Embed(source="resources/kn-3.png")]
    public static const ANIMATE_BUTTON_ON_3:Class;
    public static const ANIMATE_BUTTON_ON_3_IMG:BitmapData = (new ANIMATE_BUTTON_ON_3).bitmapData;

    [Embed(source="resources/kn-1.png")]
    public static const ANIMATE_BUTTON_OFF_1:Class;
    public static const ANIMATE_BUTTON_OFF_1_IMG:BitmapData = (new ANIMATE_BUTTON_OFF_1).bitmapData;

    [Embed(source="resources/kn-2.png")]
    public static const ANIMATE_BUTTON_OFF_2:Class;
    public static const ANIMATE_BUTTON_OFF_2_IMG:BitmapData = (new ANIMATE_BUTTON_OFF_2).bitmapData;

    [Embed(source="resources/kn-3.png")]
    public static const ANIMATE_BUTTON_OFF_3:Class;
    public static const ANIMATE_BUTTON_OFF_3_IMG:BitmapData = (new ANIMATE_BUTTON_OFF_3).bitmapData;

    public static const ANGLE_DELTA:Number = 0.1 / 2;
    public static const TIME_TICKS:int = 90 * 10; //1 minute, 10 times a second

    private var _s:Spider;
    private var _f:Floor;
    private var _bigSpider:Spider;

    private var floor_point_ind:int;
    private var floor_point_position:Point;
    private var angle:Number;

    private var touchesEnd:Boolean = false;

    private var slider:Slider;
    private var animateButtonOn:GraphicsButton;
    private var animateButtonOff:GraphicsButton;

    private var evaluated_positions:Vector.<SpiderLocation> = null;

    private var api:KioApi;
    private var workspace:SpiderWorkspace;
    private var problem:KioProblem;

    public function SpiderMotion(workspace:SpiderWorkspace, problem:KioProblem, s:Spider, f:Floor, bigSpider:Spider) {
        this.workspace = workspace;
        this.problem = problem;
        api = KioApi.instance(problem);
        _s = s;
        _f = f;
        _bigSpider = bigSpider;

        api.addEventListener(KioApi.RECORD_EVENT, function(e:Event):void {
            workspace.setRecordResult(result);
        });

        addChild(_f);
        addChild(_s);

        slider = new Slider(0, problem.level == 0 ? TIME_TICKS : TIME_TICKS / 10, 600, 0x212121, 0x212121);
        addChild(slider);
        slider.x = 140;
        slider.y = 46;
        slider.precision = problem.level == 0 ? 0 : 1;

        reset();

        slider.addEventListener(Slider.VALUE_CHANGED, function (e:Event):void {
            if (spider_locations == null)
                return;
            var ind:int = slider2ind;
            if (ind >= spider_locations.length - 1)
                ind = spider_locations.length - 1;
            if (ind < 0)
                ind = 0;
            location = spider_locations[ind];
        });

        invalidatePositions();
        evaluatePositions();

        animateButtonOn = new GraphicsButton('►', ANIMATE_BUTTON_ON_1_IMG, ANIMATE_BUTTON_ON_2_IMG, ANIMATE_BUTTON_ON_3_IMG, 'KioArial', 22, 22, 0, 0, 2, 0);
        animateButtonOff = new GraphicsButton('▐ ▌', ANIMATE_BUTTON_OFF_1_IMG, ANIMATE_BUTTON_OFF_2_IMG, ANIMATE_BUTTON_OFF_3_IMG, 'KioArial', 12, 12);

        animateButtonOn.x = 12;
        animateButtonOn.y = 32;
        animateButtonOff.x = animateButtonOn.x;
        animateButtonOff.y = animateButtonOn.y;

        addChild(animateButtonOn);
        addChild(animateButtonOff);

        animateButtonOn.visible = false;

        animateButtonOn.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            animateButtonOn.visible = false;
            animateButtonOff.visible = true;
            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        });

        animateButtonOff.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            animateButtonOn.visible = true;
            animateButtonOff.visible = false;
            removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
        });

        addEventListener(Event.ENTER_FRAME, enterFrameHandler);

        _s.addEventListener(Mechanism.EVENT_ANGLE_CHANGED, function(e:Event):void {
            _bigSpider.angle = _s.angle;
        });
    }

    private function get slider2ind():Number {
        return Math.round(slider.value * (problem.level == 0 ? 1 : 10));
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

        slider.value_no_fire = 0;
    }

    public function add_delta():void {
        if (touchesEnd)
            return;

        slider.value_no_fire += 0.1;

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

        // Бондаревский Александр Витальевич - история цивилизаций,

        if (max_ind < 0)
            return;

        angle = max_angle;

        graphics.moveTo(floor_point_position.x, floor_point_position.y);
        graphics.lineTo(floor_point_position.x + 400 * Math.cos(angle), floor_point_position.y - 400 * Math.sin(angle));

        position_spider(s_steps[floor_point_ind]);

        touchesEnd = false;
        for (s_i = 0; s_i < 4; s_i++) {
            var pp:Point = _s.transform.matrix.transformPoint(s_steps[s_i]);
            if (_f.pointToTheRight(pp)) {
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
        return new SpiderLocation(floor_point_ind, floor_point_position, angle, touchesEnd, _s.angle);
    }

    private function set location(value:SpiderLocation):void {
        floor_point_ind = value.floor_point_ind;
        floor_point_position = value.floor_point_position;
        angle = value.angle;
        touchesEnd = value.touchesEnd;

        _s.angle = value.internal_angle;

        position_spider(_s.steps[floor_point_ind]);
    }

    private function evaluatePositions():void {
        var start_time:Number = new Date().getTime();
        var currentLocation:SpiderLocation = location;
        var currentSliderLocation:Number = slider.value;

        var res:Vector.<SpiderLocation> = new <SpiderLocation>[];

        reset();
        res.push(location);

        var ok:Boolean = false;
        for (var time:int = 0; time < TIME_TICKS; time++) {

            add_delta();
            add_delta();

            res.push(location);
            if (touchesEnd) {
                ok = true;
                break;
            }
        }

        location = currentLocation;
        slider.value_no_fire = currentSliderLocation;

        trace('evaluated positions', new Date().getTime() - start_time);
        trace('length', res.length);

        evaluated_positions = res;

        api.submitResult(result);
        workspace.setCurrentResult(result);
    }

    public function invalidatePositions():void {
        evaluated_positions = null;
    }

    public function get spider_locations():Vector.<SpiderLocation> {
        return evaluated_positions;
    }

    public function get ls():Vector.<Number> {
        return _s.ls;
    }

    public function set ls(value:Vector.<Number>):void {
        _s.ls = value;
        _bigSpider.ls = value;
        invalidatePositions();
        evaluatePositions();
    }

    public function move_slider():void {
        if (evaluated_positions == null)
            return;

        var ind:Number = slider2ind;
        if (ind < evaluated_positions.length - 1)
            slider.value += problem.level == 0 ? 1 : 0.1;
    }

    private function enterFrameHandler(event:Event):void {
        move_slider();
    }

    public function get finishes():Boolean {
        return evaluated_positions != null && evaluated_positions[evaluated_positions.length - 1].touchesEnd;
    }

    public function get time():Number {
        if (evaluated_positions == null)
            return 0;

        var res:Number = (evaluated_positions.length - 1) / 10;

        if (SpiderProblem.ROUND_SECONDS_UP)
            res = Math.ceil(res);

        return res;
    }

    public function get material():Number {
        var ls:Vector.<Number> = _s.ls;
        var res:Number = ls[0] + ls[1] + ls[2] + ls[3] + ls[4] + ls[5] + ls[6];

        if (problem.level >= 1)
            res += ls[7] + ls[8];

        return res;
    }

    public function get result():Object {
        return {
            ok: finishes,
            t: time,
            m: material
        }
    }
}
}
