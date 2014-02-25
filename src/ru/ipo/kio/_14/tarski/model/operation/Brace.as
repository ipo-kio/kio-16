/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 05.02.14
 */
package ru.ipo.kio._14.tarski.model.operation {
import ru.ipo.kio._14.tarski.model.predicates.*;

import flash.display.DisplayObject;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.view.BasicView;
import ru.ipo.kio._14.tarski.view.toolbox.LogicItemToolboxView;
import ru.ipo.kio._14.tarski.view.toolbox.ToolboxView;
import ru.ipo.kio._14.tarski.view.statement.LogicItemView;

public class Brace implements LogicItem{

    private var _active:Boolean = false;

    private var logicItemView:LogicItemToolboxView;

    private var logicView:LogicItemView;

    private var _open:Boolean;

    public function Brace(open:Boolean) {
        this._open = open;
        logicItemView = new LogicItemToolboxView(this);
        logicView = new LogicItemView(this);
    }

    public function get open():Boolean {
        return _open;
    }

    public function toString():String {
        return open?"(":")";
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
        return new Brace(open);
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

    public function getTooltipText():String {
        return getToolboxText();
    }
}
}
