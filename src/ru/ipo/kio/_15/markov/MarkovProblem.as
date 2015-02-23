package ru.ipo.kio._15.markov {
import ru.ipo.kio._15.traincars.*;

import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class MarkovProblem implements KioProblem {

    [Embed(source="loc/markov.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;

    public static const ID:String = 'markov';

    private var _level:int;

    private var _workspace:MarkovWorkspace;

    public function MarkovProblem(level: int) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);


        _workspace = new MarkovWorkspace(this, level);
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 2015;
    }

    public function get level():int {
        return _level;
    }


    public function get workspace():MarkovWorkspace {
        return _workspace;
    }

    public function get display():DisplayObject {
        return _workspace;
    }

    public function get solution():Object {
        var result = {};
        result.rules = [];
        for each(var rule:Rule in RuleManager.instance.rules){
            result.rules.push(rule.toCode());
        }
        return result;
     }

    public function loadSolution(solution:Object):Boolean {
        RuleManager.instance.rules=  new Vector.<Rule>();
        for each(var rule:String in solution.rules){
            var r:Rule = new Rule(RuleManager.instance.rules.length);
            r.load(rule);
           RuleManager.instance.rules.push(r);
            workspace.update();
        }
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
        RuleManager.instance.rules=new Vector.<Rule>();
        workspace.update();
    }
}
}
