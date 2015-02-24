/**
 * Created by ilya on 25.01.15.
 */
package ru.ipo.kio._15.spider {

import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class SpiderProblem implements KioProblem {

    public static const ID:String = 'spider';

    private var _level:int;
    private var workspace:SpiderWorkspace;

    [Embed(source="loc/spider.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;
    [Embed(source="loc/spider.en.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_EN:Class;
    [Embed(source="loc/spider.th.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_TH:Class;

    public static const ROUND_SECONDS_UP:Boolean = true;

    public function SpiderProblem(level: int) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);
        KioApi.registerLocalization(ID, KioApi.L_EN, new Settings(LOCALIZATION_EN).data);
        KioApi.registerLocalization(ID, KioApi.L_TH, new Settings(LOCALIZATION_TH).data);

        workspace = new SpiderWorkspace(this);
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
        return workspace.solution;
    }

    public function loadSolution(solution:Object):Boolean {
        return workspace.loadSolution(solution);
    }

    public function compare(r1:Object, r2:Object):int {
        if (!r1.ok && !r2.ok)
            return 0;
        if (!r1.ok)
            return -1;
        if (!r2.ok)
            return 1;

        var t1:Number = ROUND_SECONDS_UP ? Math.ceil(r1.t) : r1.t;
        var t2:Number = ROUND_SECONDS_UP ? Math.ceil(r2.t) : r2.t;

        if (t1 < t2)
            return 1;
        if (t1 > t2)
            return -1;

        //now compare material
        if (r1.m < r2.m)
            return 1;
        if (r1.m > r2.m)
            return -1;

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
        workspace.clear();
    }
}
}
