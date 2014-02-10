/**
 * Created by user on 07.02.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.DisplayObject;

import ru.ipo.kio._14.stars.StarsWorkspace;
import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;

public class StarsProblem implements KioProblem {

    public static const ID:String = "stars";

    private var _workspace:StarsWorkspace;

    private var _level:int;

    public function StarsProblem(level:int) {
        _level = level;

        KioApi.initialize(this);

        _workspace = new StarsWorkspace(this);
    }

    public function get id():String {
        return "";
    }

    public function get year():int {
        return 2014;
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

    public function get best():Object {
        return null;
    }

    public function loadSolution(solution:Object):Boolean {
        if (_workspace.load(solution) == null)
            return false;

        KioApi.instance(this).autoSaveSolution();
        KioApi.instance(this).submitResult(_workspace.currentResult());
        return true;
    }

    public function check(solution:Object):Object {
        loadSolution(solution);
        return _workspace.currentResult();
    }

    public function compare(solution1:Object, solution2:Object):int {
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
}
}
