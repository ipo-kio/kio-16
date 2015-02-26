/**
 * Created by ilya on 25.01.15.
 */
package ru.ipo.kio._15.traincars {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;

import ru.ipo.kio.api.controls.GraphicsButton;
import ru.ipo.kio.api.controls.InfoPanel;

public class TrainCarsWorkspace extends Sprite {

    [Embed(source="resources/fon-4.png")]
    public static const BACKGROUND_CLASS:Class;
    public static const BACKGROUND:BitmapData = (new BACKGROUND_CLASS).bitmapData;

    [Embed(source="resources/kn-zel_01.png")]
    public static const WAY_UP_CLASS:Class;
    public static const WAY_UP_IMG:BitmapData = (new WAY_UP_CLASS).bitmapData;
    [Embed(source="resources/kn-zel_03.png")]
    public static const WAY_DOWN_CLASS:Class;
    public static const WAY_DOWN_IMG:BitmapData = (new WAY_DOWN_CLASS).bitmapData;
    [Embed(source="resources/kn-zel_02.png")]
    public static const WAY_OVER_CLASS:Class;
    public static const WAY_OVER_IMG:BitmapData = (new WAY_OVER_CLASS).bitmapData;

    [Embed(source="resources/kn-kr_01.png")]
    public static const TOP_UP_CLASS:Class;
    public static const TOP_UP_IMG:BitmapData = (new TOP_UP_CLASS).bitmapData;
    [Embed(source="resources/kn-kr_03.png")]
    public static const TOP_DOWN_CLASS:Class;
    public static const TOP_DOWN_IMG:BitmapData = (new TOP_DOWN_CLASS).bitmapData;
    [Embed(source="resources/kn-kr_02.png")]
    public static const TOP_OVER_CLASS:Class;
    public static const TOP_OVER_IMG:BitmapData = (new TOP_OVER_CLASS).bitmapData;

    [Embed(source="resources/kn-kr-strelka.png")]
    public static const KN_KR_STR_CLASS:Class;
    public static const KN_KR_STR_IMG:BitmapData = (new KN_KR_STR_CLASS).bitmapData;

    [Embed(source="resources/kn-undo_01.png")]
    public static const UNDO_1_CLASS:Class;
    public static const UNDO_1_IMG:BitmapData = (new UNDO_1_CLASS).bitmapData;
    [Embed(source="resources/kn-undo_02.png")]
    public static const UNDO_2_CLASS:Class;
    public static const UNDO_2_IMG:BitmapData = (new UNDO_2_CLASS).bitmapData;
    [Embed(source="resources/kn-undo_03.png")]
    public static const UNDO_3_CLASS:Class;
    public static const UNDO_3_IMG:BitmapData = (new UNDO_3_CLASS).bitmapData;

    [Embed(source="resources/oboznach0.png")]
    public static const OBOZNACH_0_CLASS:Class;
    public static const OBOZNACH_0_IMG:BitmapData = (new OBOZNACH_0_CLASS).bitmapData;
    [Embed(source="resources/oboznach1.png")]
    public static const OBOZNACH_1_CLASS:Class;
    public static const OBOZNACH_1_IMG:BitmapData = (new OBOZNACH_1_CLASS).bitmapData;
    [Embed(source="resources/oboznach2.png")]
    public static const OBOZNACH_2_CLASS:Class;
    public static const OBOZNACH_2_IMG:BitmapData = (new OBOZNACH_2_CLASS).bitmapData;

    [Embed(source="resources/ochistit_01.png")]
    public static const CLEAR_0_CLASS:Class;
    public static const CLEAR_0_IMG:BitmapData = (new CLEAR_0_CLASS).bitmapData;
    [Embed(source="resources/ochistit_02.png")]
    public static const CLEAR_1_CLASS:Class;
    public static const CLEAR_1_IMG:BitmapData = (new CLEAR_1_CLASS).bitmapData;
    [Embed(source="resources/ochistit_03.png")]
    public static const CLEAR_2_CLASS:Class;
    public static const CLEAR_2_IMG:BitmapData = (new CLEAR_2_CLASS).bitmapData;

    [Embed(source="resources/fon-dom.png")]
    public static const HOUSE_CLASS:Class;
    public static const HOUSE_IMG:BitmapData = (new HOUSE_CLASS).bitmapData;

    [Embed(source="resources/animazia_02_1.png")]
    public static const ANIMATION_1_CLASS:Class;
    public static const ANIMATION_1_IMG:BitmapData = (new ANIMATION_1_CLASS).bitmapData;
    [Embed(source="resources/animazia_03_1.png")]
    public static const ANIMATION_2_CLASS:Class;
    public static const ANIMATION_2_IMG:BitmapData = (new ANIMATION_2_CLASS).bitmapData;
    [Embed(source="resources/animazia_04_1.png")]
    public static const ANIMATION_3_CLASS:Class;
    public static const ANIMATION_3_IMG:BitmapData = (new ANIMATION_3_CLASS).bitmapData;

    [Embed(source="resources/animazia_02.png")]
    public static const ANIMATIONN_1_CLASS:Class;
    public static const ANIMATIONN_1_IMG:BitmapData = (new ANIMATIONN_1_CLASS).bitmapData;
    [Embed(source="resources/animazia_03.png")]
    public static const ANIMATIONN_2_CLASS:Class;
    public static const ANIMATIONN_2_IMG:BitmapData = (new ANIMATIONN_2_CLASS).bitmapData;
    [Embed(source="resources/animazia_04.png")]
    public static const ANIMATIONN_3_CLASS:Class;
    public static const ANIMATIONN_3_IMG:BitmapData = (new ANIMATIONN_3_CLASS).bitmapData;

    [Embed(source="resources/svetofor-L-green.png")]
    public static const SVET_L_G:Class;
    public static const SVET_L_G_IMG:BitmapData = (new SVET_L_G).bitmapData;
    [Embed(source="resources/svetofor-L-red.png")]
    public static const SVET_L_R:Class;
    public static const SVET_L_R_IMG:BitmapData = (new SVET_L_R).bitmapData;

    [Embed(source="resources/svetofor-R-green.png")]
    public static const SVET_R_G:Class;
    public static const SVET_R_G_IMG:BitmapData = (new SVET_R_G).bitmapData;
    [Embed(source="resources/svetofor-R-red.png")]
    public static const SVET_R_R:Class;
    public static const SVET_R_R_IMG:BitmapData = (new SVET_R_R).bitmapData;

    public static var TOP_END_TICK:int;
    public static var WAY_START_TICK:int;

    public static var MAIN_FONT:String = 'KioArial';

    private var background:Sprite = new Sprite();
    private var cars:Sprite = new Sprite();
    private var otherObjects:Sprite = new Sprite();

    private var left_green_semaphore:Sprite = new Sprite();
    private var right_green_semaphore:Sprite = new Sprite();
    private var left_red_semaphore:Sprite = new Sprite();
    private var right_red_semaphore:Sprite = new Sprite();

    private var _positions:CarsPositions;

    private var _animation:Boolean = true;

    private var _undo_list:Vector.<MovingAction> = new <MovingAction>[];
    private var _downhill_steps:int = 0;
    private var _uphill_steps:int = 0;

    private var _info_current:InfoPanel;
    private var _info_record:InfoPanel;

    private var _api:KioApi;
    private var _problem:KioProblem;

    private var __loading:Boolean = false;

    public function TrainCarsWorkspace(problem:KioProblem) {
        _api = KioApi.instance(problem);
        _problem = problem;

        if (KioApi.language == KioApi.L_TH)
            MAIN_FONT = 'KioTahoma';

        draw();
        putButtons();

        _api.addEventListener(KioApi.RECORD_EVENT, function (e:Event):void {
            update_info(_info_record, result);
        });

        //TODO will not be needed after loading of solution implemented
        update_info(_info_current, result);
    }

    private function draw():void {
        background.graphics.beginBitmapFill(BACKGROUND);
        //graphics.drawRect(0, 0, 780, 600);
        background.graphics.drawRect(0, 0, 780, 600);
        background.graphics.endFill();

        var rSet:RailsSet = new RailsSet();

        var i1:int = rSet.add(new Point(680, 300), new Point(635, 300), new Point(590, 150));
        var i2:int = rSet.add(new Point(590, 150), new Point(545, 22), new Point(400, 22));
        var i3:int = rSet.add(new Point(400, 22), new Point(300, 22), new Point(100, 22));
        var i4:int = rSet.add(new Point(100, 22), new Point(0, 22), new Point(0, 100));

        var switch1:Array = rSet.addVerticalSwitch(new Point(0, 100), 80, 40);
        var switch2:Array = rSet.addVerticalSwitch(switch1[0], 50, 20);
        var switch3:Array = rSet.addVerticalSwitch(switch1[1], 50, 20);

        var final_way_ind_0:Vector.<int> = new Vector.<int>(4);
        var final_way_ind_1:Vector.<int> = new Vector.<int>(4);
        var final_way_ind_2:Vector.<int> = new Vector.<int>(4);

        for (var e_point_ind:int = 0; e_point_ind < 4; e_point_ind++) {
            var p:Point = [switch2[0], switch2[1], switch3[0], switch3[1]][e_point_ind];
            var e_point:Point = new Point(p.x, p.y + 280 - e_point_ind * 30 - 70);
            final_way_ind_0[e_point_ind] = rSet.addLine(p, e_point);

            var vert:Number = 550 - e_point_ind * (30 + 4) - 18;
            var hor:Number = 100 + e_point_ind * 20;

            final_way_ind_1[e_point_ind] = rSet.add(e_point, new Point(e_point.x, vert), new Point(hor, vert));
            final_way_ind_2[e_point_ind] = rSet.addLine(new Point(hor, vert), new Point(680, vert));
        }

        var railWays:Vector.<RailWay> = new <RailWay>[];
        railWays.push(new RailWay(rSet, [i1, i2, i3, i4, switch1[2][0], switch1[2][1], switch2[2][0], switch2[2][1], final_way_ind_0[0], final_way_ind_1[0], final_way_ind_2[0]]));
        railWays.push(new RailWay(rSet, [i1, i2, i3, i4, switch1[2][0], switch1[2][1], switch2[3][0], switch2[3][1], final_way_ind_0[1], final_way_ind_1[1], final_way_ind_2[1]]));
        railWays.push(new RailWay(rSet, [i1, i2, i3, i4, switch1[3][0], switch1[3][1], switch3[2][0], switch3[2][1], final_way_ind_0[2], final_way_ind_1[2], final_way_ind_2[2]]));
        railWays.push(new RailWay(rSet, [i1, i2, i3, i4, switch1[3][0], switch1[3][1], switch3[3][0], switch3[3][1], final_way_ind_0[3], final_way_ind_1[3], final_way_ind_2[3]]));

        //addChild(rSet);
        //rSet.x = 100;
        //rSet.y = 25;
        cars.addChild(rSet);
        cars.addChild(otherObjects);
        background.addChild(cars);
        addChild(background);
        rSet.x = 100;
        rSet.y = 25;

        TOP_END_TICK = rSet.rail(i4).startK + 100 / CurveRail.DL;
        WAY_START_TICK = rSet.rail(final_way_ind_0[0]).startK + 20 / CurveRail.DL;

        _positions = new CarsPositions(_problem, rSet, railWays);

        _positions.positionCars();

        drawOtherObjects();
        drawSemaphores();
        initInfoPanels();

        _positions.addEventListener(CarsPositions.EVENT_ALL_STOPPED, updateSemaphores);
        _positions.addEventListener(CarsPositions.EVENT_SOME_CAR_STARTED_MOVING, updateSemaphores);

        updateSemaphores();
    }

    private function updateSemaphores(event:Event = null):void {
        if (!_animation) {
            left_green_semaphore.visible = true;
            right_green_semaphore.visible = true;
            left_red_semaphore.visible = false;
            right_red_semaphore.visible = false;
        } else {
            var fromTop:Boolean = _positions.mayMoveFromTop();
            var toTop:Boolean = _positions.mayMoveToTop(0) || _positions.mayMoveToTop(1) || _positions.mayMoveToTop(2) || _positions.mayMoveToTop(3);
            left_green_semaphore.visible = fromTop;
            left_red_semaphore.visible = !fromTop;
            right_green_semaphore.visible = toTop;
            right_red_semaphore.visible = !toTop;
        }
    }

    private function drawSemaphores():void {
        var dx_1:Number = 55 - (SVET_L_G_IMG.width*0.5);
        var dy_1:Number = 136 - 22 - (SVET_L_G_IMG.height*0.5);

        var m1:Matrix = new Matrix();
        m1.translate(dx_1, dy_1);

        left_green_semaphore.graphics.beginBitmapFill(SVET_L_G_IMG, m1);
        left_green_semaphore.graphics.drawRect(dx_1, dy_1, SVET_L_G_IMG.width, SVET_L_G_IMG.height);
        left_green_semaphore.graphics.endFill();

        var dx_2:Number = 145 - (SVET_R_G_IMG.width*0.5);
        var dy_2:Number = 136 - 22 - (SVET_R_G_IMG.height*0.5);

        var m2:Matrix = new Matrix();
        m2.translate(dx_2, dy_2);

        right_green_semaphore.graphics.beginBitmapFill(SVET_R_G_IMG, m2);
        right_green_semaphore.graphics.drawRect(dx_2, dy_2, SVET_R_G_IMG.width, SVET_R_G_IMG.height);
        right_green_semaphore.graphics.endFill();

        var dx_3:Number = 55 - (SVET_L_R_IMG.width*0.5);
        var dy_3:Number = 136 - 22 - (SVET_L_R_IMG.height*0.5);

        var m3:Matrix = new Matrix();
        m3.translate(dx_3, dy_3);

        left_red_semaphore.graphics.beginBitmapFill(SVET_L_R_IMG, m3);
        left_red_semaphore.graphics.drawRect(dx_3, dy_3, SVET_L_R_IMG.width, SVET_L_R_IMG.height);
        left_red_semaphore.graphics.endFill();

        var dx_4:Number = 145 - (SVET_R_R_IMG.width*0.5);
        var dy_4:Number = 136 - 22 - (SVET_R_R_IMG.height*0.5);

        var m4:Matrix = new Matrix();
        m4.translate(dx_4, dy_4);

        right_red_semaphore.graphics.beginBitmapFill(SVET_R_R_IMG, m4);
        right_red_semaphore.graphics.drawRect(dx_4, dy_4, SVET_R_R_IMG.width, SVET_R_R_IMG.height);
        right_red_semaphore.graphics.endFill();

        otherObjects.addChild(left_green_semaphore);
        otherObjects.addChild(left_red_semaphore);
        otherObjects.addChild(right_green_semaphore);
        otherObjects.addChild(right_red_semaphore);
    }

    private function drawOtherObjects():void {

        var oboznach_img:BitmapData = [OBOZNACH_0_IMG, OBOZNACH_1_IMG, OBOZNACH_2_IMG][_problem.level];

        var dx_1:Number = 97 - (oboznach_img.width*0.5);
        var dy_1:Number = 248 - 18 - (oboznach_img.height*0.5);

        var m1:Matrix = new Matrix();
        m1.translate(dx_1, dy_1);

        otherObjects.graphics.beginBitmapFill(oboznach_img, m1);
        otherObjects.graphics.drawRect(dx_1, dy_1, oboznach_img.width, oboznach_img.height);
        otherObjects.graphics.endFill();

        var dx_2:Number = 711 - (HOUSE_IMG.width*0.5);
        var dy_2:Number = 200 - (HOUSE_IMG.height*0.5);

        var m2:Matrix = new Matrix();
        m2.translate(dx_2, dy_2);

        otherObjects.graphics.beginBitmapFill(HOUSE_IMG, m2);
        otherObjects.graphics.drawRect(dx_2, dy_2, HOUSE_IMG.width, HOUSE_IMG.height);
        otherObjects.graphics.endFill();
    }

    private function initInfoPanels():void {
        var labels:Array;
        switch (_problem.level) {
            case 0: labels = [_api.localization.correct, _api.localization.unordered, _api.localization.steps]; break;
            case 1: labels = [_api.localization.correct, _api.localization.unordered, _api.localization.uphill_steps, _api.localization.downhill_steps]; break;
            case 2: labels = [_api.localization.correct, _api.localization.transpositions, _api.localization.uphill_steps, _api.localization.downhill_steps]; break;
        }

        _info_current = new InfoPanel(MAIN_FONT, true, 14, 0x000000, 0x222222, 0x880000, 1.2, _api.localization.solution, labels, 140);

        _info_record = new InfoPanel(MAIN_FONT, true, 14, 0x000000, 0x222222, 0x880000, 1.2, _api.localization.record, labels, 140);

        otherObjects.addChild(_info_current);
        otherObjects.addChild(_info_record);
        _info_current.x = 278;
        _info_current.y = 275;
        _info_record.x = 470;
        _info_record.y = 275;
    }

    private function putButtons():void {
        var b01:GraphicsButton = new GraphicsButton(/*_api.localization.buttons.up1*/"", TOP_UP_IMG, TOP_OVER_IMG, TOP_DOWN_IMG, MAIN_FONT, 20, 20);
        var b02:GraphicsButton = new GraphicsButton(/*_api.localization.buttons.up2*/"", TOP_UP_IMG, TOP_OVER_IMG, TOP_DOWN_IMG, MAIN_FONT, 20, 20);
        var b03:GraphicsButton = new GraphicsButton(/*_api.localization.buttons.up3*/"", TOP_UP_IMG, TOP_OVER_IMG, TOP_DOWN_IMG, MAIN_FONT, 20, 20);
        var b04:GraphicsButton = new GraphicsButton(/*_api.localization.buttons.up4*/"", TOP_UP_IMG, TOP_OVER_IMG, TOP_DOWN_IMG, MAIN_FONT, 20, 20);
        var b1:GraphicsButton = new GraphicsButton(_api.localization.buttons.down1, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, MAIN_FONT, 20, 20, 0, 1, 0, -6, false, 0xFFFFFF, true);
        var b2:GraphicsButton = new GraphicsButton(_api.localization.buttons.down2, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, MAIN_FONT, 20, 20, 0, 1, 0, -6, false, 0xFFFFFF, true);
        var b3:GraphicsButton = new GraphicsButton(_api.localization.buttons.down3, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, MAIN_FONT, 20, 20, 0, 1, 0, -6, false, 0xFFFFFF, true);
        var b4:GraphicsButton = new GraphicsButton(_api.localization.buttons.down4, WAY_UP_IMG, WAY_OVER_IMG, WAY_DOWN_IMG, MAIN_FONT, 20, 20, 0, 1, 0, -6, false, 0xFFFFFF, true);

        var bu:GraphicsButton = new GraphicsButton(_api.localization.buttons.undo, UNDO_2_IMG, UNDO_1_IMG, UNDO_3_IMG, MAIN_FONT, 14, 14, 0, 0, 0, 37, false, 0, true);

        var ba_on:GraphicsButton = new GraphicsButton(_api.localization.buttons.a_on, ANIMATIONN_1_IMG, ANIMATIONN_2_IMG, ANIMATIONN_3_IMG, MAIN_FONT, 14, 14, 0, 0, 28, 3, false, 0, true);
        var ba_off:GraphicsButton = new GraphicsButton(_api.localization.buttons.a_off, ANIMATION_1_IMG, ANIMATION_2_IMG, ANIMATION_3_IMG, MAIN_FONT, 14, 14, 0, 0, 28, 3, false, 0, true);
        var b_cl:GraphicsButton = new GraphicsButton(_api.localization.buttons.clear, CLEAR_0_IMG, CLEAR_1_IMG, CLEAR_2_IMG, MAIN_FONT, 14, 14, 0, 0, -28, 3, false, 0, true);

        otherObjects.addChild(b01);
        otherObjects.addChild(b02);
        otherObjects.addChild(b03);
        otherObjects.addChild(b04);
        otherObjects.addChild(b1);
        otherObjects.addChild(b2);
        otherObjects.addChild(b3);
        otherObjects.addChild(b4);
        otherObjects.addChild(bu);
        otherObjects.addChild(ba_on);
        otherObjects.addChild(ba_off);
        otherObjects.addChild(b_cl);

        b1.x = 269;
        b1.y = 131;
        b2.x = 342;
        b2.y = 131;
        b3.x = 415;
        b3.y = 131;
        b4.x = 488;
        b4.y = 131;

        b01.x = 271;
        b01.y = 200;
        b02.x = 344;
        b02.y = 200;
        b03.x = 417;
        b03.y = 200;
        b04.x = 488;
        b04.y = 200;

        bu.x = 560;
        bu.y = 129;
        ba_on.x = 414;
        ba_on.y = 383;
        ba_off.x = ba_on.x;
        ba_off.y = ba_on.y;
        ba_on.visible = false;
        b_cl.x = 260;
        b_cl.y = 382;

        function moveFromWay(way_ind:int):Function {
            return function(e:Event):void {
                if (!_positions.mayMoveToTop(way_ind))
                    return;
                var ma:MovingAction = new MovingAction(MovingAction.TYP_TO_TOP, _positions, way_ind);
                _undo_list.push(ma);
                _uphill_steps ++;
                ma.execute(_animation);
                _api.autoSaveSolution();
                updateSemaphores();
                currentResultUpdate();
                _api.log('from way ' + way_ind);
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
                _api.autoSaveSolution();
                updateSemaphores();
                currentResultUpdate();
                _api.log('to way ' + way_ind);
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
                _api.autoSaveSolution();
                updateSemaphores();
                currentResultUpdate();
                _api.log('undo');
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

//        _positions.addEventListener(CarsPositions.EVENT_ALL_STOPPED, function (event:Event):void {
//            currentResultUpdate();
//        });

        _positions.addEventListener(CarsPositions.EVENT_SOME_CAR_STARTED_MOVING, function (event:Event):void {
            trace('started moving ' + Math.random());
        });

        drawArrows();
    }

    private function currentResultUpdate():void {
        var r:Object = result;
        update_info(_info_current, r);
        if (!__loading)
            _api.submitResult(r);
    }

    private function drawArrows():void {

        var dx_1:Number = 318 - (KN_KR_STR_IMG.width*0.5);
        var dy_1:Number = 220 - (KN_KR_STR_IMG.height*0.5);

        var m1:Matrix = new Matrix();
        m1.translate(dx_1, dy_1);

        otherObjects.graphics.beginBitmapFill(KN_KR_STR_IMG, m1);
        otherObjects.graphics.drawRect(dx_1, dy_1, KN_KR_STR_IMG.width, KN_KR_STR_IMG.height);
        otherObjects.graphics.endFill();

        var dx_2:Number = 391 - (KN_KR_STR_IMG.width*0.5);
        var dy_2:Number = 220 - (KN_KR_STR_IMG.height*0.5);

        var m2:Matrix = new Matrix();
        m2.translate(dx_2, dy_2);

        otherObjects.graphics.beginBitmapFill(KN_KR_STR_IMG, m2);
        otherObjects.graphics.drawRect(dx_2, dy_2, KN_KR_STR_IMG.width, KN_KR_STR_IMG.height);
        otherObjects.graphics.endFill();

        var dx_3:Number = 464 - (KN_KR_STR_IMG.width*0.5);
        var dy_3:Number = 220 - (KN_KR_STR_IMG.height*0.5);

        var m3:Matrix = new Matrix();
        m3.translate(dx_3, dy_3);

        otherObjects.graphics.beginBitmapFill(KN_KR_STR_IMG, m3);
        otherObjects.graphics.drawRect(dx_3, dy_3, KN_KR_STR_IMG.width, KN_KR_STR_IMG.height);
        otherObjects.graphics.endFill();

        var dx_4:Number = 535 - (KN_KR_STR_IMG.width*0.5);
        var dy_4:Number = 220 - (KN_KR_STR_IMG.height*0.5);

        var m4:Matrix = new Matrix();
        m4.translate(dx_4, dy_4);

        otherObjects.graphics.beginBitmapFill(KN_KR_STR_IMG, m4);
        otherObjects.graphics.drawRect(dx_4, dy_4, KN_KR_STR_IMG.width, KN_KR_STR_IMG.height);
        otherObjects.graphics.endFill();
    }

    private function update_info(i:InfoPanel, r:Object):void {
        i.setValue(0, r.c);
        i.setValue(1, r.t);
        if (_problem.level == 0)
            i.setValue(2, r.h);
        else {
            i.setValue(2, r.uh);
            i.setValue(3, r.dh);
        }
    }

    public function get result():Object {
        switch (_problem.level) {
            case 0:
                return {
                    c: _positions.correctCarsCount,
                    t: _positions.unorderCount,
                    h: uphill_steps + downhill_steps
                };
            case 1:
                return {
                    c: _positions.correctCarsCount,
                    t: _positions.unorderCount,
                    uh: uphill_steps,
                    dh: downhill_steps
                };
            default: //level 2
                return {
                    c: _positions.correctCarsCount,
                    t: _positions.transpositionsCount,
                    uh: uphill_steps,
                    dh: downhill_steps
                };
        }
    }

    public function get downhill_steps():int {
        if (_uphill_steps + _downhill_steps != _undo_list.length) {
            var cnt:int = 0;
            for each (var action:MovingAction in _undo_list)
                if (action.typ == MovingAction.TYP_FROM_TOP)
                    cnt ++;
            return cnt;
        }

        return _downhill_steps;
    }

    public function get uphill_steps():int {
        if (_uphill_steps + _downhill_steps != _undo_list.length) {
            var cnt:int = 0;
            for each (var action:MovingAction in _undo_list)
                if (action.typ == MovingAction.TYP_TO_TOP)
                    cnt ++;
            return cnt;
        }

        return _uphill_steps;
    }

    public function clear():void {
        _undo_list.splice(0, _undo_list.length);
        _uphill_steps = 0;
        _downhill_steps = 0;
        _positions.clear();

        if (!__loading)
            _api.autoSaveSolution();
        _api.log('clear');
    }

    public function solution():Object {
        var res:Vector.<int> = new <int>[];

        for (var i:int = 0; i < _undo_list.length; i++)
            res.push(_undo_list[i].shortRepresentation);

        return {
            a: res
        };
    }

    public function loadSolution(solution:Object):Boolean {
        if (solution == null)
            return false;

        __loading = true;

        clear();

        var a:Vector.<int> = solution.a;

        for (var i:int = 0; i < a.length; i++) {
            var ma:MovingAction = MovingAction.createFromShortRepresentation(a[i], _positions);
            _undo_list.push(ma);
            if (ma.typ == MovingAction.TYP_FROM_TOP)
                _downhill_steps ++;
            else
                _uphill_steps ++;
            ma.execute(false);
        }

        _positions.positionCars();

        __loading = false;

        updateSemaphores();

        _api.submitResult(result);
        _api.autoSaveSolution();

        return true;
    }
}
}
