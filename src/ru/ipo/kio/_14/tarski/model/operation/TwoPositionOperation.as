/**
 * @author: Vasily Akimushkin
 * @since: 22.01.14
 */
package ru.ipo.kio._14.tarski.model.operation {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;


import ru.ipo.kio._14.tarski.model.editor.LogicItem;

public class TwoPositionOperation extends BaseOperation{

    private var _operand1:LogicEvaluatedItem;

    private var _operand2:LogicEvaluatedItem;

    public function get operand1():LogicEvaluatedItem {
        return _operand1;
    }

    public function set operand1(value:LogicEvaluatedItem):void {
        _operand1 = value;
    }

    public function get operand2():LogicEvaluatedItem {
        return _operand2;
    }

    public function set operand2(value:LogicEvaluatedItem):void {
        _operand2 = value;
    }

    override public function collectFormalOperand():Dictionary{
        if(_operand1!=null && _operand2!=null){
        var operands:Dictionary = _operand1.collectFormalOperand();
        var operands2:Dictionary = _operand2.collectFormalOperand();
        for (var k:Object in operands2) {
            operands[k]=operands2[k];
        }
        return operands;
        }else{
            return new Dictionary();
        }
    }

    override public function canBeEvaluated():Boolean{
        throw new IllegalOperationError("method must be overridden");
    }

    override public function evaluate(data:Dictionary):Boolean{
        throw new IllegalOperationError("method must be overridden");
    }


    public override function commit():void {
        if(_operand1!=null){
            _operand1.commit();
        }
        if(_operand2!=null){
            _operand2.commit();
        }
    }

    public override function getCloned():LogicItem {
        throw new IllegalOperationError("method must be overridden");
    }


}
}
