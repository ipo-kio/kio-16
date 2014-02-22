/**
 * @author: Vasily Akimushkin
 * @since: 11.02.14
 */
package ru.ipo.kio._14.tarski.model.operation {
import flash.errors.IllegalOperationError;
import flash.events.GestureEvent;
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.Figure;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;

public class BaseOperation extends LogicEvaluatedItem implements LogicItem {


    public function BaseOperation() {
    }

    private var _priority:int=1;


    public function resetPriority():void{
        _priority=1;
    }




    public function get priority():int {
        return _priority;
    }

    public function set priority(value:int):void {
        _priority = value;
    }

    public function evaluateWithQuantsFinal(data:Dictionary, figures:Vector.<Figure>):Boolean{
        throw new IllegalOperationError("method must be overridden");
    }

    public override function commit():void {

        for(var i:int=0; i<quants.length; i++){
            quants[i].commit();
        }
    }

    override public function evaluateWithQuants(data:Dictionary, figures:Vector.<Figure>):Boolean{
        var dict:Dictionary = collectFormalOperand();
        var size:int = 0;
        var first:Object = null;
        var second:Object = null;
        var third:Object = null;

        for (var kk:Object in dict) {
            if (size == 0) {
                first = kk;
            }
            if (size == 1) {
                second = kk;
            }
            if (size == 2) {
                third = kk;
            }
            size++;
        }

        var result:Boolean = false;
        var temp1, temp2, temp3:Object;
        if(data[first]!=null){
            if(isOne(first+"")){
                temp1 = data[first];
                data[first]=null;
            }
        }
        if(data[second]!=null){
            if(isOne(second+"")){
                temp2 = data[second];
                data[second]=null;
            }
        }
        if(data[third]!=null){
            if(isOne(third+"")){
                temp3 = data[third];
                data[third]=null;
            }
        }


        if (size == 1) {
            if(data[first]!=null){
                result = evaluateWithQuantsFinal(data, figures);
            }else{
                result = checkOne(first, figures, data);
            }
        } else if (size == 2) {
            if(data[first]!=null && data[second]!=null){
                result = evaluateWithQuantsFinal(data, figures);
            }else if(data[first]==null && data[second]!=null){
                result = checkOne(first, figures, data);
            }else if(data[second]==null && data[first]!=null){
                result = checkOne(second, figures, data);
            }else{
                result = checkTwo(first, second, figures, data);
            }
        } else if (size == 3) {
            if(data[first]!=null && data[second]!=null && data[third]!=null){
                result = evaluateWithQuantsFinal(data, figures);
            }else if(data[first]==null && data[second]!=null && data[third]!=null){
                result = checkOne(first, figures, data);
            }else if(data[second]==null && data[first]!=null && data[third]!=null){
                result = checkOne(second, figures, data);
            }else if(data[third]==null && data[first]!=null && data[second]!=null){
                result = checkOne(third, figures, data);
            }else if(data[first]==null && data[second]==null && data[third]!=null){
                result = checkTwo(first, second, figures, data);
            }else if(data[first]==null && data[third]==null && data[second]!=null){
                result = checkTwo(first, third, figures, data);
            }else if(data[second]==null && data[third]==null && data[first]!=null){
                result = checkTwo(second, third, figures, data);
            }else{
                result = checkThree(first, second, third, figures, data);
            }
        }

        if(temp1!=null){
            data[first]=temp1;
        }
        if(temp2!=null){
            data[second]=temp2;
        }
        if(temp3!=null){
            data[third]=temp3;
        }

        return result;
    }


    private function checkThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        var firstExists:Boolean = isOne(first+"");
        var secondExists:Boolean = isOne(second+"");
        var thirdExists:Boolean = isOne(third+"");
        var firstAll:Boolean = isAll(first+"");
        var secondAll:Boolean = isAll(second+"");
        var thirdAll:Boolean = isAll(third+"");

        if(!firstAll && !firstExists){
            return checkTwo(second, third, figures, data);
        }else if(!secondAll && ! secondExists){
            return checkTwo(first, third, figures, data);
        }else if(!thirdAll && ! thirdExists){
            return checkTwo(first, second, figures, data);
        }else{
            if(firstExists && secondExists && thirdExists){
                return checkSingleThree(first, second, third, figures, data);
            }else if (firstAll && secondAll && thirdAll){
                return checkAllThree(first, second, third, figures, data);
            }else if(firstExists && secondAll && thirdAll){
                checkSingleAllAllThree(first, second, third, figures, data);
            }else if (secondExists && firstAll && thirdAll){
                checkAllSingleAllThree(first, second, third, figures, data);
            }else if (thirdExists && firstAll && secondAll){
                checkAllAllSingleThree(first, second, third, figures, data);
            }else if(firstAll && secondExists && thirdExists){
               checkAllSingleSingleThree(first, second, third, figures, data);
            }else if(secondAll && firstExists && thirdExists){
               checkSingleAllSingleThree(first, second, third, figures, data);
            }else if(thirdAll && firstExists && secondExists){
                checkSingleSingleAllThree(first, second, third, figures, data);
            }
        }

        return false;
    }

    private function checkSingleAllSingleThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        var firstCheck:Boolean=false;
        for(var i:int=0;i<figures.length;i++){
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first]=figures[i];
            var secondCheck:Boolean=true;
            for(var j:int=0;j<figures.length;j++){
                if(isRegisteredIndex(j,figures,data)){
                    continue;
                }
                data[second]=figures[j];
                var thirdCheck:Boolean=false;
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        if(isRegisteredIndex(k,figures,data)){
                            continue;
                        }
                        data[third]=figures[k];
                        var currentCheck:Boolean = evaluateWithQuantsFinal(data, figures);
                        data[third]=null;
                        if(currentCheck){
                            thirdCheck=true;
                            break;
                        }
                    }
                }
                data[second]=null;
                secondCheck=secondCheck&&thirdCheck;
            }
            data[first]=null;
            if(secondCheck==true){
                firstCheck= true;
                break;
            }
        }
        return firstCheck;
    }


    private function checkAllSingleSingleThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        var firstCheck:Boolean=true;
        for(var i:int=0;i<figures.length;i++){
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first]=figures[i];
            var secondCheck:Boolean=false;
            for(var j:int=0;j<figures.length;j++){
                if(isRegisteredIndex(j,figures,data)){
                    continue;
                }
                data[second]=figures[j];
                var thirdCheck:Boolean=false;
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        if(isRegisteredIndex(k,figures,data)){
                            continue;
                        }
                        data[third]=figures[k];
                        var currentCheck:Boolean = evaluateWithQuantsFinal(data, figures);
                        data[third]=null;
                        if(currentCheck){
                            thirdCheck=true;
                            break;
                        }
                    }
                }
                data[second]=null;
                if(thirdCheck){
                    secondCheck=true;
                    break;
                }
            }
            firstCheck=firstCheck&&secondCheck
            data[first]=null;
        }
        return firstCheck;
    }

    private function checkAllSingleAllThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        var firstCheck:Boolean=true;
        for(var i:int=0;i<figures.length;i++){
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first]=figures[i];
            var secondCheck:Boolean=false;
            for(var j:int=0;j<figures.length;j++){
                if(isRegisteredIndex(j,figures,data)){
                    continue;
                }
                data[second]=figures[j];
                var thirdCheck:Boolean=true;
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        if(isRegisteredIndex(k,figures,data)){
                            continue;
                        }
                        data[third]=figures[k];
                        var currentCheck:Boolean = evaluateWithQuantsFinal(data, figures);
                        data[third]=null;
                        thirdCheck=thirdCheck&&currentCheck;
                    }
                }
                data[second]=null;
                if(thirdCheck){
                    secondCheck=true;
                    break;
                }
            }
            firstCheck=firstCheck&&secondCheck
            data[first]=null;
        }
        return firstCheck;
    }

    private function checkAllAllSingleThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        var firstCheck:Boolean=true;
        for(var i:int=0;i<figures.length;i++){
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first]=figures[i];
            var secondCheck:Boolean=true;
            for(var j:int=0;j<figures.length;j++){
                if(isRegisteredIndex(j,figures,data)){
                    continue;
                }
                data[second]=figures[j];
                var thirdCheck:Boolean=false;
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        if(isRegisteredIndex(k,figures,data)){
                            continue;
                        }
                        data[third]=figures[k];
                        var currentCheck:Boolean = evaluateWithQuantsFinal(data, figures);
                        data[third]=null;
                        if(currentCheck){
                            thirdCheck=true;
                            break;
                        }
                    }
                }
                secondCheck=secondCheck&&thirdCheck;
                data[second]=null;
            }
            firstCheck=firstCheck&&secondCheck
            data[first]=null;
        }
        return firstCheck;
    }


    private function checkSingleSingleAllThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        for(var i:int=0;i<figures.length;i++){
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first]=figures[i];
            for(var j:int=0;j<figures.length;j++){
                var allCheck:Boolean=true;
                if(isRegisteredIndex(j,figures,data)){
                    continue;
                }
                data[second]=figures[j];
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        if(isRegisteredIndex(k,figures,data)){
                            continue;
                        }
                        data[third]=figures[k];
                        var currentCheck:Boolean = evaluateWithQuantsFinal(data, figures);
                        data[third]=null;
                        allCheck=allCheck&&currentCheck;
                    }
                }
                data[second]=null;
                if(allCheck){
                    return true;
                }
            }
            data[first]=null;
        }
        return false;
    }

    private function checkSingleAllAllThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        for(var i:int=0;i<figures.length;i++){
            var allCheck:Boolean=true;
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first]=figures[i];
            for(var j:int=0;j<figures.length;j++){
                if(isRegisteredIndex(j,figures,data)){
                    continue;
                }
                data[second]=figures[j];
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        if(isRegisteredIndex(k,figures,data)){
                            continue;
                        }
                        data[third]=figures[k];
                        var currentCheck:Boolean = evaluateWithQuantsFinal(data, figures);
                        data[third]=null;
                        allCheck=allCheck&&currentCheck;
                    }
                }
                data[second]=null;
            }
            data[first]=null;
            if(allCheck){
                return true;
            }
        }
        return false;
    }


    private function checkSingleThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        for(var i:int=0;i<figures.length;i++){
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first]=figures[i];
            for(var j:int=0;j<figures.length;j++){
                if(isRegisteredIndex(j,figures,data)){
                    continue;
                }
                data[second]=figures[j];
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        if(isRegisteredIndex(k,figures,data)){
                            continue;
                        }
                        data[third]=figures[k];
                        if(evaluateWithQuantsFinal(data, figures)){
                            data[first] = null;
                            data[second] = null;
                            data[third] = null;
                            return true;
                        }

                    }
                }
                data[second] = null;
            }
            data[third] = null;
        }
        data[first] = null;
        data[second] = null;
        data[third] = null;
        return false;
    }


    private function checkAllThree(first:Object, second:Object, third:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        var allCheck:Boolean=true;
        for(var i:int=0;i<figures.length;i++){
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first]=figures[i];
            for(var j:int=0;j<figures.length;j++){
                if(isRegisteredIndex(j,figures,data)){
                    continue;
                }
                data[second]=figures[j];
                for(var k:int=0;k<figures.length;k++){
                    if(i!=j && j!=k){
                        if(isRegisteredIndex(k,figures,data)){
                            continue;
                        }
                        data[third]=figures[k];
                        var currentCheck:Boolean = evaluateWithQuantsFinal(data, figures);
                        data[first]=null;
                        allCheck=allCheck&&currentCheck;

                    }
                }
                data[second]=null;
            }
            data[third]=null;
        }
        return allCheck;
    }


    private function checkTwo(first:Object, second:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        var firstExists:Boolean = isOne(first+"");
        var secondExists:Boolean = isOne(second+"");
        var firstAll:Boolean = isAll(first+"");
        var secondAll:Boolean = isAll(second+"");


        if(firstExists && secondExists){
            return checkSingleTwo(first, second, figures, data);
        }else if (firstAll && secondAll){
            return checkAllTwo(first, second, figures, data);
        }else if(firstExists && secondAll){
            return checkSingleAllTwo(first, second, figures, data);
        }else if(secondExists && firstAll){
            return checkAllSingleTwo(first, second, figures, data);
        }else if(firstExists){
            return checkSingleOne(first, figures, data);
        }else if(secondExists){
            return checkSingleOne(second, figures, data);
        }else if(firstAll){
            return checkAllOne(first, figures, data);
        }else if(secondAll){
            return checkAllOne(second, figures, data);
        }else{
            return evaluateWithQuantsFinal(data, figures);
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
                    var currentCheck:Boolean = evaluateWithQuantsFinal(data, figures);
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
                    var currentCheck:Boolean = evaluateWithQuantsFinal(data, figures);
                    data[second]=null;
                    if(currentCheck){
                        allCheck=true;
                        break;
                    }
                }
            }
            data[first]=null;
            sumCheck=sumCheck&&allCheck;
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
                    var currentCheck:Boolean = evaluateWithQuantsFinal(data, figures);
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
                    if(evaluateWithQuantsFinal(data, figures)){
                        data[first] = null;
                        data[second] = null;
                        return true;
                    }

                }
            }
            data[first] = null;
        }
        data[first] = null;
        data[second] = null;
        return false;
    }



    private function checkOne(first:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        if(isOne(first+"")){
            return checkSingleOne(first, figures, data);
        }else if(isAll(first+"")){
            return checkAllOne(first, figures, data);
        }else{
           return evaluateWithQuantsFinal(data, figures);
        }
    }



    private function checkAllOne(first:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        var allCheck:Boolean=true;
        for (var i:int = 0; i < figures.length; i++) {
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first] = figures[i];
            var currentCheck:Boolean =  evaluateWithQuantsFinal(data, figures);
            data[first] = null;
            allCheck = allCheck && currentCheck;
        }
        return allCheck;
    }


    private function checkSingleOne(first:Object, figures:Vector.<Figure>, data:Dictionary):Boolean {
        for (var i:int = 0; i < figures.length; i++) {
            if(isRegisteredIndex(i,figures,data)){
                continue;
            }
            data[first] = figures[i];
            if(evaluateWithQuantsFinal(data, figures)){
                data[first] = null;
                return true;
            }

        }
        data[first] = null;
        return false;
    }

    public override function getFormulaText():String {
        return getToolboxText();
    }
}
}
