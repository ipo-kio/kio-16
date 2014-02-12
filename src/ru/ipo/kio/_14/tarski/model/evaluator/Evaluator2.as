/**
 * @author: Vasily Akimushkin
 * @since: 11.02.14
 */
package ru.ipo.kio._14.tarski.model.evaluator {
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.TarskiSprite;

import ru.ipo.kio._14.tarski.model.Configuration;
import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;
import ru.ipo.kio._14.tarski.model.quantifiers.Quantifier;

public class Evaluator2 implements Evaluator{
    public function Evaluator2() {
    }

    public function checkExample(_logicResulted:LogicEvaluatedItem,configuration:Configuration):void {
        var res:Boolean =  _logicResulted.evaluateWithQuants(new Dictionary(), configuration.getListFigure());
        configuration.correct = res;
        //firstEvaluatingAttempt(_logicResulted, configuration);
    }

    private function firstEvaluatingAttempt(_logicResulted:LogicEvaluatedItem, configuration:Configuration):void {
        var dict:Dictionary = _logicResulted.collectFormalOperand();
        var size:int = 0;
        var first:Object = null;
        var second:Object = null;
        var third:Object = null;

        for (var kk:Object in dict) {
            if (size == 0) {
                first = kk;
            }
            if (size == 1) {
                second = kk;
            }
            if (size == 2) {
                third = kk;
            }
            size++;
        }

        var figures:Vector.<Figure> = configuration.getListFigure();

        var data:Dictionary = new Dictionary();
        if (size == 1) {
            configuration.correct = checkOne(first, figures, data, _logicResulted);
        } else if (size == 2) {
            configuration.correct = checkTwo(first, second, figures, data, _logicResulted);
        } else if (size == 3) {
            configuration.correct = checkThree(first, second, third, figures, data, _logicResulted);
        }
    }


    private function checkThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        var firstExists:Boolean = isOnlyExists(first+"");
        var secondExists:Boolean = isOnlyExists(second+"");
        var thirdExists:Boolean = isOnlyExists(third+"");

        if(firstExists && secondExists && thirdExists){
            return checkSingleThree(first, second, third, figures, data, _logicResulted);
        }else if (!firstExists && ! secondExists && ! thirdExists){
            return checkAllThree(first, second, third, figures, data, _logicResulted);
        }else{
            if(firstExists && !secondExists && !thirdExists){
                checkSingleAllAllThree(first, second, third, figures, data, _logicResulted);
            }else if (secondExists && !firstExists && !thirdExists){
                checkSingleAllAllThree(second, first, third, figures, data, _logicResulted);
            }else if (thirdExists && !firstExists && !secondExists){
                checkSingleAllAllThree(third, first, second, figures, data, _logicResulted);
            }


            if(!firstExists && secondExists && thirdExists){
                checkSingleSingleAllThree(second, third, first, figures, data, _logicResulted);
            }else if(!secondExists && firstExists && thirdExists){
                checkSingleSingleAllThree(first, third, second, figures, data, _logicResulted);
            }else if(!thirdExists && firstExists && secondExists){
                checkSingleSingleAllThree(first, second, third, figures, data, _logicResulted);
            }
        }

        return false;
    }

    private function checkSingleSingleAllThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        for(var i:int=0;i<figures.length;i++){
            for(var j:int=0;j<figures.length;j++){
                var allCheck:Boolean=true;
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        data[first]=figures[i];
                        data[second]=figures[j];
                        data[third]=figures[k];
                        allCheck=allCheck&&_logicResulted.evaluate(data);
                    }
                }
                if(allCheck){
                    return true;
                }
            }
        }
        return false;
    }

    private function checkSingleAllAllThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        for(var i:int=0;i<figures.length;i++){
            var allCheck:Boolean=true;
            for(var j:int=0;j<figures.length;j++){
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        data[first]=figures[i];
                        data[second]=figures[j];
                        data[third]=figures[k];
                        allCheck=allCheck&&_logicResulted.evaluate(data);
                    }
                }
            }
            if(allCheck){
                return true;
            }
        }
        return false;
    }


    private function checkSingleThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        for(var i:int=0;i<figures.length;i++){
            for(var j:int=0;j<figures.length;j++){
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        data[first]=figures[i];
                        data[second]=figures[j];
                        data[third]=figures[k];
                        if(_logicResulted.evaluate(data)){
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }


    private function checkAllThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        var allCheck:Boolean=true;
        for(var i:int=0;i<figures.length;i++){
            for(var j:int=0;j<figures.length;j++){
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        data[first]=figures[i];
                        data[second]=figures[j];
                        data[third]=figures[k];
                        allCheck=allCheck&&_logicResulted.evaluate(data);
                    }
                }
            }
        }
        return allCheck;
    }



    private function checkTwo(first:Object, second:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        var firstExists:Boolean = isOnlyExists(first+"");
        var secondExists:Boolean = isOnlyExists(second+"");

        if(firstExists && secondExists){
            return checkSingleTwo(first, second, figures, data, _logicResulted);
        }else if (!firstExists && ! secondExists){
            return checkAllTwo(first, second, figures, data, _logicResulted);
        }else{
             if(firstExists){
                 return checkSingleAllTwo(first, second, figures, data, _logicResulted);
             }else{
                 return checkSingleAllTwo(second, first, figures, data, _logicResulted);
             }
        }
    }

    private function checkSingleAllTwo(first:Object, second:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        for(var i:int=0;i<figures.length;i++){
            var allCheck:Boolean=true;
            for(var j:int=0;j<figures.length;j++){
                if(i!=j){
                    data[first]=figures[i];
                    data[second]=figures[j];
                    var currentCheck:Boolean = _logicResulted.evaluate(data);
                    allCheck=allCheck&&currentCheck;
                }
            }
            if(allCheck){
                return true;
            }
        }
        return false;
    }


    private function checkAllTwo(first:Object, second:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        var allCheck:Boolean=true;
        for(var i:int=0;i<figures.length;i++){
            for(var j:int=0;j<figures.length;j++){
                if(i!=j){
                    data[first]=figures[i];
                    data[second]=figures[j];
                    var currentCheck:Boolean = _logicResulted.evaluate(data);
                    allCheck=allCheck&&currentCheck;
                }
            }
        }
        return allCheck;
    }

    private function checkSingleTwo(first:Object, second:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        for(var i:int=0;i<figures.length;i++){
            for(var j:int=0;j<figures.length;j++){
                if(i!=j){
                    data[first]=figures[i];
                    data[second]=figures[j];
                    if(_logicResulted.evaluate(data)){
                        return true;
                    }
                }
            }
        }
        return false;
    }


    private function checkOne(first:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        if(isOnlyExists(first+"")){
            return checkSingleOne(first, figures, data, _logicResulted);
        }else{
            return checkAllOne(first, figures, data, _logicResulted);
        }
    }

    private function checkAllOne(first:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        var allCheck:Boolean=true;
        for (var i:int = 0; i < figures.length; i++) {
            data[first] = figures[i];
            var currentCheck:Boolean = _logicResulted.evaluate(data);
            allCheck = allCheck && currentCheck;
        }
        return allCheck;
    }


    private function checkSingleOne(first:Object, figures:Vector.<Figure>, data:Dictionary, _logicResulted:LogicEvaluatedItem):Boolean {
        for (var i:int = 0; i < figures.length; i++) {
            data[first] = figures[i];
            if(_logicResulted.evaluate(data)){
                return true;
            }

        }
        return false;
    }



    private function isOnlyExists(code:String):Boolean {
        var logicItems:Vector.<LogicItem> = TarskiSprite.instance.statement.logicItems;
        for (var i:int = 0; i < logicItems.length; i++) {
            if (logicItems[i] is Quantifier) {
                if (Quantifier(logicItems[i]).placeHolder.variable.code == code) {
                    return true;
                }
            }
        }
        return false;
    }
}
}
