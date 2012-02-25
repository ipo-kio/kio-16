/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 11.02.12
 * Time: 23:52
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond {
import ru.ipo.kio._12.diamond.model.Spectrum;
import ru.ipo.kio._12.diamond.view.*;

import flash.display.DisplayObject;

import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._12.diamond.model.Diamond;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

//TODO дискретные лучи (?)
//TODO дискретные точки (?)

public class DiamondProblem extends Sprite implements KioProblem {

    [Embed(
            source='resources/Hermes Normal.ttf',
            embedAsCFF = "false",
            fontWeight = "bold",
            fontName="KioDiamond",
            mimeType="application/x-font-truetype",
            unicodeRange = "U+0000-U+FFFF"
            )]
    private static var DIAMOND_FONT:Class;

    [Embed(source="loc/Diamond.ru.json-settings",mimeType="application/octet-stream")]
    public static var DIAMOND_RU:Class;

    public static const ID:String = 'diamond';

    private var _level:int = 1;
    private var api:KioApi;
    private var eye:Eye;
    private var diamond:Diamond;
    
    private var current_ray_info:InfoField;
    private var current_info:InfoField;

    public function DiamondProblem(level:int) {
        _level = level;

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(DIAMOND_RU).data);

        KioApi.initialize(this);

        api = KioApi.instance(ID);

        init();
    }

    private function init(e:Event = null):void {
        diamond = new Diamond();
        diamond.addVertex(new Vertex2D(20, 10));
        diamond.addVertex(new Vertex2D(30, -15));
        diamond.addVertex(new Vertex2D(40, 5));
        diamond.addVertex(new Vertex2D(50, -10));

        eye = new Eye(diamond);

        addChild(eye);

        var spectrumView:SpectrumView = new SpectrumView(diamond, eye);
        spectrumView.x = 0;
        spectrumView.y = eye.height;//eye.getBounds(this).bottom;
        addChild(spectrumView);

        //current ray info
        current_ray_info = new InfoField(
                'Информация о луче',
                ['Средняя яркость', 'Дисперсия цвета'],
                2
        );
        current_ray_info.x = 0;
        current_ray_info.y = spectrumView.y + spectrumView.height + 2;
        addChild(current_ray_info);

        eye.addEventListener(Eye.ANGLE_CHANGED, ray_moved);
        diamond.addEventListener(Diamond.UPDATE, ray_moved);
        ray_moved(null);

        //current info
        current_info = new InfoField(
                'Текущий результат',
                ['Усредненная яркость', 'Средняя дисперсия'],
                2
        );
        current_info.x = 0;
        current_info.y = current_ray_info.y + current_ray_info.height + 2;
        addChild(current_info);
        diamond.addEventListener(Diamond.UPDATE, update_current_info);
        update_current_info(null);
    }

    private function update_current_info(event:Event):void {
        current_info.set_values([diamond.spectrum.mean_light, diamond.spectrum.mean_disp]);
    }

    private function ray_moved(event:Event):void {
        var cols:Array = Spectrum.color_ray(eye.angle, diamond);
        var mn:Number = Spectrum.mean(cols);
        var vr:Number = Spectrum.variance(cols);
        
        current_ray_info.set_values([mn, vr]);
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 2012;
    }

    public function get level():int {
        return _level;
    }

    public function get display():DisplayObject {
        return this;
    }

    public function get solution():Object {
        return {};
    }

    public function get best():Object {
        return {};
    }

    public function loadSolution(solution:Object):Boolean {
        return true;
    }

    public function check(solution:Object):Object {
        return {};
    }

    public function compare(solution1:Object, solution2:Object):int {
        return 0;
    }

    public function get icon():Class {
        return null;
    }

    public function get icon_help():Class {
        return null;
    }
}
}
