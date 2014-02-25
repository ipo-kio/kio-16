/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 24.02.14
 */
package ru.ipo.kio._14.tarski.view.toolbox {
import com.nerdbucket.ToolTip;

import flash.events.MouseEvent;
import flash.text.TextField;

import ru.ipo.kio._14.tarski.utils.FormUtils;
import ru.ipo.kio._14.tarski.view.BasicView;

public class ResultPanel extends BasicView {

    private var configField:TextField;

    private var lengthField:TextField;

    private var configFieldRecord:TextField;

    private var lengthFieldRecord:TextField;


    public function ResultPanel() {

        addChild(FormUtils.createLabel("Текущий:",10,10,20,true));
        var label2:TextField =FormUtils.createLabel("Выполнено условий:",100-5-5,10)
        addChild(label2);
        ToolTip.attach(label2, "число домиков, удовлетворяющих условиям, в поселке слева + число  домиков, не удовлетворяющих условию, в поселке справа");

        var label1:TextField =FormUtils.createLabel("Длина условия:",270-5-5,10);
        addChild(label1);
        ToolTip.attach(label1, "суммарное количество использованных логических операций и отношений");

        configField = FormUtils.createLabel("",250-8-5,10,20,true);
        lengthField = FormUtils.createLabel("",370-5,10,20,true);
        addChild(configField);
        addChild(lengthField);

        addChild(FormUtils.createLabel("Рекорд:",400-5-5,10,20,true));
        var labelr2:TextField =FormUtils.createLabel("Выполнено условий:",500-15-5,10);
        addChild(labelr2);
        ToolTip.attach(labelr2, "число домиков, удовлетворяющих условиям, в поселке слева + число  домиков, не удовлетворяющих условию, в поселке справа");
        var labelr1:TextField = FormUtils.createLabel("Длина условия:",670-20-5,10);
        addChild(labelr1);
        ToolTip.attach(labelr1, "суммарное количество использованных логических операций и отношений");

        configFieldRecord = FormUtils.createLabel("",650-23-5,10,20,true);
        lengthFieldRecord = FormUtils.createLabel("",770-20,10,20,true);
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
