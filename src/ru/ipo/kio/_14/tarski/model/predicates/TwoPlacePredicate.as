/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.utils.Dictionary;


public class TwoPlacePredicate extends BasePredicate {

    private var _placeHolder1:VariablePlaceHolder;

    private var _placeHolder2:VariablePlaceHolder;


    public function TwoPlacePredicate() {
        _placeHolder1 = new VariablePlaceHolder(this);
        _placeHolder2 = new VariablePlaceHolder(this);
    }

    public function get placeHolder1():VariablePlaceHolder {
        return _placeHolder1;
    }

    public function get placeHolder2():VariablePlaceHolder {
        return _placeHolder2;
    }

    private var _formalOperand1:String;

    private var _formalOperand2:String;

    public function get formalOperand1():String {
        return _formalOperand1;
    }

    public function get formalOperand2():String {
        return _formalOperand2;
    }

    public function set formalOperand1(value:String):void {
        _formalOperand1 = value;
    }

    public function set formalOperand2(value:String):void {
        _formalOperand2 = value;
    }

    override public function collectFormalOperand():Dictionary{
        var operands:Dictionary = new Dictionary();
        operands[_formalOperand1]=_formalOperand1;
        operands[_formalOperand2]=_formalOperand2;
        return operands;
    }

    public override function commit():void {
        if(_placeHolder1.variable!=null){
            _formalOperand1=_placeHolder1.variable.code;
        }
        if(_placeHolder2.variable!=null){
            _formalOperand2=_placeHolder2.variable.code;
        }
    }


    public function getBeforeHolder():VariablePlaceHolder {
        return _placeHolder1;
    }

    public function getAfterHolder():VariablePlaceHolder {
        return _placeHolder2;
    }
}
}
