/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 05.02.14
 */
package ru.ipo.kio._14.tarski.model.predicates {
import flash.display.DisplayObject;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.toolbox.LogicItemToolboxView;
import ru.ipo.kio._14.tarski.view.toolbox.ToolboxView;
import ru.ipo.kio._14.tarski.view.statement.LogicItemView;

public class Variable implements LogicItem{

    private var _active:Boolean = false;

    private var _code:String;


    private var logicItemView:LogicItemToolboxView;

    private var logicView:LogicItemView;

    public function Variable(code:String) {
        this._code = code;
        logicItemView = new LogicItemToolboxView(this);
        logicView = new LogicItemView(this);
    }


    public function get code():String {
        return _code;
    }

    public function set code(value:String):void {
        _code = value;
    }

    public function toString():String {
        return _code;
    }

    public function getToolboxText():String {
        return toString();
    }

    public function getToolboxView():BasicView {
        return logicItemView;
    }

    public function commit():void {
    }

    public function getCloned():LogicItem {
        return new Variable(_code);
    }

    public function getView():BasicView {
        return logicView;
    }

    public function set active(value:Boolean):void {
        _active = value;
    }


    public function get active():Boolean {
        return _active;
    }


    public function getFormulaText():String {
        return getToolboxText();
    }
}
}
