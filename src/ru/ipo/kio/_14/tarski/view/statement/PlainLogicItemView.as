/**
 * @author: Vasily Akimushkin
 * @since: 06.02.14
 */
package ru.ipo.kio._14.tarski.view.statement {
import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;
import ru.ipo.kio._14.tarski.view.*;

public class PlainLogicItemView extends BasicView{

    private var logicItem:LogicEvaluatedItem;
    private var text:String;

    [Embed(source="../../_resources/level0/ok.png")]
    private static const OK:Class;

    [Embed(source="../../_resources/level0/not_ok.png")]
    private static const NOTOK:Class;


    public function PlainLogicItemView(logicItem:LogicEvaluatedItem, text: String) {
        this.logicItem = logicItem;
        this.text=text;
    }

    override public function update():void {
        super.update();
        graphics.clear();
        clearAll();
        addChildTo(createField(text,13),30,0);
        if(logicItem.correct){
           addChildTo(new OK, 10,3);
        }else{
          addChildTo(new NOTOK, 10,3);
        }
        graphics.drawRect(0,0,width,height);

    }

}
}
