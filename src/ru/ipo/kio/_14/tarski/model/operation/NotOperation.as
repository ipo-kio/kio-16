/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.operation {
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.Figure;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.quantifiers.Quantifier;

public class NotOperation extends BaseOperation{

    private var _operand:LogicEvaluatedItem;

    public function NotOperation() {
        priority=5;
    }

    public override function resetPriority():void{
        priority=5;
    }

    public function get operand():LogicEvaluatedItem {
        return _operand;
    }

    public function set operand(value:LogicEvaluatedItem):void {
        _operand = value;
    }

    override public function canBeEvaluated():Boolean {
        return operand!=null && operand.canBeEvaluated();
    }

    override public function evaluate(data:Dictionary):Boolean{
        return !_operand.evaluate(data);
    }

    override public function evaluateWithQuantsFinal(data:Dictionary, figures:Vector.<Figure>):Boolean{
        return !_operand.evaluateWithQuants(data, figures);
    }

    override public function collectFormalOperand():Dictionary{
        return _operand.collectFormalOperand();
    }

    public function toString():String {
        return quantsToSts()+"!" + operand + "";
    }


    public override function getToolboxText():String {
        return "Не верно, что";
    }


    public override function commit():void {
        for(var i:int=0; i<quants.length; i++){
            quants[i].commit();
        }
        if(_operand!=null){
            _operand.commit();
        }
    }

    override public function checkQuantors(quantors:Vector.<Quantifier>):Boolean{
        var quantorsNew:Vector.<Quantifier> = new Vector.<Quantifier>();
        for(var i:int=0; i<quantors.length; i++){
            quantorsNew.push(quantors[i]);
        }
        for(var i:int=0; i<quants.length; i++){
            quantorsNew.push(quants[i]);
        }
        return _operand.checkQuantors(quantorsNew);
    }

    public override function getCloned():LogicItem {
        return new NotOperation();
    }

}
}
