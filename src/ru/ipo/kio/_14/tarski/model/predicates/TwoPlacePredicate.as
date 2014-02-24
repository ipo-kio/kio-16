/**
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.Figure;
import ru.ipo.kio._14.tarski.model.quantifiers.Quantifier;


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

    public function parseString(str:String):TwoPlacePredicate {
        var items:Array = str.split("-");
        formalOperand1 = items[1];
        formalOperand2 = items[2];
        placeHolder1.variable = new Variable(formalOperand1);
        placeHolder2.variable = new Variable(formalOperand2);
        return this;
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

    override public function checkQuantors(quantors:Vector.<Quantifier>):Boolean{
        var quantorsNew:Vector.<Quantifier> = new Vector.<Quantifier>();
        for(var i:int=0; i<quantors.length; i++){
            quantorsNew.push(quantors[i]);
        }
        for(var i:int=0; i<quants.length; i++){
            quantorsNew.push(quants[i]);
        }

        var checkOne:Boolean = false;
        var checkTwo:Boolean = false;
        for(var i:int=0; i<quantorsNew.length; i++){
            if(quantorsNew[i].formalOperand==_formalOperand1){
                checkOne = true;
            }
            if(quantorsNew[i].formalOperand==_formalOperand2){
                checkTwo = true;
            }
        }
        return checkOne && checkTwo;

    }

    override public function collectFormalOperand():Dictionary{
        var operands:Dictionary = new Dictionary();
        operands[_formalOperand1]=_formalOperand1;
        operands[_formalOperand2]=_formalOperand2;
        return operands;
    }


    override public function evaluateWithQuants(data:Dictionary, figures:Vector.<Figure>):Boolean{
        if(data[formalOperand1]!=null && data[formalOperand2]!=null){
            return evaluate(data);
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
                  return true;
                }
                forAll = forAll&&currentCheck;
            }
            return forAll;
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
                   return true;
                }
                forAll = forAll&&currentCheck;
            }
            return forAll;
        }else{//оба не определены
            var exists1:Boolean = isOne(formalOperand1);
            var exists2:Boolean = isOne(formalOperand2);
            if(exists1 && exists2){
                return checkSingleTwo(formalOperand1, formalOperand2, figures, data);
            }else if(exists1 && !exists2){
                return checkSingleAllTwo(formalOperand1, formalOperand2, figures, data);
            }else if(exists2 && !exists1){
                return checkAllSingleTwo(formalOperand1, formalOperand2, figures, data);
            }else{
                return checkAllTwo(formalOperand1, formalOperand2, figures, data);
            }
        }
    }

        private function checkSingleAllTwo(first:Object, second:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
            for(var i:int=0;i<figures.length;i++){
                if(isRegisteredIndex(i,figures,data)){
                    continue;
                }
                data[first]=figures[i];
                var allCheck:Boolean=true;
                for(var j:int=0;j<figures.length;j++){
                    if(i!=j){
                        if(isRegisteredIndex(j,figures,data)){
                            continue;
                        }
                        data[second]=figures[j];
                        var currentCheck:Boolean = evaluate(data);
                        data[second]=null;
                        allCheck=allCheck&&currentCheck;
                    }
                }
                data[first]=null;
                if(allCheck){
                    return true;
                }
            }
            return false;
        }


        private function checkAllSingleTwo(first:Object, second:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
            var sumCheck:Boolean=true;
            for(var i:int=0;i<figures.length;i++){
                if(isRegisteredIndex(i,figures,data)){
                    continue;
                }
                data[first]=figures[i];
                var allCheck:Boolean=false;
                for(var j:int=0;j<figures.length;j++){
                    if(i!=j){
                        if(isRegisteredIndex(j,figures,data)){
                            continue;
                        }
                        data[second]=figures[j];
                        var currentCheck:Boolean = evaluate(data);
                        data[second]=null;
                        if(currentCheck){
                            allCheck=true;
                            break;
                        }
                    }
                }
                sumCheck=sumCheck&&allCheck;
                data[first]=null;
            }
            return sumCheck;
        }

    private function checkAllTwo(first:Object, second:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        var allCheck:Boolean=true;
        for(var i:int=0;i<figures.length;i++){
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first]=figures[i];
            for(var j:int=0;j<figures.length;j++){
                if(i!=j){
                    if(isRegisteredIndex(j,figures,data)){
                        continue;
                    }
                    data[second]=figures[j];
                    var currentCheck:Boolean = evaluate(data);
                    data[second]=null;
                    allCheck=allCheck&&currentCheck;
                }
            }
            data[first]=null;
        }
        return allCheck;
    }

    private function checkSingleTwo(first:Object, second:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        for(var i:int=0;i<figures.length;i++){
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first]=figures[i];
            for(var j:int=0;j<figures.length;j++){
                if(i!=j){
                    if(isRegisteredIndex(j,figures,data)){
                        continue;
                    }
                    data[second]=figures[j];
                    if(evaluate(data)){
                        data[first] = null;
                        data[second] = null;
                        return true;
                    }
                    data[second]=null;
                }
            }
        }
        data[first] = null;
        data[second] = null;
        return false;
    }


    public override function commit():void {
        if(_placeHolder1.variable!=null){
            _formalOperand1=_placeHolder1.variable.code;
        }
        if(_placeHolder2.variable!=null){
            _formalOperand2=_placeHolder2.variable.code;
        }

        for(var i:int=0; i<quants.length; i++){
            quants[i].commit();
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
