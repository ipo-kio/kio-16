/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.Figure;


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


    override public function evaluateWithQuants(data:Dictionary, figures:Vector.<Figure>):Boolean{
        //если переменная определена, то просто вычисляем
        var temp1, temp2:Object;
        if(data[formalOperand1]!=null && isOne(formalOperand1+"")){
            temp1 = data[formalOperand1];
            data[formalOperand1]=null;
        }
        if(data[formalOperand2]!=null && isOne(formalOperand2+"")){
            temp1 = data[formalOperand2];
            data[formalOperand2]=null;
        }

        var result:Boolean;

        if(data[formalOperand1]!=null && data[formalOperand2]!=null){
            result = evaluate(data);
        }else if(data[formalOperand1]==null && data[formalOperand2]!=null){
            var exists:Boolean = isOne(formalOperand1);
            var forAll:Boolean=true;
            for(var i:int=0; i<figures.length; i++){
                if(isRegisteredIndex(i,figures,data)){
                    continue;
                }
                data[formalOperand1]=figures[i];
                var currentCheck:Boolean = evaluate(data);
                data[formalOperand1]=null;
                if(exists && currentCheck){
                    result = true;
                    if(temp1!=null){
                        data[formalOperand1]=temp1;
                    }
                    if(temp2!=null){
                        data[formalOperand2]=temp2;
                    }
                    return result;
                }
                forAll = forAll&&currentCheck;
            }
            result = forAll;
        }else if(data[formalOperand2]==null && data[formalOperand1]!=null){
            var exists:Boolean = isOne(formalOperand2);
            var forAll:Boolean=true;
            for(var i:int=0; i<figures.length; i++){
                if(isRegisteredIndex(i,figures,data)){
                    continue;
                }
                data[formalOperand2]=figures[i];
                var currentCheck:Boolean = evaluate(data);
                data[formalOperand2]=null;
                if(exists && currentCheck){
                    result = true;
                    if(temp1!=null){
                        data[formalOperand1]=temp1;
                    }
                    if(temp2!=null){
                        data[formalOperand2]=temp2;
                    }
                    return result;
                }
                forAll = forAll&&currentCheck;
            }
            result = forAll;
        }else{//оба не определены
            var exists1:Boolean = isOne(formalOperand1);
            var exists2:Boolean = isOne(formalOperand2);
            var formalOperandExist:String;
            var formalOperandAll:String;
            if(exists1){
                formalOperandExist=formalOperand1;
                formalOperandAll=formalOperand2;
            }else{
                formalOperandExist=formalOperand2;
                formalOperandAll=formalOperand1;
            }

            var forAll:Boolean=true;
            for(var i:int=0; i<figures.length; i++){
                if(isRegisteredIndex(i,figures,data)){
                    continue;
                }
                data[formalOperandExist]=figures[i];
                var iter:Boolean=true;
                for(var j:int=0; j<figures.length; j++){
                    if(isRegisteredIndex(j,figures,data)){
                        continue;
                    }
                    data[formalOperandAll]=figures[j];
                    var currentCheck:Boolean = evaluate(data);
                    data[formalOperandAll]=null;
                    if(exists1 && exists2 && currentCheck){
                        data[formalOperandExist]=null;
                        result = true;
                        if(temp1!=null){
                            data[formalOperand1]=temp1;
                        }
                        if(temp2!=null){
                            data[formalOperand2]=temp2;
                        }
                        return result;
                    }
                    iter = iter&&currentCheck;
                }
                data[formalOperandExist]=null;
                if(exists1 && iter){
                    result = true;
                    if(temp1!=null){
                        data[formalOperand1]=temp1;
                    }
                    if(temp2!=null){
                        data[formalOperand2]=temp2;
                    }

                    return result;
                }
                forAll=forAll&&iter;
            }
            result = forAll;
        }
        if(temp1!=null){
            data[formalOperand1]=temp1;
        }
        if(temp2!=null){
            data[formalOperand2]=temp2;
        }
        return result;
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
