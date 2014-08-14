/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.operation {
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.editor.LogicItem;

public class ImplicationOperation extends TwoPositionOperation{
    private var impl:String;
    private var impl2:String;


    public function ImplicationOperation(impl:String, impl2:String) {
        priority=2;
        this.impl=impl;
        this.impl2=impl2;
        super();
    }

    public override function resetPriority():void{
        priority=2;
    }

    override public function canBeEvaluated():Boolean {
        return operand1!=null && operand1.canBeEvaluated() && operand2!=null && operand2.canBeEvaluated();
    }

    override public function evaluate(data:Dictionary):Boolean{
        return !operand1.evaluate(data)||operand2.evaluate(data);
    }

    override public function evaluateWithQuantsFinal(data:Dictionary, figures:Vector.<Figure>):Boolean{
        return !operand1.evaluateWithQuants(data, figures)||operand2.evaluateWithQuants(data, figures);
}

    public function toString():String {
        return quantsToSts()+"[" + operand1 + "=>" +operand2+ "]";
    }

    public override function getToolboxText():String {
        return impl;
    }

    public override function getCloned():LogicItem {
        return new ImplicationOperation(impl, impl2);
    }

    public override function getFormulaText():String {
        return impl;
    }
    public override function getTooltipText():String {
        return impl2;
    }

}
}
