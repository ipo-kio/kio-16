package ru.ipo.kio._16.mars {

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import ru.ipo.kio._16.mars.model.Consts;
import ru.ipo.kio._16.mars.model.MarsResult;

import ru.ipo.kio._16.mars.model.ShipHistory;
import ru.ipo.kio._16.mars.model.ShipAction;
import ru.ipo.kio._16.mars.model.Vector2D;

import ru.ipo.kio._16.mars.view.SolarSystem;
import ru.ipo.kio._16.mars.view.VectorView;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.controls.GraphicsButton;
import ru.ipo.kio.api.controls.InfoPanel;

public class MarsWorkspace extends Sprite {

    /*[Embed(source="res/plus.png")]
     public static const ADD_BUTTON_CLASS:Class;
     public static const ADD_BUTTON_IMG:BitmapData = (new ADD_BUTTON_CLASS).bitmapData;
     [Embed(source="res/plus_o.png")]
     public static const ADD_BUTTON_O_CLASS:Class;
     public static const ADD_BUTTON_O_IMG:BitmapData = (new ADD_BUTTON_O_CLASS).bitmapData;
     [Embed(source="res/plus_d.png")]
     public static const ADD_BUTTON_D_CLASS:Class;
     public static const ADD_BUTTON_D_IMG:BitmapData = (new ADD_BUTTON_D_CLASS).bitmapData;
     [Embed(source="res/minus.png")]
     public static const REMOVE_BUTTON_CLASS:Class;
     public static const REMOVE_BUTTON_IMG:BitmapData = (new REMOVE_BUTTON_CLASS).bitmapData;
     [Embed(source="res/minus_o.png")]
     public static const REMOVE_BUTTON_O_CLASS:Class;
     public static const REMOVE_BUTTON_O_IMG:BitmapData = (new REMOVE_BUTTON_O_CLASS).bitmapData;
     [Embed(source="res/minus_d.png")]
     public static const REMOVE_BUTTON_D_CLASS:Class;
     public static const REMOVE_BUTTON_D_IMG:BitmapData = (new REMOVE_BUTTON_D_CLASS).bitmapData;*/

    [Embed(source="res/ser-kn-1.png")]
    public static const BUTTON_1_CLASS:Class;
    public static const BUTTON_1_BMP:BitmapData = (new BUTTON_1_CLASS).bitmapData;
    [Embed(source="res/ser-kn-2.png")]
    public static const BUTTON_2_CLASS:Class;
    public static const BUTTON_2_BMP:BitmapData = (new BUTTON_2_CLASS).bitmapData;
    [Embed(source="res/ser-kn-3.png")]
    public static const BUTTON_3_CLASS:Class;
    public static const BUTTON_3_BMP:BitmapData = (new BUTTON_3_CLASS).bitmapData;
    [Embed(source="res/ser-kn-plus.png")]
    public static const BUTTON_PLUS_CLASS:Class;
    public static const BUTTON_PLUS_BMP:BitmapData = (new BUTTON_PLUS_CLASS).bitmapData;
    [Embed(source="res/ser-kn-minus.png")]
    public static const BUTTON_MINUS_CLASS:Class;
    public static const BUTTON_MINUS_BMP:BitmapData = (new BUTTON_MINUS_CLASS).bitmapData;

    [Embed(source="res/bg.png")]
    public static const BG_CLASS:Class;

    public static const TOTAL_CIRCLES:int = 7;

    private var background:Sprite = new Sprite();

    private var _problem:KioProblem;
    private var _api:KioApi;

    private var ss:SolarSystem;
    private var timeSlider:Slider;

    private var bAdd:GraphicsButton = new GraphicsButton('', [BUTTON_1_BMP, BUTTON_PLUS_BMP], [BUTTON_2_BMP, BUTTON_PLUS_BMP], [BUTTON_1_BMP, BUTTON_PLUS_BMP], '', 10, 10);
    private var bRemove:GraphicsButton = new GraphicsButton('', [BUTTON_1_BMP, BUTTON_MINUS_BMP], [BUTTON_2_BMP, BUTTON_MINUS_BMP], [BUTTON_1_BMP, BUTTON_MINUS_BMP], '', 10, 10);
    private var bAdd_dis:GraphicsButton = new GraphicsButton('', [BUTTON_3_BMP, BUTTON_PLUS_BMP], [BUTTON_3_BMP, BUTTON_PLUS_BMP], [BUTTON_3_BMP, BUTTON_PLUS_BMP], '', 10, 10);
    private var bRemove_dis:GraphicsButton = new GraphicsButton('', [BUTTON_3_BMP, BUTTON_MINUS_BMP], [BUTTON_3_BMP, BUTTON_MINUS_BMP], [BUTTON_3_BMP, BUTTON_MINUS_BMP], '', 10, 10);

    private var speedView:VectorView;
    private var setSpeedView:VectorView;

    private var _current_info:InfoPanel;
    private var _closest_info:InfoPanel;
    private var _closest_record:InfoPanel;

    private var beginAnim:GraphicsButton = new GraphicsButton(">", BUTTON_1_BMP, BUTTON_2_BMP, BUTTON_3_BMP, 'KioArial', 20, 20);
    private var pauseAnim:GraphicsButton  = new GraphicsButton("||", BUTTON_1_BMP, BUTTON_2_BMP, BUTTON_3_BMP, 'KioArial', 20, 20);

    public function MarsWorkspace(problem:KioProblem) {
//        trace(Orbit.solveKeplerEquation(2.8453268117053505, 0.5084113241345426)); //newtown fails here

        _problem = problem;
        _api = KioApi.instance(problem);

        background.graphics.beginBitmapFill((new BG_CLASS).bitmapData);
        background.graphics.drawRect(0, 0, 780, 600);
        background.graphics.endFill();

        addChild(background);

//        background.graphics.lineStyle(0);
//        background.graphics.beginFill(0xFFFF00);
//        background.graphics.drawCircle(300, 300, 280 / 1.524924921 / 100);
//        background.graphics.endFill();

//        background.graphics.lineStyle(1, 0xFF0000);
//        background.graphics.drawCircle(300, 300, 280);
//        background.graphics.drawCircle(300, 300, 280 / 1.524924921);

        setSpeedView = new VectorView(360, 100, 4000, 80, 0xFFFFFF, false, 0, 0xFFFFFF);
        speedView = new VectorView(180, 40, 50000, 80, 0xFFFF00, true, 2, 0xFFFF00);
        addChild(setSpeedView);
        addChild(speedView);
        setSpeedView.x = 680;
        setSpeedView.y = 140;
        speedView.x = 680;
        speedView.y = 140;

        speedView.editable = false;
        speedView.mouseEnabled = false;
        speedView.mouseChildren = false;

        setSpeedView.visible = false;

        var history:ShipHistory = new ShipHistory(Vector2D.create(Consts.EARTH_R, 0), Vector2D.create(0, Consts.EARTH_Vt), SolarSystem.marsOrbit);
//        history.push(new ShipAction(60, Vector2D.create(0, Consts.EARTH_Vt / 20)));
//        history.push(new ShipAction(120, Vector2D.create(0, Consts.EARTH_Vt / 20)));
//        history.push(new ShipAction(180, Vector2D.create(0, Consts.EARTH_Vt / 20)));

        ss = new SolarSystem(this, setSpeedView, history);
        addChild(ss);
        ss.x = 290;
        ss.y = 300;

        timeSlider = new Slider(0, Consts.MAX_TIME, 660, 0x000000, 0x000000);
        timeSlider.x = 20;
        timeSlider.y = 570;
        addChild(timeSlider);
        timeSlider.addEventListener(Slider.VALUE_CHANGED, slider_value_changedHandler);
        timeSlider.value_no_fire = 0;

        //init add remove buttons
        addChild(bAdd);
        addChild(bRemove);
        addChild(bAdd_dis);
        addChild(bRemove_dis);

        bAdd.x = 500;
        bAdd.y = 10;
        bRemove.x = bAdd.x + 50;
        bRemove.y = bAdd.y;

        bAdd_dis.x = bAdd.x;
        bRemove_dis.x = bRemove.x;
        bAdd_dis.y = bAdd.y;
        bRemove_dis.y = bRemove.y;

        bAdd_dis.useHandCursor = false;
        bRemove_dis.useHandCursor = false;

        bAdd_dis.visible = false;
        bRemove_dis.visible = false;

        update_add_remove_buttons_state();

        bAdd.addEventListener(MouseEvent.CLICK, bAdd_clickHandler);
        bRemove.addEventListener(MouseEvent.CLICK, bRemove_clickHandler);

        init_info();

        _api.addEventListener(KioApi.RECORD_EVENT, api_recordHandler);

        //hohmann:
        var v1:Number = Consts.EARTH_Vt;
        var v2:Number = Consts.MARS_Vt;
        var vp:Number = Math.sqrt((v1 * v1 + v2 * v2) / 2);
        var dv:Number = v1 * (v1 / vp - 1);
        var dvp:Number = v2 * (1 - v2 / vp);

        var VV:Number = Math.sqrt(dv * dv + Consts.EARTH_V2 * Consts.EARTH_V2);

        update_speed_view();

        trace('hohmann: ', dv * 3.6, dvp * 3.6, VV * 3.6, (VV - Consts.EARTH_V1) * 3.6);
        trace('hohmann: ', dv, dvp, VV, VV - Consts.EARTH_V1);

        //init buttons
//        var toStart:GraphicsButton = new GraphicsButton("<<", BUTTON_1_BMP, BUTTON_2_BMP, BUTTON_3_BMP, 'KioArial', 14, 14);

//        var toOpt:GraphicsButton  = new GraphicsButton("o", BUTTON_1_BMP, BUTTON_2_BMP, BUTTON_3_BMP, 'KioArial', 14, 14);

        addChild(beginAnim);
        addChild(pauseAnim);
        beginAnim.x = 780 - beginAnim.width - 4;
        beginAnim.y = 600 - beginAnim.height - 4;
        pauseAnim.x = beginAnim.x;
        pauseAnim.y = beginAnim.y;

        pauseAnim.visible = false;
        beginAnim.addEventListener(MouseEvent.CLICK, beginAnim_clickHandler);
        pauseAnim.addEventListener(MouseEvent.CLICK, pauseAnim_clickHandler);
    }

    private function init_info():void {
        var labels:Array = [
            "Расст.",
            "Скор.",
            "Топл.",
            "День"
        ];

        _current_info = new InfoPanel('KioArial', true, 14, 0xFFFFFF, 0xFFFFFF, 0xFFFF00, 1.2, 'Текущие', labels, 190);
        _closest_info = new InfoPanel('KioArial', true, 14, 0xFFFFFF, 0xFFFFFF, 0xFFFF00, 1.2, 'Максимальное сближение', labels, 190);
        _closest_record = new InfoPanel('KioArial', true, 14, 0xFFFFFF, 0xFFFFFF, 0xFFFF00, 1.2, 'Рекорд', labels, 190);

        addChild(_current_info);
        addChild(_closest_info);
        addChild(_closest_record);

        _current_info.x = 580;
        _closest_info.x = _current_info.x;
        _closest_record.x = _current_info.x;

        _current_info.y = 280;
        _closest_info.y = _current_info.y + _closest_info.height;
        _closest_record.y = _closest_info.y + _closest_record.height;
    }

    public function update_add_remove_buttons_state():void {
        var actions:Vector.<ShipAction> = ss.history.actions;

        if (actions.length == 0) {
            bAdd.visible = true;
            bAdd_dis.visible = false;
            bRemove.visible = false;
            bRemove_dis.visible = true;
            return;
        }

//        var lastAction:ShipAction = actions[actions.length - 1];
//        var addEnable:Boolean = timeSlider.valueRounded > lastAction.time;

        var hasActionAtThisTime:Boolean = false;
        for each (var sa:ShipAction in actions)
            if (sa.time == timeSlider.valueRounded) {
                hasActionAtThisTime = true;
                break;
            }
        var removeEnable:Boolean = ss.currentShipAction != null;
        var addEnable:Boolean = !hasActionAtThisTime;

        bAdd.visible = addEnable;
        bAdd_dis.visible = !addEnable;
        bRemove.visible = removeEnable;
        bRemove_dis.visible = !removeEnable;
    }

    private function slider_value_changedHandler(event:Event):void {
        ss.time = timeSlider.valueRounded;

        update_add_remove_buttons_state();

        update_speed_view();

        update_current_info();
    }

    private function update_current_info():void {
        var time:int = timeSlider.valueRounded;
        var marsResult:MarsResult = ss.history.marsResults[time];
        update_info(_current_info, marsResult);
    }

    private static function update_info(infoPanel:InfoPanel, marsResult:MarsResult):void {
        infoPanel.setValue(0, (marsResult.isClose ? "ok " : "") + (marsResult.mars_dist / 1000000).toFixed(0) + " т.км");
        infoPanel.setValue(1, (marsResult.isSlow ? "ok " : "") + (marsResult.mars_speed * 3.6).toFixed(0) + " км/ч");
        infoPanel.setValue(2, marsResult.fuel.toFixed(0));
        infoPanel.setValue(3, marsResult.day);
    }

    private function update_speed_view():void {
        var valueRounded:Number = timeSlider.valueRounded;

        if (valueRounded < 0)
            valueRounded = 0;
        if (valueRounded > Consts.MAX_TIME)
            valueRounded = Consts.MAX_TIME;

        speedView.value = ss.history.speeds[valueRounded];
    }

    private function bAdd_clickHandler(event:MouseEvent):void {
        var shipAction:ShipAction = new ShipAction(timeSlider.valueRounded, Vector2D.create(0, 2000));
        ss.history.actions.push(shipAction);

        historyUpdated();

        ss.currentShipAction = shipAction;
    }

    private function bRemove_clickHandler(event:MouseEvent):void {
        if (ss.currentShipAction == null)
            return;

        var actions:Vector.<ShipAction> = ss.history.actions;

        for (var i:int = 0; i < actions.length; i++) {
            var action:ShipAction = actions[i];
            if (action == ss.currentShipAction) {
                actions.splice(i, 1);

                ss.currentShipAction = null;

                historyUpdated();

                break;
            }
        }
    }

    public function historyUpdated(autosave:Boolean = true):void {
        ss.history.evaluatePositions();
        ss.historyView.redraw();
        update_add_remove_buttons_state();

        var r:MarsResult = ss.history.bestMarsResult;
        if (autosave)
            _api.autoSaveSolution();
        _api.submitResult(r.as_object);
        update_info(_closest_info, r);
    }

    public function get solution():Object {
        return ss.history.as_object;
    }

    public function set solution(o:Object):void {
        ss.history.as_object = o;
        historyUpdated(false);
    }

//    public function resultForDay(day:int)
    public function get api():KioApi {
        return _api;
    }

    private function api_recordHandler(event:Event):void {
        update_info(_closest_record, ss.history.bestMarsResult);
    }

    private function beginAnim_clickHandler(event:MouseEvent):void {
        if (!beginAnim.visible)
            return;
        beginAnim.visible = false;
        pauseAnim.visible = true;
        framesCounter = 0;
        addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function pauseAnim_clickHandler(event:MouseEvent):void {
        if (!pauseAnim.visible)
            return;
        pauseAnim.visible = false;
        beginAnim.visible = true;
        removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private var framesCounter:int = 0;
    private function enterFrameHandler(event:Event):void {
        framesCounter ++;
        if (framesCounter % 5 == 0)
            timeSlider.value += 1;

        if (timeSlider.valueRounded == Consts.MAX_TIME)
            pauseAnim_clickHandler(null);
    }
}
}

// добавить точку, если корабль вне экрана
// показывать скорость планет сразу
// показывать нулевой вектор импульса сразу
// нарисовать планеты и корабль
// что с 1-ой космической? Какой импульс разрешить? Наверное, 5 км/c.
//    11880 минимальный начальный импульс, 28440 уже как бы есть сразу. Надо минимум 40320