/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 24.02.14
 */
package ru.ipo.kio._14.tarski.view.construct {
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.ipo.kio._13.clock.view.BasicView;
import ru.ipo.kio._14.tarski.utils.FormUtils;

public class ResultPanel extends BasicView {

    private var statementsField:TextField;

    private var figuresField:TextField;

    private var statementsFieldRecord:TextField;

    private var figuresFieldRecord:TextField;


    public function ResultPanel() {
        addChild(FormUtils.createLabel("Рекорд:",20,10));
        addChild(FormUtils.createLabel("Выполнено условий:",20,40));
        addChild(FormUtils.createLabel("Количество фигур:",20,80));

        statementsFieldRecord = FormUtils.createLabel("",180,40);
        figuresFieldRecord = FormUtils.createLabel("",180,80);
        addChild(statementsFieldRecord);
        addChild(figuresFieldRecord);

        addChild(FormUtils.createLabel("Текущий:",20,135));
        addChild(FormUtils.createLabel("Выполнено условий:",20,165));
        addChild(FormUtils.createLabel("Количество фигур:",20,205));

        statementsField = FormUtils.createLabel("",180,165);
        figuresField = FormUtils.createLabel("",180,205);
        addChild(statementsField);
        addChild(figuresField);


    }

    public function updateResult(correctStatements:String, amountOfFigures:String):void{
        statementsField.text=correctStatements;
        figuresField.text=amountOfFigures;
    }

    public function updateBest(correctStatements:String, amountOfFigures:String):void{
        statementsFieldRecord.text=correctStatements;
        figuresFieldRecord.text=amountOfFigures;
    }



}
}
