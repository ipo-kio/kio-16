package ru.ipo.kio._16.rockgarden {

import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class RockGardenProblem implements KioProblem {

    [Embed(source="loc/traincars.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;

    public static const ID:String = 'rockgarden';

    private var _level:int;
    private var workspace:RockGardenWorkspace;

    public function RockGardenProblem(level: int) {
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