/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.operation {
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;

public class NotOperation extends LogicEvaluatedItem implements LogicItem{

    private var _operand:LogicEvaluatedItem;

    public function NotOperation() {
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

    override public function collectFormalOperand():Dictionary{
        return _operand.collectFormalOperand();
    }

    public function toString():String {
        return "!" + operand + "";
    }


    public override function getToolboxText():String {
        return toString();
    }


    public override function commit():void {
        if(_operand!=null){
            _operand.commit();
        }
    }

    public override function getCloned():LogicItem {
        return new NotOperation();
    }

}
}
