package ru.ipo.kio._16.mars {

import flash.display.DisplayObject;

import ru.ipo.kio._16.mars.model.MarsResult;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class MarsProblem implements KioProblem {

    [Embed(source="loc/mars.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;

    public static const ID:String = 'mars';

    private var _level:int;
    private var workspace:*;

    public function MarsProblem(level: int) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);

        workspace = level < 2 ? new PlanetsWorkspace(this) : new MarsWorkspace(this);
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
        return workspace.solution;
    }

    public function loadSolution(solution:Object):Boolean {
        if (solution == null)
            clear();
        workspace.solution = solution;
        return true;
    }

    public function compare(r1:Object, r2:Object):int {
        var mr1:MarsResult = MarsResult.create_from_object(r1);
        var mr2:MarsResult = MarsResult.create_from_object(r2);

        return mr1.compareTo(mr2);
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
        loadSolution({a: []});
    }
}
}
