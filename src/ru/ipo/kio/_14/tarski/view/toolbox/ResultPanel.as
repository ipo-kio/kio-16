/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 24.02.14
 */
package ru.ipo.kio._14.tarski.view.toolbox {
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.ipo.kio._13.clock.view.BasicView;
import ru.ipo.kio._14.tarski.utils.FormUtils;

public class ResultPanel extends BasicView {

    private var configField:TextField;

    private var lengthField:TextField;

    private var configFieldRecord:TextField;

    private var lengthFieldRecord:TextField;


    public function ResultPanel() {

        addChild(FormUtils.createLabel("Текущий:",10,10));
        addChild(FormUtils.createLabel("Выбрано конфигураций:",100,10));
        addChild(FormUtils.createLabel("Длина:",300,10));

        configField = FormUtils.createLabel("",270,10);
        lengthField = FormUtils.createLabel("",350,10);
        addChild(configField);
        addChild(lengthField);

        addChild(FormUtils.createLabel("Рекорд:",400,10));
        addChild(FormUtils.createLabel("Выбрано конфигураций:",500,10));
        addChild(FormUtils.createLabel("Длина:",700,10));

        configFieldRecord = FormUtils.createLabel("",670,10);
        lengthFieldRecord = FormUtils.createLabel("",750,10);
        addChild(configFieldRecord);
        addChild(lengthFieldRecord);




    }

    public function updateResult(statements:String, length:String):void{
        configField.text=statements;
        lengthField.text=length;
    }

    public function updateBest(statements:String, length:String):void{
        configFieldRecord.text=statements;
        lengthFieldRecord.text=length;
    }



}
}
