package ru.ipo.kio._16.mars {

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._16.mars.model.Consts;
import ru.ipo.kio._16.mars.model.MarsResult;

import ru.ipo.kio._16.mars.model.ShipHistory;
import ru.ipo.kio._16.mars.model.ShipAction;
import ru.ipo.kio._16.mars.model.Vector2D;
import ru.ipo.kio._16.mars.view.PlanetsSystem;

import ru.ipo.kio._16.mars.view.SolarSystem;
import ru.ipo.kio._16.mars.view.VectorView;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.controls.GraphicsButton;
import ru.ipo.kio.api.controls.InfoPanel;

public class PlanetsWorkspace extends Sprite {

    [Embed(source="res/plus.png")]
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
    public static const REMOVE_BUTTON_D_IMG:BitmapData = (new REMOVE_BUTTON_D_CLASS).bitmapData;

    [Embed(source="res/bg.png")]
    public static const BG_CLASS:Class;

    public static const TOTAL_CIRCLES:int = 7;

    private var background:Sprite = new Sprite();

    private var _problem:KioProblem;
    private var _api:KioApi;

    private var ss:PlanetsSystem;
    private var timeSlider:Slider;

    private var bAdd:GraphicsButton = new GraphicsButton('', ADD_BUTTON_IMG, ADD_BUTTON_O_IMG, ADD_BUTTON_O_IMG, '', 10, 10);
    private var bRemove:GraphicsButton = new GraphicsButton('', REMOVE_BUTTON_IMG, REMOVE_BUTTON_O_IMG, REMOVE_BUTTON_O_IMG, '', 10, 10);
    private var bAdd_dis:GraphicsButton = new GraphicsButton('', ADD_BUTTON_D_IMG, ADD_BUTTON_D_IMG, ADD_BUTTON_D_IMG, '', 10, 10);
    private var bRemove_dis:GraphicsButton = new GraphicsButton('', REMOVE_BUTTON_D_IMG, REMOVE_BUTTON_D_IMG, REMOVE_BUTTON_D_IMG, '', 10, 10);

    private var speedView:VectorView;
    private var setSpeedView:VectorView;

    private var _current_info:InfoPanel;
    private var _closest_info:InfoPanel;
    private var _closest_record:InfoPanel;

    public function PlanetsWorkspace(problem:KioProblem) {
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

        setSpeedView = new VectorView(360, 100, 5000, 80, 0xFFFFFF, false, 0, 0xFFFFFF);
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

        ss = new PlanetsSystem(this, setSpeedView, _planets);
        addChild(ss);
        ss.x = 290;
        ss.y = 300;

        timeSlider = new Slider(0, Consts.MAX_TIME, 700, 0x000000, 0x000000);
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

        init_info();

        _api.addEventListener(KioApi.RECORD_EVENT, api_recordHandler);
    }

    private function init_info():void {
        var labels:Array = [
//                "День",
//                "Расстояние до Марса",
//                "Скорость отн. Марса",
//                "Топливо"
                "День",
                "Расст.",
                "Скор.",
                "Топл."
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

        _current_info.y = 300;
        _closest_info.y = _current_info.y + _closest_info.height;
        _closest_record.y = _closest_info.y + _closest_record.height;
    }

    private function slider_value_changedHandler(event:Event):void {
        ss.time = timeSlider.valueRounded;

        update_current_info();
    }

    private function update_current_info():void {
//        var time:int = timeSlider.valueRounded;
//        var marsResult:MarsResult = ss.history.marsResults[time];
//        update_info(_current_info, marsResult);
    }

    private static function update_info(infoPanel:InfoPanel, marsResult:MarsResult):void {
        infoPanel.setValue(0, marsResult.day);
        infoPanel.setValue(1, (marsResult.isClose ? "ok " : "") + (marsResult.mars_dist / 1000000).toFixed(0) + " т.км");
        infoPanel.setValue(2, (marsResult.isSlow ? "ok " : "") + (marsResult.mars_speed * 3.6).toFixed(0) + " км/ч");
        infoPanel.setValue(3, marsResult.fuel.toFixed(0));
    }

    public function set solution(o:Object):void {
//        ss.history.as_object = o;
//        historyUpdated(false);
    }

//    public function resultForDay(day:int)
    public function get api():KioApi {
        return _api;
    }

    private function api_recordHandler(event:Event):void {
        //TODO
    }
}
}

// добавить точку, если корабль вне экрана
// показывать скорость планет сразу
// показывать нулевой вектор импульса сразу
// нарисовать планеты и корабль
// что с 1-ой космической? Какой импульс разрешить? Наверное, 5 км/c.
//    11880 минимальный начальный импульс, 28440 уже как бы есть сразу. Надо минимум 40320