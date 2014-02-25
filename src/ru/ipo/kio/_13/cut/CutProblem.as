package ru.ipo.kio._13.cut {

import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

/**
 * Пример задачи. Этот файл описывает задачу, он практически не содержит логики работы с задачей, а только выдает информацию по ней для системы.
 * @author Ilya
 */
public class CutProblem implements KioProblem {

    [Embed(source="loc/cut.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;
    [Embed(source="loc/cut.es.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_ES:Class;
    [Embed(source="loc/cut.en.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_EN:Class;
    [Embed(source="loc/cut.bg.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_BG:Class;
    [Embed(source="loc/cut.th.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_TH:Class;

    public static const ID:String = "cut";

    private var _workspace:CutWorkspace;

    private var _level:int;

    public function CutProblem(level:int) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);
        KioApi.registerLocalization(ID, KioApi.L_ES, new Settings(LOCALIZATION_ES).data);
        KioApi.registerLocalization(ID, KioApi.L_EN, new Settings(LOCALIZATION_EN).data);
        KioApi.registerLocalization(ID, KioApi.L_BG, new Settings(LOCALIZATION_BG).data);
        KioApi.registerLocalization(ID, KioApi.L_TH, new Settings(LOCALIZATION_TH).data);

        _workspace = new CutWorkspace(this);
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 2013;
    }

    public function get level():int {
        return _level;
    }

    public function get display():DisplayObject {
        return _workspace;
    }

    public function get solution():Object {
        return _workspace.solution;
    }

    public function loadSolution(solution:Object):Boolean {
        if (! _workspace.load(solution))
            return false;

        KioApi.instance(this).autoSaveSolution();
        _workspace.updateCurrentResult();

        return true;
    }

    public function check(solution:Object):Object {
        loadSolution(solution);
        return _workspace.currentResult();
    }

    public function compare(solution1:Object, solution2:Object):int {
        var res:int = solution1.polys - solution2.polys;
        if (res == 0)
            res = solution2.pieces - solution1.pieces;
        if (res == 0)
            res = solution2.offcuts - solution1.offcuts;
        return  res;
    }

    [Embed(source="resources/Level_0-Help-3.jpg")]
    public static const HELP_0_CLS:Class;
    [Embed(source="resources/Level_1-Help-3.jpg")]
    public static const HELP_1_CLS:Class;
    [Embed(source="resources/Level_2-Help-3.jpg")]
    public static const HELP_2_CLS:Class;
    [Embed(source="resources/Level_0-Statement-3.jpg")]
    public static const STATEMENT_0_CLS:Class;
    [Embed(source="resources/Level_1-Statement-3.jpg")]
    public static const STATEMENT_1_CLS:Class;
    [Embed(source="resources/Level_2-Statement-3.jpg")]
    public static const STATEMENT_2_CLS:Class;

    [Embed(source="resources/icon.png")]
    public static const ICON_CLS:Class;

    public function get icon():Class {
        return ICON_CLS;
    }

    public function get icon_help():Class {
        switch (level) {
            case 0:
                return HELP_0_CLS;
            case 1:
                return HELP_1_CLS;
            case 2:
                return HELP_2_CLS;
        }
        return null;
    }

    public function get icon_statement():Class {
        switch (level) {
            case 0:
                return STATEMENT_0_CLS;
            case 1:
                return STATEMENT_1_CLS;
            case 2:
                return STATEMENT_2_CLS;
        }
        return null;
    }

    public function get best():Object {
        return null;
    }

    public function clear():void {
        //do nothing
    }
}

}