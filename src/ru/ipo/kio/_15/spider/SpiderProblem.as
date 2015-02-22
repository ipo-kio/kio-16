/**
 * Created by ilya on 25.01.15.
 */
package ru.ipo.kio._15.spider {
import ru.ipo.kio._15.traincars.*;

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

    public function SpiderProblem(level: int) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);
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
        return null;
    }

    public function loadSolution(solution:Object):Boolean {
        return false;
    }

    public function compare(r1:Object, r2:Object):int {
        if (!r1.ok && !r2.ok)
            return 0;
        if (!r1.ok)
            return -1;
        if (!r2.ok)
            return 1;

        if (r1.t < r2.t)
            return 1;
        if (r1.t > r2.t)
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
//        workspace.clear();
        //TODO implement
    }
}
}
