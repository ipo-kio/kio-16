package ru.ipo.kio._16.mars {

import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;

import ru.ipo.kio._16.mars.MarsWorkspace;

import ru.ipo.kio._16.mars.model.Consts;
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

    [Embed(source="res/bg.png")]
    public static const BG_CLASS:Class;

    public static const TOTAL_CIRCLES:int = 7;

    private var background:Sprite = new Sprite();

    private var _problem:KioProblem;
    private var _api:KioApi;

    private var ss:PlanetsSystem;
    private var timeSlider:Slider;

    /*
     private var bAdd:GraphicsButton = 
     private var bRemove:GraphicsButton = new GraphicsButton('', [BUTTON_1_BMP, BUTTON_PLUS_BMP], [BUTTON_2_BMP, BUTTON_PLUS_BMP], [BUTTON_1_BMP, BUTTON_PLUS_BMP], '', 10, 10);
     private var bAdd_dis:GraphicsButton = new GraphicsButton('', [BUTTON_3_BMP, BUTTON_PLUS_BMP], [BUTTON_3_BMP, BUTTON_PLUS_BMP], [BUTTON_3_BMP, BUTTON_PLUS_BMP], '', 10, 10);
     private var bRemove_dis:GraphicsButton = new GraphicsButton('', [BUTTON_3_BMP, BUTTON_PLUS_BMP], [BUTTON_3_BMP, BUTTON_PLUS_BMP], [BUTTON_3_BMP, BUTTON_PLUS_BMP], '', 10, 10);
     */
    private var bZoomIn:GraphicsButton = new GraphicsButton('', [MarsWorkspace.BUTTON_1_BMP, MarsWorkspace.BUTTON_PLUS_BMP], [MarsWorkspace.BUTTON_2_BMP, MarsWorkspace.BUTTON_PLUS_BMP], [MarsWorkspace.BUTTON_1_BMP, MarsWorkspace.BUTTON_PLUS_BMP], '', 10, 10);
    private var bZoomOut:GraphicsButton = new GraphicsButton('', [MarsWorkspace.BUTTON_1_BMP, MarsWorkspace.BUTTON_MINUS_BMP], [MarsWorkspace.BUTTON_2_BMP, MarsWorkspace.BUTTON_MINUS_BMP], [MarsWorkspace.BUTTON_1_BMP, MarsWorkspace.BUTTON_MINUS_BMP], '', 10, 10);
    private var bZoomIn_dis:GraphicsButton = new GraphicsButton('', [MarsWorkspace.BUTTON_3_BMP, MarsWorkspace.BUTTON_PLUS_BMP], [MarsWorkspace.BUTTON_3_BMP, MarsWorkspace.BUTTON_PLUS_BMP], [MarsWorkspace.BUTTON_3_BMP, MarsWorkspace.BUTTON_PLUS_BMP], '', 10, 10);
    private var bZoomOut_dis:GraphicsButton = new GraphicsButton('', [MarsWorkspace.BUTTON_3_BMP, MarsWorkspace.BUTTON_MINUS_BMP], [MarsWorkspace.BUTTON_2_BMP, MarsWorkspace.BUTTON_MINUS_BMP], [MarsWorkspace.BUTTON_3_BMP, MarsWorkspace.BUTTON_MINUS_BMP], '', 10, 10);

    private var _info_panel:InfoPanel;
    private var _record_panel:InfoPanel;

    private var planetInfos:Vector.<InfoPanel>;
    private var answer_year_days:Vector.<int>;

    public function PlanetsWorkspace(problem:KioProblem) {
//        trace(Orbit.solveKeplerEquation(2.8453268117053505, 0.5084113241345426)); //newtown fails here

        _problem = problem;
        _api = KioApi.instance(problem);

        _api.addEventListener(KioApi.RECORD_EVENT, api_recordHandler);

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

        init_planets_info();

        update_current_info();
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
                        'Год',
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
            "На правильной орбите",
            "Неправильное время"
        ];

        _info_panel = new InfoPanel('KioArial', true, 14, 0xFFFFFF, 0xFFFFFF, 0xFFFF00, 1.2, 'Результат', labels, 200);
        _record_panel = new InfoPanel('KioArial', true, 14, 0xFFFFFF, 0xFFFFFF, 0xFFFF00, 1.2, 'Рекорд', labels, 200);

        addChild(_info_panel);
        addChild(_record_panel);

        _info_panel.x = 564;
        _record_panel.x = _info_panel.x;

        _info_panel.y = 460;
        _record_panel.y = _info_panel.y + _info_panel.height;
    }

    private function slider_value_changedHandler(event:Event):void {
        ss.time = timeSlider.valueRounded;

        update_current_info();
    }

    private function update_current_info():void {
        update_info(_info_panel, result);
    }

    private static function update_info(infoPanel:InfoPanel, result:Object):void {
        infoPanel.setValue(0, result.o);
        infoPanel.setValue(1, result.s);
    }

    public function get solution():Object {
        var s:Array = [];

        for each (var o:Orbit in ss.orbits)
            s.push(o.ind, o.phi);

        return {s: s};
    }

    public function set solution(s:Object):void {
        return;
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

        update_current_info();
        _api.submitResult(result);
    }

//    public function resultForDay(day:int)
    public function get api():KioApi {
        return _api;
    }

    private function api_recordHandler(event:Event):void {
        update_info(_record_panel, result);
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

            var diff:int = time_shift_in_orbit(ss.orbits[i]);
            if (diff < 0)
                diff += 360;

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
        var earth:int = 2;

        //count planets on their orbits
        var right_orbit:int = 0;
        var time_shift:int = 0;
        for (var i:int = 0; i < Consts.planets_names.length; i++) {
            if (days_in_orbit(ss.orbits[i]) == answer_year_days[i])
                right_orbit++;

            var shift:int = time_shift_in_orbit(ss.orbits[i]) - time_shift_in_orbit(ss.orbits[earth]);
            var needShift:int = Consts.planets_phis[i] - Consts.planets_phis[earth];
            var d:int = Math.abs(shift - needShift);

            if (_problem.level == 0)
                time_shift += d;
            if (_problem.level == 1 && time_shift < d)
                time_shift = d;
        }

        return {
            'o': right_orbit,
            's': time_shift
        };
    }

    public function viewsUpdated():void {
        _api.submitResult(result);
        _api.autoSaveSolution();
        update_current_info();
    }
}
}

// добавить точку, если корабль вне экрана
// показывать скорость планет сразу
// показывать нулевой вектор импульса сразу
// нарисовать планеты и корабль
// что с 1-ой космической? Какой импульс разрешить? Наверное, 5 км/c.
//    11880 минимальный начальный импульс, 28440 уже как бы есть сразу. Надо минимум 40320