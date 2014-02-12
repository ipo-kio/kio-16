/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.Figure;


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

    override public function evaluateWithQuants(data:Dictionary, figures:Vector.<Figure>):Boolean{
        //если переменная определена, то просто вычисляем
        var temp1:Object;
        if(data[formalOperand]!=null && isOne(formalOperand+"")){
            temp1 = data[formalOperand];
            data[formalOperand]=null;
        }

        var result:Boolean;

        if(data[formalOperand]!=null){
            result = evaluate(data);
        }else{
            var exists:Boolean = isOne(formalOperand);
            var forAll:Boolean=true;
            for(var i:int=0; i<figures.length; i++){
                if(isRegisteredIndex(i,figures,data)){
                    continue;
                }
                data[formalOperand]=figures[i];
                var currentCheck:Boolean = evaluate(data);
                data[formalOperand]=null;
                if(exists && currentCheck){
                    result = true;
                    if(temp1!=null){
                        data[formalOperand]=temp1;
                    }
                    return result;
                }
                forAll = forAll&&currentCheck;
            }
            result = forAll;
        }
        if(temp1!=null){
            data[formalOperand]=temp1;
        }
        return result;
    }


    public function getBeforeHolder():VariablePlaceHolder {
        return null;
    }

    public function getAfterHolder():VariablePlaceHolder {
        return _placeHolder;
    }

}
}
