/**
 * @author: Vasily Akimushkin
 * @since: 06.02.14
 */
package ru.ipo.kio._14.tarski.view.toolbox {
import fl.controls.Button;

import flash.display.Sprite;

import ru.ipo.kio._14.tarski.TarskiProblemFirst;
import ru.ipo.kio._14.tarski.view.*;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;


import ru.ipo.kio._14.tarski.model.editor.LogicItem;

public class LogicItemToolboxView extends BasicView{

    private var logicItem:LogicItem;

    private var overed:Boolean = false;

    private var active:Boolean = true;

    public function LogicItemToolboxView(logicItem:LogicItem) {
        this.logicItem = logicItem;

        var field:TextField = new TextField();
        field.background=false;
        field.selectable=false;
        field.text=logicItem.getToolboxText();
        field.width=field.textWidth+7;
        field.height=field.textHeight+7;

        var button:Button = new Button();
        button.label=logicItem.getTooltipText();
        button.width=field.width;
        button.x = 0;
        button.y = 0;
        addChild(button);



//        addChild(field);


        addEventListener(MouseEvent.CLICK, function(e:Event):void{
            TarskiProblemFirst.instance.statement.addLogicItem(logicItem.getCloned());
        });


//        addEventListener(MouseEvent.ROLL_OVER, function(e:Event):void{
//            if(active){
//                overed=true;
//                update();
//            }
//        });
//
//        addEventListener(MouseEvent.ROLL_OUT, function(e:Event):void{
//            overed=false;
//            update();
//        });
//
//        update();

    }

//    override public function update():void {
//        super.update();
//
//        graphics.clear();
//
//        graphics.lineStyle(2,0x99593D);
//        graphics.beginFill(0xF8F79F);
//        if(overed){
//            graphics.beginFill(0xFFFB1E);
//        }
//        graphics.drawRoundRect(0,0,width,height,width-5,height-5);
//        graphics.endFill();
//
//        useHandCursor=true;
//    }
}
}
