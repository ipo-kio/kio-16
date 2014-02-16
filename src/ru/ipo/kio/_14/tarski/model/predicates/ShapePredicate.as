/**
 * Предикат, проверяющий Форму объекта
 *
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;

import ru.ipo.kio._14.tarski.model.properties.Shapable;
import ru.ipo.kio._14.tarski.model.properties.ShapeValue;

public class ShapePredicate extends OnePlacePredicate{

    /**
     * Проверяемая форма
     */
    private var shape:ShapeValue;

     public function ShapePredicate(shape:ShapeValue) {
        this.shape = shape;
         super();
    }


    override public function canBeEvaluated():Boolean {
        return formalOperand!=null;
    }

    override public function evaluate(data:Dictionary):Boolean {
        var operand:Shapable=data[formalOperand];
        if(operand==null){
            throw new IllegalOperationError("operand must be not null");
        }
        return shape.code==operand.shape.code;
    }

    public function toString():String {
        return quantsToSts()+"[shape-"+shape.code+":"+formalOperand+"]";
    }

    public override function getToolboxText():String {
        return shape.code==ShapeValue.CUBE?"Куб":"Шар";
    }

    public override function getCloned():LogicItem {
        return new ShapePredicate(shape);
    }
}
}
