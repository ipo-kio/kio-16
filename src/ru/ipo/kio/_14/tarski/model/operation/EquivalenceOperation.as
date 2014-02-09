/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.operation {
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;

public class EquivalenceOperation extends TwoPositionOperation{

    override public function canBeEvaluated():Boolean {
        return operand1!=null && operand1.canBeEvaluated() && operand2!=null && operand2.canBeEvaluated();
    }

    override public function evaluate(data:Dictionary):Boolean{
        return (operand1.evaluate(data) && operand2.evaluate(data))
                ||(!operand1.evaluate(data) && !operand2.evaluate(data));
    }

    public function toString():String {
        return "[" + operand1 + "<=>" +operand2+ "]";
    }

    public override function getToolboxText():String {
        return "<=>";
    }

    public override function getCloned():LogicItem {
        return new EquivalenceOperation();
    }
}
}
