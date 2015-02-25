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

    [Embed(source="resources/icon-cars.png")]
    public static const ICON_CARS:Class;

    [Embed(source="resources/statement.png")]
    public static const STATEMENT_IMG:Class;

    [Embed(source="resources/help.png")]
    public static const HELP_IMG:Class;

    public static const ID:String = 'traincars';

    private var _level:int;
    private var workspace:TrainCarsWorkspace;

    public function TrainCarsProblem(level: int) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);
        KioApi.registerLocalization(ID, KioApi.L_TH, new Settings(LOCALIZATION_TH).data);

        workspace = new TrainCarsWorkspace(this);
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
        return workspace.solution();
    }

    public function loadSolution(solution:Object):Boolean {
        return workspace.loadSolution(solution);
    }

    public function compare(r1:Object, r2:Object):int {
        var v:int;
        v = r1.c - r2.c;
        if (v != 0)
            return v;

        v = r2.t - r1.t;
        if (v != 0)
            return v;

        if (level > 0) {
            v = r2.uh - r1.uh;
            if (v != 0)
                return v;
            v = r2.dh - r1.dh;
            if (v != 0)
                return v;

            return 0;
        } else {
            v = r2.h - r1.h;
            return v;
        }
    }

    public function get icon():Class {
        return ICON_CARS;
    }

    public function get icon_help():Class {
        return HELP_IMG;
    }

    public function get icon_statement():Class {
        return STATEMENT_IMG;
    }

    public function clear():void {
        workspace.clear();
    }
}
}
