/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.quantifiers.Quantifier;


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
        for(var i:int=0; i<quants.length; i++){
            quants[i].commit();
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

        var checkOne:Boolean = false;
        for(var i:int=0; i<quantorsNew.length; i++){
            if(quantorsNew[i].formalOperand==_formalOperand){
                checkOne = true;
            }
        }
        return checkOne;

    }

    override public function evaluateWithQuants(data:Dictionary, figures:Vector.<Figure>):Boolean{
         if(data[formalOperand]!=null){
            return evaluate(data);
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
                    return true;
                }
                forAll = forAll&&currentCheck;
            }
            return forAll;
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
