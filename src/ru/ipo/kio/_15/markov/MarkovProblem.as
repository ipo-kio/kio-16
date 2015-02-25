package ru.ipo.kio._15.markov {
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
        RuleManager.instance.submitResult(workspace.workingRidge, workspace.correctRidge);
        RuleManager.instance.deselect();
        workspace.deselect();
        return true;
    }

    public function compare(r1:Object, r2:Object):int {
        if (!r1){
            return r2 ? -1 : 0;
        } else if (!r2){
            return 1;
        }

        if(RuleManager.instance.level==0){
            if(r1.ridgeDiff!=r2.ridgeDiff){
                return getSign(r2.ridgeDiff-r1.ridgeDiff);
            }else if(r1.ruleAmount!=r2.ruleAmount){
                return getSign(r2.ruleAmount-r1.ruleAmount);
            }else{
                return getSign(r2.applyOperations-r1.applyOperations);
            }
        }

        if(RuleManager.instance.level==2){
            if(r1.correctAmount!=r2.correctAmount){
                return getSign(r1.correctAmount-r2.correctAmount);
            }else if(r1.ruleAmount!=r2.ruleAmount){
                return getSign(r2.ruleAmount-r1.ruleAmount);
            }else{
                return getSign(r2.ruleLength-r1.ruleLength);
            }
        }

        if(RuleManager.instance.level==1){
            if(r1.wrongPair!=r2.wrongPair){
                return getSign(r2.wrongPair-r1.wrongPair);
            }else if(r1.ruleAmount!=r2.ruleAmount){
                return getSign(r2.ruleAmount-r1.ruleAmount);
            }else{
                return getSign(r2.applyOperations-r1.applyOperations);
            }
        }

       return 0;
    }

   private function getSign(i:Number):int {
            return i>0?1:i<0?-1:0;
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
