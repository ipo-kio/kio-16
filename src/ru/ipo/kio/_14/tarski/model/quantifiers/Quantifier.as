/**
 * @author: Vasily Akimushkin
 * @since: 31.01.14
 */
package ru.ipo.kio._14.tarski.model.quantifiers {
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.predicates.VariablePlaceHolder;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.statement.LogicItemView;
import ru.ipo.kio._14.tarski.view.toolbox.LogicItemToolboxView;

public class Quantifier implements LogicItem {

    public static const ALL:String = "all";
    public static const EXIST:String = "exist";

    private var _placeHolder:VariablePlaceHolder;

    private var _priority:int=5;


    public function resetPriority():void{
        _priority=5;
    }


    public function get priority():int {
        return _priority;
    }

    public function set priority(value:int):void {
        _priority = value;
    }



    protected var itemToolboxView:LogicItemToolboxView;

    protected var itemView:LogicItemView;

    private var _code:String;


    public function toString():String {
        return (_code==EXIST?"E":"A") + (placeHolder.variable!=null?placeHolder.variable.code:"_");
    }

    public function Quantifier(code:String) {
        this._code = code;
        itemToolboxView = new LogicItemToolboxView(this);
        itemView = new LogicItemView(this);
        _placeHolder=new VariablePlaceHolder(this);
    }


    public function get placeHolder():VariablePlaceHolder {
        return _placeHolder;
    }


    public function get code():String {
        return _code;
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

    public function getToolboxView():BasicView {
        return itemToolboxView;
    }

    public function getToolboxText():String {
        return _code==EXIST?"СУЩЕСТВУЕТ ":"ДЛЯ ВСЕХ ";
    }

    public function getFormulaText():String {
        return _code==EXIST?"СУЩЕСТВУЕТ_ТАКОЙ ЧТО":"ДЛЯ ВСЕХ_";
    }

    public function getCloned():LogicItem {
        return new Quantifier(_code);
    }

    public function getView():BasicView {
        return itemView;
    }

    public function commit():void {
        if(_placeHolder.variable!=null){
            _formalOperand=_placeHolder.variable.code;
        }
    }


}
}
