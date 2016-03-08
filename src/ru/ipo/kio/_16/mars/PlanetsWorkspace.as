package ru.ipo.kio._16.mars {

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

import ru.ipo.kio._16.mars.model.Consts;
import ru.ipo.kio._16.mars.model.MarsResult;
import ru.ipo.kio._16.mars.model.Orbit;

import ru.ipo.kio._16.mars.model.ShipHistory;
import ru.ipo.kio._16.mars.model.Vector2D;
import ru.ipo.kio._16.mars.view.PlanetsSystem;

import ru.ipo.kio._16.mars.view.SolarSystem;
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

    private var bZoomIn:GraphicsButton = new GraphicsButton('', ADD_BUTTON_IMG, ADD_BUTTON_O_IMG, ADD_BUTTON_O_IMG, '', 10, 10);
    private var bZoomOut:GraphicsButton = new GraphicsButton('', REMOVE_BUTTON_IMG, REMOVE_BUTTON_O_IMG, REMOVE_BUTTON_O_IMG, '', 10, 10);
    private var bZoomIn_dis:GraphicsButton = new GraphicsButton('', ADD_BUTTON_D_IMG, ADD_BUTTON_D_IMG, ADD_BUTTON_D_IMG, '', 10, 10);
    private var bZoomOut_dis:GraphicsButton = new GraphicsButton('', REMOVE_BUTTON_D_IMG, REMOVE_BUTTON_D_IMG, REMOVE_BUTTON_D_IMG, '', 10, 10);

    private var _current_info:InfoPanel;
    private var _closest_info:InfoPanel;
    private var _closest_record:InfoPanel;

    private var planetInfos:Vector.<InfoPanel>;
    private var answer_year_days:Vector.<int>;

    public function PlanetsWorkspace(problem:KioProblem) {
//        trace(Orbit.solveKeplerEquation(2.8453268117053505, 0.5084113241345426)); //newtown fails here

        _problem = problem;
        _api = KioApi.instance(problem);

        background.graphics.beginBitmapFill((new BG_CLASS).bitmapData);
        background.graphics.drawRect(0, 0, 780, 600);
        background.graphics.endFill();

        addChild(background);

        var history:ShipHistory = new ShipHistory(Vector2D.create(Consts.EARTH_R, 0), Vector2D.create(0, Consts.EARTH_Vt), SolarSystem.marsOrbit);
//        history.push(new ShipAction(60, Vector2D.create(0, Consts.EARTH_Vt / 20)));
//        history.push(new ShipAction(120, Vector2D.create(0, Consts.EARTH_Vt / 20)));
//        history.push(new ShipAction(180, Vector2D.create(0, Consts.EARTH_Vt / 20)));

        var au:Number = 148e6;
//        var _planets:Vector.<Vector2D> = new <Vector2D>[];
//
//        for (var i:int = 0; i < Consts.planets_names.length; i++) {
//            _planets.push(Vector2D.createPolar(Consts.AU * Consts.planets_orbits[i], 0));
//        }

        ss = new PlanetsSystem(this);
        addChild(ss);
        ss.x = 290;
        ss.y = 300;

        timeSlider = new Slider(0, Consts.MAX_TIME, 700, 0x000000, 0x000000);
        timeSlider.x = 20;
        timeSlider.y = 570;
        addChild(timeSlider);
        timeSlider.addEventListener(Slider.VALUE_CHANGED, slider_value_changedHandler);
        timeSlider.value_no_fire = 0;

        init_zoom_in_and_out_buttons();

        update_zoom_in_and_out_buttons_state();

        init_info();

        _api.addEventListener(KioApi.RECORD_EVENT, api_recordHandler);

        init_planets_info();
    }

    private function init_planets_info():void {
        planetInfos = new <InfoPanel>[];
        answer_year_days = new <int>[];
        for (var i:int = 0; i < Consts.planets_names.length; i++) {
            var realOrbit:Orbit = Orbit.createOrbitByInitial(Vector2D.createPolar(
                    Consts.AU * Consts.planets_orbits[i], Math.PI / 180 * Consts.planets_phis[i]
            ));
            var daysRotate:int = days_in_orbit(realOrbit);
            answer_year_days.push(daysRotate);
            var ip:InfoPanel = new InfoPanel(
                    'KioArial', true, 14, 0xFFFFFF, 0xFFFFFF, 0xFFFF00, 1.2, Consts.planets_names[i],
                    [
                        'Год (' + daysRotate + ')',
                        'Позиция'
                    ],
                    150
            );
            addChild(ip);
            planetInfos.push(ip);

            var dh:Number = 24;

            ip.x = 590 + dh;
            ip.y = 10 + (ip.height + 2) * i;

            var m:Matrix = new Matrix();

            var w:int = Consts.planet_view[i].width;
            var h:int = Consts.planet_view[i].height;

            m.translate(ip.x - dh + (dh - w) / 2, ip.y + (ip.height - h) / 2);
            background.graphics.beginBitmapFill(Consts.planet_view[i], m);

            background.graphics.drawRect(ip.x - dh + (dh - w) / 2, ip.y + (ip.height - h) / 2, w, h);
            background.graphics.endFill();
        }
    }

    private function init_zoom_in_and_out_buttons():void {
        addChild(bZoomIn);
        addChild(bZoomOut);
        addChild(bZoomIn_dis);
        addChild(bZoomOut_dis);

        bZoomIn.x = 10;
        bZoomIn.y = 10;
        bZoomOut.x = bZoomIn.x;
        bZoomOut.y = bZoomIn.y + bZoomIn.height + 4;

        bZoomIn_dis.x = bZoomIn.x;
        bZoomOut_dis.x = bZoomOut.x;
        bZoomIn_dis.y = bZoomIn.y;
        bZoomOut_dis.y = bZoomOut.y;

        bZoomIn_dis.useHandCursor = false;
        bZoomOut_dis.useHandCursor = false;

        bZoomIn_dis.visible = false;
        bZoomOut_dis.visible = false;

        bZoomIn.addEventListener(MouseEvent.CLICK, bZoomIn_clickHandler);
        bZoomOut.addEventListener(MouseEvent.CLICK, bZoomOut_clickHandler);
    }

    public function update_zoom_in_and_out_buttons_state():void {
        var zoom_in_enabled:Boolean = ss.scale_level > 0;
        var zoom_out_enabled:Boolean = ss.scale_level < PlanetsSystem.MAX_SCALE_LEVEL;

        bZoomIn.visible = zoom_in_enabled;
        bZoomIn_dis.visible = !zoom_in_enabled;
        bZoomOut.visible = zoom_out_enabled;
        bZoomOut_dis.visible = !zoom_out_enabled;
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

        _current_info = new InfoPanel('KioArial', true, 14, 0xFFFFFF, 0xFFFFFF, 0xFFFF00, 1.2, 'Текущие', labels, 160);
        _closest_info = new InfoPanel('KioArial', true, 14, 0xFFFFFF, 0xFFFFFF, 0xFFFF00, 1.2, 'Максимальное сближение', labels, 160);
        _closest_record = new InfoPanel('KioArial', true, 14, 0xFFFFFF, 0xFFFFFF, 0xFFFF00, 1.2, 'Рекорд', labels, 160);

//        addChild(_current_info);
//        addChild(_closest_info);
//        addChild(_closest_record);

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

    public function get solution():Object {
        var s:Array = [];

        for each (var o:Orbit in ss.orbits)
            s.push(o.ind, o.phi);

        return {s: s};
    }

    public function set solution(s:Object):void {
        if (!s || !s.s)
            return;
        var a:Array = s.s;
        for (var i:int = 0; i < a.length; i += 2) {
            var orbit:Orbit = Orbit.createOrbitByInitial(Vector2D.createPolar(
                    ss.all_orbits[a[i]].o.a, Math.PI / 180 * a[i + 1]
            ));
            orbit.ind = a[i];
            orbit.phi = a[i + 1];
            ss.setOrbitForBody(ss.bodies[i / 2], orbit);
        }
    }

//    public function resultForDay(day:int)
    public function get api():KioApi {
        return _api;
    }

    private function api_recordHandler(event:Event):void {
        //TODO
    }

    private function bZoomIn_clickHandler(event:MouseEvent):void {
        ss.scale_level -= 1;
        update_zoom_in_and_out_buttons_state();
    }

    private function bZoomOut_clickHandler(event:MouseEvent):void {
        ss.scale_level += 1;
        update_zoom_in_and_out_buttons_state();
    }

    public function updatePlanetsInfo():void {
        for (var i:int = 0; i < Consts.planets_names.length; i++) {
//            var realOrbit:Orbit = Orbit.createOrbitByInitial(Vector2D.createPolar(
//                    Consts.AU * Consts.planets_orbits[i], Math.PI / 180 * Consts.planets_phis[i]
//            ));
//            var realDaysRotate:int = Math.round(realOrbit.circleTime / 60 / 60 / 24);
            var userDaysRotate:int = days_in_orbit(ss.orbits[i]);

            var diff:int = time_shift_in_orbit(ss.orbits[i]) - Consts.planets_phis[i];

            planetInfos[i].setValue(0, userDaysRotate);
            planetInfos[i].setValue(1, diff);
        }
    }

    private static function time_shift_in_orbit(orbit:Orbit):Number {
        return Math.round(orbit.theta0 / Math.PI * 180);
    }

    private static function days_in_orbit(orbit:Orbit):Number {
        return Math.round(orbit.circleTime / 60 / 60 / 24);
    }

    public function get result():Object {
        //count planets on their orbits
        var right_orbit:int = 0;
        var time_shift:int = 0;
        for (var i:int = 0; i < Consts.planets_names.length - 1; i++) {
            if (days_in_orbit(ss.orbits[i]) == answer_year_days[i])
                right_orbit++;
            time_shift += Math.abs(time_shift_in_orbit(ss.orbits[i]) - Consts.planets_phis[i]);
        }

        return {
            'o': right_orbit,
            's': time_shift
        };
    }

    public function viewsUpdated():void {
        _api.submitResult(result);
        _api.autoSaveSolution();
    }
}
}

// добавить точку, если корабль вне экрана
// показывать скорость планет сразу
// показывать нулевой вектор импульса сразу
// нарисовать планеты и корабль
// что с 1-ой космической? Какой импульс разрешить? Наверное, 5 км/c.
//    11880 минимальный начальный импульс, 28440 уже как бы есть сразу. Надо минимум 40320