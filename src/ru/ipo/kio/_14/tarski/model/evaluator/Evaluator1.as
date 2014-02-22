/**
 * @author: Vasily Akimushkin
 * @since: 11.02.14
 */
package ru.ipo.kio._14.tarski.model.evaluator {
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.Configuration;
import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;

public class Evaluator1 implements Evaluator{
    public function Evaluator1() {
    }

    public function checkExample(_logicResulted:LogicEvaluatedItem,configuration:Configuration):Boolean {
        var dict:Dictionary = _logicResulted.collectFormalOperand();
        var size:int = 0;
        var first:Object = null;
        var second:Object = null;
        var third:Object = null;

        for (var kk:Object in dict) {
            if(size == 0){
                first=kk;
            }
            if(size == 1){
                second=kk;
            }
            if(size == 2){
                third=kk;
            }
            size++;
        }

        var figures:Vector.<Figure> = configuration.getListFigure();

        var ok:Boolean=true;

        var data:Dictionary = new Dictionary();
        if(size==1){
            for(var i:int=0;i<figures.length;i++){
                data[first]=figures[i];
                ok=ok&&_logicResulted.evaluate(data);
            }
        }else if(size==2){
            for(var i:int=0;i<figures.length;i++){
                for(var j:int=0;j<figures.length;j++){
                    if(i!=j){
                        data[first]=figures[i];
                        data[second]=figures[j];
                        ok=ok&&_logicResulted.evaluate(data);
                    }
                }
            }
        }else if(size==3){
            for(var i:int=0;i<figures.length;i++){
                for(var j:int=0;j<figures.length;j++){
                    for(var k:int=0;k<figures.length;k++){
                        if(i!=j && j!=k){
                            data[first]=figures[i];
                            data[second]=figures[j];
                            data[third]=figures[k];
                            ok=ok&&_logicResulted.evaluate(data);
                        }
                    }
                }
            }
        }

        return ok;

    }
}
}
