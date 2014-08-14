/**
 * Предикат, проверяющий что один объект стоит левее другого
 *
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;

import ru.ipo.kio._14.tarski.model.properties.PlanePositionable;

public class LefterPredicate extends TwoPlacePredicate{
    private var lefter:String;
    private var lefter2:String;

    override public function canBeEvaluated():Boolean {
        return formalOperand1!=null && formalOperand2!=null;
    }

    override public function evaluate(data:Dictionary):Boolean {
        var operand1:PlanePositionable=data[formalOperand1];
        var operand2:PlanePositionable=data[formalOperand2];
        if(operand1==null || operand2==null){
            throw new IllegalOperationError("operand must be not null");
        }
        return operand1.x<operand2.x;
    }

    public override function toString():String {
        return quantsToSts()+"left-"+formalOperand1+"-"+formalOperand2+"";
    }



    public override function getToolboxText():String {
        return lefter;
    }

    public override function getTooltipText():String {
        return lefter2;
    }

    public override function getCloned():LogicItem {
        return new LefterPredicate(lefter, lefter2);
    }

    public function LefterPredicate(lefter:String, lefter2:String) {
        this.lefter=lefter;
        this.lefter2=lefter2;
        super();
    }
}
}
