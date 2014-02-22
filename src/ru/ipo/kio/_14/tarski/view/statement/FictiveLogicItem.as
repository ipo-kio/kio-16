/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 20.02.14
 */
package ru.ipo.kio._14.tarski.view.statement {
import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.view.BasicView;

public class FictiveLogicItem  implements LogicItem{
    public static const IF:String = "ЕСЛИ";

    public static const THEN:String = "ТО";

    private var _couple:FictiveLogicItem;

    private var text:String;

    private var logicView:LogicItemView;

    public function FictiveLogicItem(text:String, couple:FictiveLogicItem) {
        this.text = text;
        this.couple = couple;
        logicView = new LogicItemView(this);
    }


    public function get couple():FictiveLogicItem {
        return _couple;
    }

    public function set couple(value:FictiveLogicItem):void {
        _couple = value;
    }

    public function getToolboxView():BasicView {
        return null;
    }

    public function getToolboxText():String {
        return "?";
    }

    public function getFormulaText():String {
        return text;
    }

    public function getCloned():LogicItem {
        return null;
    }

    public function getView():BasicView {
        return logicView;
    }

    public function commit():void {
    }
}
}
