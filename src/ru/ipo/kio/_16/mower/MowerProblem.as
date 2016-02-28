package ru.ipo.kio._16.mower {

import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class MowerProblem implements KioProblem {

    [Embed(source="loc/mower.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;

    [Embed(source="res/statement.jpg")]
    public static var STATEMENT_CLASS:Class;

    [Embed(source="res/help.jpg")]
    public static var HELP_CLASS:Class;

//    [Embed(source="res/Cov_Stone-0.jpg")]
//    public static var ICON_0_CLASS:Class;
//
//    [Embed(source="res/Cov_Stone-1.jpg")]
//    public static var ICON_1_CLASS:Class;
//
//    [Embed(source="res/Cov_Stone-2.jpg")]
//    public static var ICON_2_CLASS:Class;

    public static const ID:String = 'mower';

    private var _level:int;
    private var workspace:MowerWorkspace;

    public function MowerProblem(level: int) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);

        workspace = new MowerWorkspace(this);
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
        if (r1 == null && r2 == null)
            return 0;
        if (r1 == null)
            return 1;
        if (r2 == null)
            return -1;

        var d:int = r1.m - r2.m;
        if (d != 0)
            return d;
        d = r2.s - r1.s;
        return d;
    }

    public function get icon():Class {
        return null;
    }

    public function get icon_help():Class {
        return HELP_CLASS;
    }

    public function get icon_statement():Class {
        return STATEMENT_CLASS;
    }

    public function clear():void {
        loadSolution(workspace.empty_solution);
    }
}
}
