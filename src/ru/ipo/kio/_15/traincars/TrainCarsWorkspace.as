/**
 * Created by ilya on 25.01.15.
 */
package ru.ipo.kio._15.traincars {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;

import ru.ipo.kio.api.controls.GraphicsButton;
import ru.ipo.kio.api.controls.InfoPanel;

public class TrainCarsWorkspace extends Sprite {

    [Embed(source="resources/btn.png")]
    public static const WAY_UP_CLASS:Class;
    public static const WAY_UP_IMG:BitmapData = (new WAY_UP_CLASS).bitmapData;
    [Embed(source="resources/btn.png")]
    public static const WAY_DOWN_CLASS:Class;
    public static const WAY_DOWN_IMG:BitmapData = (new WAY_UP_CLASS).bitmapData;
    [Embed(source="resources/btn.png")]
    public static const WAY_OVER_CLASS:Class;
    public static const WAY_OVER_IMG:BitmapData = (new WAY_UP_CLASS).bitmapData;

    public static var TOP_END_TICK:int;
    public static var WAY_START_TICK:int;

    private var _positions:CarsPositions;

    private var _animation:Boolean = true;

    private var _undo_list:Vector.<MovingAction> = new <MovingAction>[];
    private var _downhill_steps:int = 0;
    private var _uphill_steps:int = 0;

    private var _info_current:InfoPanel;
    private var _info_record:InfoPanel;

    private var _api:KioApi;
    private var _problem:KioProblem;

    public function TrainCarsWorkspace(problem:KioProblem) {
        _api = KioApi.instance(problem);
        _problem = problem;
        draw();
        putButtons();

        _api.addEventListener(KioApi.RECORD_EVENT, function (e:Event):void {
            update_info(_info_record, result);
        });

        //TODO will not be needed after loading of solution implemented
        update_info(_info_current, result);
    }

    private function draw():void {
        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(0, 0, 780, 600);
        graphics.endFill();

        var rSet:RailsSet = new RailsSet();

        var i1:int = rSet.add(new Point(680, 300), new Point(635, 300), new Point(590, 150));
        var i2:int = rSet.add(new Point(590, 150), new Point(545, 0), new Point(400, 0));
        var i3:int = rSet.add(new Point(400, 0), new Point(300, 0), new Point(100, 0));
        var i4:int = rSet.add(new Point(100, 0), new Point(0, 0), new Point(0, 100));

        var switch1:Array = rSet.addVerticalSwitch(new Point(0, 100), 80, 40);
        var switch2:Array = rSet.addVerticalSwitch(switch1[0], 50, 20);
        var switch3:Array = rSet.addVerticalSwitch(switch1[1], 50, 20);

        var final_way_ind_0:Vector.<int> = new Vector.<int>(4);
        var final_way_ind_1:Vector.<int> = new Vector.<int>(4);
        var final_way_ind_2:Vector.<int> = new Vector.<int>(4);

        for (var e_point_ind:int = 0; e_point_ind < 4; e_point_ind++) {
            var p:Point = [switch2[0], switch2[1], switch3[0], switch3[1]][e_point_ind];
            var e_point:Point = new Point(p.x, p.y + 280 - e_point_ind * 30 - 50);
            final_way_ind_0[e_point_ind] = rSet.addLine(p, e_point);

            var vert:Number = 550 - e_point_ind * 30;
            var hor:Number = 100 + e_point_ind * 20;

            final_way_ind_1[e_point_ind] = rSet.add(e_point, new Point(e_point.x, vert), new Point(hor, vert));
            final_way_ind_2[e_point_ind] = rSet.addLine(new Point(hor, vert), new Point(680, vert));
        }

        var railWays:Vector.<RailWay> = new <RailWay>[];
        railWays.push(new RailWay(rSet, [i1, i2, i3, i4, switch1[2][0], switch1[2][1], switch2[2][0], switch2[2][1], final_way_ind_0[0], final_way_ind_1[0], final_way_ind_2[0]]));
        railWays.push(new RailWay(rSet, [i1, i2, i3, i4, switch1[2][0], switch1[2][1], switch2[3][0], switch2[3][1], final_way_ind_0[1], final_way_ind_1[1], final_way_ind_2[1]]));
        railWays.push(new RailWay(rSet, [i1, i2, i3, i4, switch1[3][0], switch1[3][1], switch3[2][0], switch3[2][1], final_way_ind_0[2], final_way_ind_1[2], final_way_ind_2[2]]));
        railWays.push(new RailWay(rSet, [i1, i2, i3, i4, switch1[3][0], switch1[3][1], switch3[3][0], switch3[3][1], final_way_ind_0[3], final_way_ind_1[3], final_way_ind_2[3]]));

        addChild(rSet);
        rSet.x = 100;
        rSet.y = 25;

        TOP_END_TICK = rSet.rail(i4).startK + 100 / CurveRail.DL;
        WAY_START_TICK = rSet.rail(final_way_ind_0[0]).startK + 20 / CurveRail.DL;

        _positions = new CarsPositions(rSet, railWays);

        _positions.positionCars();

        initInfoPanels();

        //draw bottom
        for (var e:int = 0; e < CarsPositions.WAYS_COUNT; e++) {
            rSet.rail(final_way_ind_1[e]).drawBottom(Car.STATION_COLOR[e]);
            rSet.rail(final_way_ind_2[e]).drawBottom(Car.STATION_COLOR[e]);
        }
    }

    private function initInfoPanels():void {
        _info_current = new InfoPanel(
                'KioArial', true, 14, 0x000000, 0x222222, 0x880000, 1.2, _api.localization.solution, [
                    _api.localization.correct, _api.localization.transpositions, _api.localization.uphill_steps, _api.localization.downhill_steps
                ], 140
        );

        _info_record = new InfoPanel(
                'KioArial', true, 14, 0x000000, 0x222222, 0x880000, 1.2, _api.localization.record, [
                    _api.localization.correct, _api.localization.transpositions, _api.localization.uphill_steps, _api.localization.downhill_steps
                ], 140
        );

        addChild(_info_current);
        addChild(_info_record);
        _info_current.x = 250;
        _info_current.y = 100;
        _info_record.x = 250;
        _info_record.y = 250;
    }

    private function putButtons():void {
        var b01:GraphicsButton = new GraphicsButton(_api.localization.buttons.up1, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b02:GraphicsButton = new GraphicsButton(_api.localization.buttons.up2, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b03:GraphicsButton = new GraphicsButton(_api.localization.buttons.up3, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b04:GraphicsButton = new GraphicsButton(_api.localization.buttons.up4, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b1:GraphicsButton = new GraphicsButton(_api.localization.buttons.down1, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b2:GraphicsButton = new GraphicsButton(_api.localization.buttons.down2, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b3:GraphicsButton = new GraphicsButton(_api.localization.buttons.down3, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b4:GraphicsButton = new GraphicsButton(_api.localization.buttons.down4, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var bu:GraphicsButton = new GraphicsButton(_api.localization.buttons.undo, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);

        var ba_on:GraphicsButton = new GraphicsButton(_api.localization.buttons.a_on, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var ba_off:GraphicsButton = new GraphicsButton(_api.localization.buttons.a_off, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b_cl:GraphicsButton = new GraphicsButton(_api.localization.buttons.clear, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);

        addChild(b01);
        addChild(b02);
        addChild(b03);
        addChild(b04);
        addChild(b1);
        addChild(b2);
        addChild(b3);
        addChild(b4);
        addChild(bu);
        addChild(ba_on);
        addChild(ba_off);
        addChild(b_cl);

        b1.x = 445 + 80;
        b1.y = 300;
        b2.x = 490 + 80;
        b2.y = 300;
        b3.x = 535 + 80;
        b3.y = 300;
        b4.x = 580 + 80;
        b4.y = 300;

        b01.x = 445 + 80;
        b01.y = 350;
        b02.x = 490 + 80;
        b02.y = 350;
        b03.x = 535 + 80;
        b03.y = 350;
        b04.x = 580 + 80;
        b04.y = 350;

        bu.x = 445 + 80;
        bu.y = 400;
        ba_on.x = 490 + 80;
        ba_on.y = 400;
        ba_off.x = ba_on.x;
        ba_off.y = ba_on.y;
        ba_on.visible = false;
        b_cl.x = 535 + 80;
        b_cl.y = 400;

        function moveFromWay(way_ind:int):Function {
            return function(e:Event):void {
                if (!_positions.mayMoveToTop(way_ind))
                    return;
                var ma:MovingAction = new MovingAction(MovingAction.TYP_TO_TOP, _positions, way_ind);
                _undo_list.push(ma);
                _uphill_steps ++;
                ma.execute(_animation);
            }
        }

        function moveToWay(way_ind:int):Function {
            return function(e:Event):void {
                if (!_positions.mayMoveFromTop())
                    return;
                var ma:MovingAction = new MovingAction(MovingAction.TYP_FROM_TOP, _positions, way_ind);
                _undo_list.push(ma);
                _downhill_steps ++;
                ma.execute(_animation);
            }
        }

        function undoAction(e:Event):void {
            if (_undo_list.length > 0) {
                var ma:MovingAction = _undo_list.pop();
                if (ma.typ == MovingAction.TYP_FROM_TOP)
                    _downhill_steps --;
                else
                    _uphill_steps --;
                ma.undo();
            }
        }

        b01.addEventListener(MouseEvent.CLICK, moveFromWay(0));
        b02.addEventListener(MouseEvent.CLICK, moveFromWay(1));
        b03.addEventListener(MouseEvent.CLICK, moveFromWay(2));
        b04.addEventListener(MouseEvent.CLICK, moveFromWay(3));

        b1.addEventListener(MouseEvent.CLICK, moveToWay(0));
        b2.addEventListener(MouseEvent.CLICK, moveToWay(1));
        b3.addEventListener(MouseEvent.CLICK, moveToWay(2));
        b4.addEventListener(MouseEvent.CLICK, moveToWay(3));

        bu.addEventListener(MouseEvent.CLICK, undoAction);

        ba_on.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            ba_on.visible = false;
            ba_off.visible = true;
            _animation = true;
        });

        ba_off.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            ba_off.visible = false;
            ba_on.visible = true;
            _animation = false;
            _positions.positionCars();
        });

        b_cl.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            clear();
        });

        _positions.addEventListener(CarsPositions.EVENT_ALL_STOPPED, function (event:Event):void {
            var r:Object = result;
            update_info(_info_current, r);
            _api.submitResult(r);
        });

        _positions.addEventListener(CarsPositions.EVENT_SOME_CAR_STARTED_MOVING, function (event:Event):void {
            trace('started moving ' + Math.random());
        })
    }

    private static function update_info(i:InfoPanel, r:Object):void {
        i.setValue(0, r.correct);
        i.setValue(1, r.transpositions);
        i.setValue(2, r.up_hill);
        i.setValue(3, r.down_hill);
    }

    public function get result():Object {
        return {
            correct: _positions.correctCarsCount,
            transpositions: _positions.transpositionsCount,
            up_hill: uphill_steps,
            down_hill: downhill_steps
        };
    }

    public function get downhill_steps():int {
        return _downhill_steps;
    }

    public function get uphill_steps():int {
        return _uphill_steps;
    }

    public function clear():void {
        _undo_list.splice(0, _undo_list.length);
        _uphill_steps = 0;
        _downhill_steps = 0;
        _positions.clear();
    }
}
}
