/**
 * Created by ilya on 25.01.15.
 */
package ru.ipo.kio._15.traincars {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import ru.ipo.kio._15.traincars.MovingAction;

import ru.ipo.kio.api.controls.GraphicsButton;

public class TrainCarsWorkspace extends Sprite {
    
/*
    [Embed(source="resources/way0up.png")]
    public static const WAY_0_UP_CLASS:Class;
    public static const WAY_0_UP_IMG:BitmapData = (new WAY_0_UP_CLASS).bitmapData;
    [Embed(source="resources/way0down.png")]
    public static const WAY_0_DOWN_CLASS:Class;
    public static const WAY_0_DOWN_IMG:BitmapData = (new WAY_0_UP_CLASS).bitmapData;
    [Embed(source="resources/way0over.png")]
    public static const WAY_0_OVER_CLASS:Class;
    public static const WAY_0_OVER_IMG:BitmapData = (new WAY_0_UP_CLASS).bitmapData;
    [Embed(source="resources/way1up.png")]
    public static const WAY_1_UP_CLASS:Class;
    public static const WAY_1_UP_IMG:BitmapData = (new WAY_1_UP_CLASS).bitmapData;
    [Embed(source="resources/way1down.png")]
    public static const WAY_1_DOWN_CLASS:Class;
    public static const WAY_1_DOWN_IMG:BitmapData = (new WAY_1_UP_CLASS).bitmapData;
    [Embed(source="resources/way1over.png")]
    public static const WAY_1_OVER_CLASS:Class;
    public static const WAY_1_OVER_IMG:BitmapData = (new WAY_1_UP_CLASS).bitmapData;
    [Embed(source="resources/way2up.png")]
    public static const WAY_2_UP_CLASS:Class;
    public static const WAY_2_UP_IMG:BitmapData = (new WAY_2_UP_CLASS).bitmapData;
    [Embed(source="resources/way2down.png")]
    public static const WAY_2_DOWN_CLASS:Class;
    public static const WAY_2_DOWN_IMG:BitmapData = (new WAY_2_UP_CLASS).bitmapData;
    [Embed(source="resources/way2over.png")]
    public static const WAY_2_OVER_CLASS:Class;
    public static const WAY_2_OVER_IMG:BitmapData = (new WAY_2_UP_CLASS).bitmapData;
    [Embed(source="resources/way3up.png")]
    public static const WAY_3_UP_CLASS:Class;
    public static const WAY_3_UP_IMG:BitmapData = (new WAY_3_UP_CLASS).bitmapData;
    [Embed(source="resources/way3down.png")]
    public static const WAY_3_DOWN_CLASS:Class;
    public static const WAY_3_DOWN_IMG:BitmapData = (new WAY_3_UP_CLASS).bitmapData;
    [Embed(source="resources/way3over.png")]
    public static const WAY_3_OVER_CLASS:Class;
    public static const WAY_3_OVER_IMG:BitmapData = (new WAY_3_UP_CLASS).bitmapData;
*/

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

    private var _undo_list:Vector.<MovingAction> = new <MovingAction>[];

    public function TrainCarsWorkspace() {
        draw();
        putButtons();
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
    }

    private function putButtons():void {
        var b01:GraphicsButton = new GraphicsButton("^1", WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b02:GraphicsButton = new GraphicsButton("^2", WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b03:GraphicsButton = new GraphicsButton("^3", WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b04:GraphicsButton = new GraphicsButton("^4", WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b1:GraphicsButton = new GraphicsButton("1", WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b2:GraphicsButton = new GraphicsButton("2", WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b3:GraphicsButton = new GraphicsButton("3", WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var b4:GraphicsButton = new GraphicsButton("4", WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);
        var bu:GraphicsButton = new GraphicsButton("undo", WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, 'KioArial', 20, 20);

        addChild(b01);
        addChild(b02);
        addChild(b03);
        addChild(b04);
        addChild(b1);
        addChild(b2);
        addChild(b3);
        addChild(b4);
        addChild(bu);

        b1.x = 445;
        b1.y = 300;
        b2.x = 490;
        b2.y = 300;
        b3.x = 535;
        b3.y = 300;
        b4.x = 580;
        b4.y = 300;

        b01.x = 445;
        b01.y = 350;
        b02.x = 490;
        b02.y = 350;
        b03.x = 535;
        b03.y = 350;
        b04.x = 580;
        b04.y = 350;

        bu.x = 445;
        bu.y = 400;

        function moveFromWay(way_ind:int):Function {
            return function(e:Event):void {
                if (!_positions.mayMoveToTop(way_ind))
                    return;
                var ma:MovingAction = new MovingAction(MovingAction.TYP_TO_TOP, _positions, way_ind);
                ma.execute();
                _undo_list.push(ma);
            }
        }

        function moveToWay(way_ind:int):Function {
            return function(e:Event):void {
                if (!_positions.mayMoveFromTop())
                    return;
                var ma:MovingAction = new MovingAction(MovingAction.TYP_FROM_TOP, _positions, way_ind);
                ma.execute();
                _undo_list.push(ma);
            }
        }

        function undoAction(e:Event):void {
            if (_undo_list.length > 0) {
                var ma:MovingAction = _undo_list.pop();
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

        bu.addEventListener(MouseEvent.CLICK, undoAction)
    }
}
}
