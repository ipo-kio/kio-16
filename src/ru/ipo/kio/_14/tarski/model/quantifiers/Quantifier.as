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


    protected var itemToolboxView:LogicItemToolboxView;

    protected var itemView:LogicItemView;

    private var code:String;


    public function Quantifier(code:String) {
        this.code = code;
        itemToolboxView = new LogicItemToolboxView(this);
        itemView = new LogicItemView(this);
        _placeHolder=new VariablePlaceHolder(this);
    }


    public function get placeHolder():VariablePlaceHolder {
        return _placeHolder;
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
        return "Существует ";
    }

    public function getCloned():LogicItem {
        return new Quantifier(code);
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
