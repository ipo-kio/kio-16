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

    public function NearPredicate(step:int=1) {
        this.step = step;
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

    public function toString():String {
        return "[near:"+formalOperand1+ ";"+formalOperand2+"]";
    }

    public override function getToolboxText():String {
        return "стоит ближе";
    }

    public override function getCloned():LogicItem {
        return new NearPredicate();
    }



}
}
