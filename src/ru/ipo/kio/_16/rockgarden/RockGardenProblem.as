package ru.ipo.kio._16.rockgarden {

import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class RockGardenProblem implements KioProblem {

    [Embed(source="loc/traincars.ru.json-settings", mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;

    public static const ID:String = 'rockgarden';

    private var _level:int;
    private var workspace:RockGardenWorkspace;

    public function RockGardenProblem(level:int) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);

        workspace = new RockGardenWorkspace(this);
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 2016;
    }

    public function get level():int {
        return _level;
    }

    public function get display():DisplayObject {
        return workspace;
    }

    public function get solution():Object {
        return {c: workspace.circles};
    }

    public function loadSolution(solution:Object):Boolean {
        if (solution == null)
            clear();
        workspace.circles = solution.c;
        return true;
    }

    public function compare(r1:Object, r2:Object):int {
        if (r1.err && r2.err)
            return 0;
        if (r1.err)
            return -1;
        if (r2.err)
            return 1;

        var d:int;
        if (level == 0 || level == 1) {
            d = r1.r - r2.r; //6 rocks visible
            if (d != 0)
                return d;
            d = r1.d - r2.d; // rocks visib
            if (d != 0)
                return d;
            d = r2.s - r1.s;
            return d;
        } else {
            d = r2.i - r1.i; //6 rocks visible
            if (d != 0)
                return d;
            var dd:Number = r2.s - r1.s;
            if (dd < 0)
                return -1;
            else if (dd > 0)
                return 1;
            else
                return 0;
        }
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
