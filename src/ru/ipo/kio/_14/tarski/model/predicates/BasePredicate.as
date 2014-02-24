/**
 * Базовый класс для предиката
 *
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;

import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;

public class BasePredicate extends LogicEvaluatedItem implements LogicItem{
    public function BasePredicate() {
    }

    override public function canBeEvaluated():Boolean{
        throw new IllegalOperationError("method must be overridden");
    }

    override public function evaluate(data:Dictionary):Boolean{
        throw new IllegalOperationError("method must be overridden");
    }


    public override function getCloned():LogicItem {
        throw new IllegalOperationError("method must be overridden");
    }

    public override function getFormulaText():String {
        return getToolboxText();
    }

    public function toString():String{
        return "";
    }

}
}
