/**
 * Предикат, проверяющий размер объекта
 *
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;

import ru.ipo.kio._14.tarski.model.properties.Sizable;
import ru.ipo.kio._14.tarski.model.properties.SizeValue;
import ru.ipo.kio._14.tarski.model.properties.ValueHolder;

public class SizePredicate extends OnePlacePredicate{

    /**
     * Проверяемый размер
     */
    private var size:SizeValue;


     public function SizePredicate(size:SizeValue) {
        this.size = size;
         super();
    }


    override public function canBeEvaluated():Boolean {
        return formalOperand!=null;
    }


    override public function evaluate(data:Dictionary):Boolean {
        var operand:Sizable=data[formalOperand];
        if(operand==null){
            throw new IllegalOperationError("operand must be not null");
        }
        return size.code==operand.size.code;
    }

    public override function toString():String {
        return quantsToSts()+"size-"+size.code+"-"+formalOperand+"";
    }


    public function parseString(str:String):SizePredicate {
        var items:Array = str.split("-");
        size = ValueHolder.getSize(items[1]);
        operand = items[2];
        placeHolder.variable = new Variable(formalOperand);
        return this;
    }

    public override function getToolboxText():String {
        return size.code==SizeValue.BIG?"Большой":"Малый";
    }

    public override function getCloned():LogicItem {
        return new SizePredicate(size);
    }
}
}
