/**
 * Created by ilya on 25.01.15.
 */
package ru.ipo.kio._15.traincars {
import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class TrainCarsProblem implements KioProblem {

    [Embed(source="loc/traincars.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;
    [Embed(source="loc/traincars.en.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_EN:Class;
    [Embed(source="loc/traincars.th.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_TH:Class;

    public static const ID:String = 'traincars';

    private var _level:int;
    private var workspace:TrainCarsWorkspace;

    public function TrainCarsProblem(level: int) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);
        KioApi.registerLocalization(ID, KioApi.L_TH, new Settings(LOCALIZATION_TH).data);

        workspace = new TrainCarsWorkspace();
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 2015;
    }

    public function get level():int {
        return _level;
    }

    public function get display():DisplayObject {
        return workspace;
    }

    public function get solution():Object {
        return null;
    }

    public function loadSolution(solution:Object):Boolean {
        return false;
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

    public function get icon_statement():Class {
        return null;
    }

    public function clear():void {

    }
}
}
