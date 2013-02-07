package ru.ipo.kio._13.blocks {

import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class BlocksProblem implements KioProblem {

    [Embed(source="loc/blocks.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;

    public static const ID:String = "blocks";

    private var _workspace:BlocksWorkspace;

    private var _level:int;

    public function BlocksProblem(level:int) {
        _level = level;
        KioApi.initialize(this);
        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);
        _workspace = new BlocksWorkspace();
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
        //TODO implement
        return null;
    }

    public function loadSolution(solution:Object):Boolean {
        //для загрузки решения нужно взять поле txt и записать его в текстовое поле
        if (solution.txt) {
            //не забыть сохранить решение, как обычно после того как оно изменилось
            KioApi.instance(ID).autoSaveSolution();
            //не забыть как обычно после изменения решения пересчитать текущий результат
            KioApi.instance(ID).submitResult(_workspace.currentResult());
            //Если текущий результат еще и показывается где-то на экране, его тоже надо пересчитать
            //TODO это все должно происходить автоматически

            return true;
        } else
            return false;
    }

    public function check(solution:Object):Object {
        loadSolution(solution);
        return _workspace.currentResult();
    }

    public function compare(solution1:Object, solution2:Object):int {
        return solution1.length - solution2.length;
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