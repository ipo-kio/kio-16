/**
 * Предикат, проверяющий что один объект стоит ближе другого
 *
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;

import ru.ipo.kio._14.tarski.model.properties.PlanePositionable;

public class CloserPredicate extends TwoPlacePredicate{

    override public function canBeEvaluated():Boolean {
        return formalOperand1!=null && formalOperand2!=null;
    }

    override public function evaluate(data:Dictionary):Boolean {
        var operand1:PlanePositionable=data[formalOperand1];
        var operand2:PlanePositionable=data[formalOperand2];
        if(operand1==null || operand2==null){
            throw new IllegalOperationError("operand must be not null");
        }
        return operand1.y<operand2.y;
    }


    public function toString():String {
        return quantsToSts()+"[closer:"+formalOperand1 +";"+formalOperand2+"]";
    }

    public override function getToolboxText():String {
        return "стоит ближе";
    }

    public override function getCloned():LogicItem {
        return new CloserPredicate();
    }
}
}
