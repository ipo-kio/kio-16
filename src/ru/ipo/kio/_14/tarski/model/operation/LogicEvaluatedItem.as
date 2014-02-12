
/**
 * Сущность, у которой можно вычислить логическое значение
 *
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.operation {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.toolbox.LogicItemToolboxView;
import ru.ipo.kio._14.tarski.view.statement.LogicItemView;

public class LogicEvaluatedItem implements LogicItem{

    protected var itemToolboxView:LogicItemToolboxView;

    protected var itemView:LogicItemView;

    public function LogicEvaluatedItem() {
        itemToolboxView = new LogicItemToolboxView(this);
        itemView = new LogicItemView(this);
    }

    /**
     * Можно ли пытаться вычислить выражение, завершено ли они
     * @return
     */
    public function canBeEvaluated():Boolean{
        throw new IllegalOperationError("method must be overridden");
    }

    /**
     * Вычисляет выражение на наборе данных
     * @param data
     * @return
     */
    public function evaluate(data:Dictionary):Boolean{
        throw new IllegalOperationError("method must be overridden");
    }

    /**
     * Собирает в хэш список формальных параметров
     * @return
     */
    public function collectFormalOperand():Dictionary{
        throw new IllegalOperationError("method must be overridden");
    }

    public function getToolboxText():String {
        throw new IllegalOperationError("method must be overridden");
    }

    public function commit():void {
        throw new IllegalOperationError("method must be overridden");
    }

    public function getCloned():LogicItem {
        throw new IllegalOperationError("method must be overridden");
    }

    public function getView():BasicView {
        return itemView;
    }

    public function getToolboxView():BasicView {
        return itemToolboxView;
    }

}
}
