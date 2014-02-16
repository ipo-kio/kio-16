
/**
 * Сущность, у которой можно вычислить логическое значение
 *
 * @author: Vasily Akimushkin
 * @since: 21.01.14
 */
package ru.ipo.kio._14.tarski.model.operation {
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import ru.ipo.kio._14.tarski.model.Figure;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.quantifiers.Quantifier;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.toolbox.LogicItemToolboxView;
import ru.ipo.kio._14.tarski.view.statement.LogicItemView;

public class LogicEvaluatedItem implements LogicItem{

    private var _quants:Vector.<Quantifier> = new Vector.<Quantifier>();

    protected var itemToolboxView:LogicItemToolboxView;

    protected var itemView:LogicItemView;

    public function LogicEvaluatedItem() {
        itemToolboxView = new LogicItemToolboxView(this);
        itemView = new LogicItemView(this);
    }

    protected function quantsToSts(): String{
        var quants:String = "";
        for(var i:int=0; i<_quants.length; i++){
          quants+=_quants[i].toString();
        }
        return quants;
    }

    public function get quants():Vector.<Quantifier> {
        return _quants;
    }


    public function set quants(value:Vector.<Quantifier>):void {
        _quants = value;
    }

    protected function isRegisteredIndex(i:int, figures:Vector.<Figure>, data:Dictionary):Boolean {
        var figure:Figure = figures[i];
        for (var kk:Object in data) {
              if(data[kk]==figure){
                  return true;
              }
        }
        return false;
    }

    protected function isAll(formalOperand:String):Boolean {
        for(var i:int=0; i<_quants.length; i++){
            if(_quants[i].placeHolder.variable!=null &&
                    _quants[i].placeHolder.variable.code==formalOperand &&
                    _quants[i].code==Quantifier.ALL){
                return true;
            }
        }
        return false;
    }

    protected function isOne(formalOperand:String):Boolean{
        for(var i:int=0; i<_quants.length; i++){
            if(_quants[i].placeHolder.variable!=null &&
                    _quants[i].placeHolder.variable.code==formalOperand &&
                    _quants[i].code==Quantifier.EXIST){
                return true;
            }
        }
        return false;
    }

    public function checkQuantors(quantors:Vector.<Quantifier>):Boolean{
       return false;
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
     * @param data - набор переменных
     * @return
     */
    public function evaluate(data:Dictionary):Boolean{
        throw new IllegalOperationError("method must be overridden");
    }

    /**
     * Вычисляет выражение на наборе данных
     * @param data - набор зафиксированныз переменных (код-индекс)
     * @param figures - список фигур
     * @return
     */
    public function evaluateWithQuants(data:Dictionary, figures:Vector.<Figure>):Boolean{
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
