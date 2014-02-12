/**
 * @author: Vasily Akimushkin
 * @since: 06.02.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.statement.PlaceHolderView;

public class VariablePlaceHolder{

    private var _active:Boolean=false;

    private var _view:BasicView;

    private var _predicate:LogicItem;

    public function VariablePlaceHolder(predicate:LogicItem) {
        _predicate = predicate;
        _view= new PlaceHolderView(this);
    }


    public function get predicate():LogicItem {
        return _predicate;
    }

    public function get view():BasicView {
        return _view;
    }

    public function get active():Boolean {
        return _active;
    }

    public function set active(value:Boolean):void {
        _active = value;
    }

    private var _variable:Variable;

    public function get variable():Variable {
        return _variable;
    }

    public function set variable(value:Variable):void {
        _variable = value;
    }
}
}
