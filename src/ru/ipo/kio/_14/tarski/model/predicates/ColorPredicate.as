/**
 * Предикат, проверяющий цвет объекта
 *
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;

import ru.ipo.kio._14.tarski.model.properties.ColorValue;
import ru.ipo.kio._14.tarski.model.properties.Colorable;

public class ColorPredicate extends OnePlacePredicate{

    /**
     * Проверяемый цвет
     */
    private var color:ColorValue;


     public function ColorPredicate(color:ColorValue) {
        this.color = color;
         super();
    }



    override public function canBeEvaluated():Boolean {
        return formalOperand!=null;
    }

    override public function evaluate(data:Dictionary):Boolean {
        var operand:Colorable=data[formalOperand];
        if(operand==null){
            throw new IllegalOperationError("operand must be not null");
        }
        return color.code==operand.color.code;
    }

    public function toString():String {
        return "[color-"+color.code+":"+formalOperand+"]";
    }

    public override function getToolboxText():String {
        return color.code==ColorValue.RED?"Красный":"Синий";
    }

    public override function getCloned():LogicItem {
        return new ColorPredicate(color);
    }
}
}
