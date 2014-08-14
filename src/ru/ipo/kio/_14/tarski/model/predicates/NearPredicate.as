/**
 * Предикат, проверяющий что объекты находятся рядом (на соседних клетках)
 * По умолчанию шаг сетки - 1
 *
 * @author: Vasily Akimushkin
 * @since: 22.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.properties.PlanePositionable;

public class NearPredicate extends TwoPlacePredicate{

    private var step:int=1;
    private var near:String;
    private var near2:String;

    public function NearPredicate(step:int, near:String, near2:String) {
        this.step = step;
        this.near=near;
        this.near2=near2;
        super();
    }

    override public function canBeEvaluated():Boolean {
        return formalOperand1!=null && formalOperand2!=null;
    }

    override public function evaluate(data:Dictionary):Boolean {
        var operand1:PlanePositionable=data[formalOperand1];
        var operand2:PlanePositionable=data[formalOperand2];
        if(operand1==null || operand2==null){
            throw new IllegalOperationError("operand must be not null");
        }
        return Math.abs(operand1.x-operand2.x)<=step && Math.abs(operand1.y-operand2.y)<=step;
    }

    public override function toString():String {
        return quantsToSts()+"near-"+formalOperand1+"-"+formalOperand2+"";
    }


    public override function getToolboxText():String {
        return near;
    }

    public override function getTooltipText():String {
        return near2;
    }

    public override function getCloned():LogicItem {
        return new NearPredicate(1,near, near2);
    }



}
}
