/**
 * Created by user on 07.02.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class StarsProblem implements KioProblem {

    //Ссылка на файл с локализацией, в данном случае только русский язык. Если языков больше, необходимо добавить несколько ссылок
    [Embed(source="loc/stars.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;

    [Embed(source="resources/about.jpg")]
    public static const ABOUT:Class;

    [Embed(source="resources/help.png")]
    public static const HELP:Class;

    [Embed(source="resources/icon.png")]
    public static const ICON:Class;

    public static const ID:String = "stars";

    private var _workspace:StarsWorkspace;

    private var _level:int;

    public function StarsProblem(level:int) {
        _level = level;

        KioApi.initialize(this);
        //Регистрация локализации. Программа должна иметь локализацию для каждого из языков,
        //на котором ее предлагается использовать.
        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);

        _workspace = new StarsWorkspace(this);
    }

    public function get id():String {
        return ID;
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
        if (!_workspace.load(solution))
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
        if (solution1.has_intersected_lines && solution2.has_intersected_lines)
            return 0;
        else if (solution1.has_intersected_lines && !solution2.has_intersected_line)
            return -1;
        else if (!solution1.has_intersected_lines && solution2.has_intersected_lines)
            return 1;
        else {
            var res:int = 0;
            if (solution1.total_number_of_difference_graphs == solution2.total_number_of_difference_graphs) {
                if (solution1.total_number_of_right_graphs == solution2.total_number_of_right_graphs)
                    res = solution2.sum_of_lines - solution1.sum_of_lines;
                else
                    res = solution1.total_number_of_right_graphs - solution2.total_number_of_right_graphs;
            } else
                res = solution1.total_number_of_difference_graphs - solution2.total_number_of_difference_graphs;
        }
        return res;
    }

    public function get icon():Class {
        return ICON;
    }

    public function get icon_help():Class {
        return HELP;
    }

    public function get icon_statement():Class {
        return ABOUT;
    }

    public function clear():void {
        loadSolution({lines: []});
    }
}
}
