/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.utils.Dictionary;


public class OnePlacePredicate extends BasePredicate {

    private var _placeHolder:VariablePlaceHolder;


    public function OnePlacePredicate() {
        _placeHolder=new VariablePlaceHolder(this);
    }

    public function get placeHolder():VariablePlaceHolder {
        return _placeHolder;
    }

    /**
     * Формальный параметр (код)
     */
    private var _formalOperand:String;

    public function set operand(value:String):void {
        _formalOperand = value;
    }


    public function get formalOperand():String {
        return _formalOperand;
    }

    override public function collectFormalOperand():Dictionary{
        var operands:Dictionary = new Dictionary();
        operands[_formalOperand]=_formalOperand;
        return operands;
    }

    public override function commit():void {
        if(_placeHolder.variable!=null){
            _formalOperand=_placeHolder.variable.code;
        }
    }

    public function getBeforeHolder():VariablePlaceHolder {
        return null;
    }

    public function getAfterHolder():VariablePlaceHolder {
        return _placeHolder;
    }

}
}
