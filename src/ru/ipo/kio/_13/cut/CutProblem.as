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

    public static const ID:String = "cut";

    private var _workspace:CutWorkspace;

    private var _level:int;

    public function CutProblem(level:int) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);

        _workspace = new CutWorkspace();
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
        if (solution.txt) {
            //TODO load

            KioApi.instance(ID).autoSaveSolution();
            _workspace.updateCurrentResult();

            return true;
        } else
            return false;
    }

    public function check(solution:Object):Object {
        loadSolution(solution);
        return _workspace.currentResult();
    }

    public function compare(solution1:Object, solution2:Object):int {
        var res:int = solution1.polys - solution2.polys;
        if (res == 0)
            res = solution2.pieces - solution1.pieces;
        return  res;
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

    public function get best():Object {
        return null;
    }
}

}