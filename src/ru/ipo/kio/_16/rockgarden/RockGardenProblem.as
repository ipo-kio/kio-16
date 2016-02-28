package ru.ipo.kio._16.rockgarden {

import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class RockGardenProblem implements KioProblem {

    [Embed(source="loc/rockgarden.ru.json-settings", mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;

    [Embed(source="res/statement.jpg")]
    public static var STATEMENT_CLASS:Class;

    [Embed(source="res/help.jpg")]
    public static var HELP_CLASS:Class;

    [Embed(source="res/Cov_Stone-0.jpg")]
    public static var ICON_0_CLASS:Class;

    [Embed(source="res/Cov_Stone-1.jpg")]
    public static var ICON_1_CLASS:Class;

    [Embed(source="res/Cov_Stone-2.jpg")]
    public static var ICON_2_CLASS:Class;

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
        return workspace.solution;
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
            d = r1.s - r2.s;
            return d;
        } else {
            d = r1.p - r2.p;
            if (d != 0)
                return d;

            var dd:Number = r2.v - r1.v;
            if (dd < 0)
                return -1;
            else if (dd > 0)
                return 1;
            else
                return 0;
        }
    }

    public function get icon():Class {
        switch (level) {
            case 0:
                return ICON_0_CLASS;
            case 1:
                return ICON_1_CLASS;
            case 2:
                return ICON_2_CLASS;
        }
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
