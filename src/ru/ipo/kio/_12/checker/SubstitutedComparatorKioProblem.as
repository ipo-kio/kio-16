/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 11.04.12
 * Time: 20:50
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.checker {
import flash.display.DisplayObject;

import ru.ipo.kio.api.KioProblem;

public class SubstitutedComparatorKioProblem implements KioProblem {

    private var _problem:KioProblem;
    private var _comparator_index:int;

    public function SubstitutedComparatorKioProblem(problem:KioProblem, comparator_index:int) {
        _problem = problem;
        _comparator_index = comparator_index;
    }

    public function get id():String {
        return _problem.id;
    }

    public function get year():int {
        return _problem.year;
    }

    public function get level():int {
        return _problem.level;
    }

    public function get display():DisplayObject {
        return _problem.display;
    }

    public function get solution():Object {
        return _problem.solution;
    }

    public function get best():Object {
        return _problem.best;
    }

    public function loadSolution(solution:Object):Boolean {
        return _problem.loadSolution(solution);
    }

    public function check(solution:Object):Object {
        return _problem.check(solution);
    }

    public function compare(solution1:Object, solution2:Object):int {
        //substitute comparator
        return _problem['compare' + _comparator_index](solution1, solution2);
    }

    public function get icon():Class {
        return _problem.icon;
    }

    public function get icon_help():Class {
        return _problem.icon_help;
    }

    public function get icon_statement():Class {
        return _problem.icon_statement;
    }
}
}
