/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 26.02.12
 * Time: 19:50
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.futurama {
import flash.display.DisplayObject;

import ru.ipo.kio._12.futurama.view.FuturamaField;
import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class FuturamaProblem implements KioProblem {

    [Embed(source="loc/Futurama.ru.json-settings",mimeType="application/octet-stream")]
    public static var FUTURAMA_RU:Class;

    public static const ID:String = 'id';
    private var _n:int;
    private var _level:int;
    private var _display:FuturamaField;

    public function FuturamaProblem(level:int) {

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(FUTURAMA_RU).data);
        
        KioApi.initialize(this);
        
        _level = level;
        _n = _level == 2 ? 9 : 8;
        _display = new FuturamaField();
    }

    public function get n():int {
        return _n;
    }

//implementation of KIO Problem

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 0;
    }

    public function get level():int {
        return _level;
    }

    public function get display():DisplayObject {
        return _display;
    }

    public function get solution():Object {
        return {};
    }

    public function get best():Object {
        return {};
    }

    public function loadSolution(solution:Object):Boolean {
        return {};
    }

    public function check(solution:Object):Object {
        return null;
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
