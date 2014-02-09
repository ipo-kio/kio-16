/**
 * @author: Vasily Akimushkin
 * @since: 06.02.14
 */
package ru.ipo.kio._14.tarski.view.statement {
import ru.ipo.kio._14.tarski.view.*;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.sampler.isGetterSetter;
import flash.text.TextField;
import flash.utils.ByteArray;

import ru.ipo.kio._14.tarski.model.Statement;
import ru.ipo.kio._14.tarski.model.predicates.Variable;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;
import ru.ipo.kio._14.tarski.model.predicates.VariablePlaceHolder;
import ru.ipo.kio._14.tarski.model.operation.LogicEvaluatedItem;
import ru.ipo.kio._14.tarski.model.predicates.OnePlacePredicate;
import ru.ipo.kio._14.tarski.model.predicates.OnePlacePredicate;
import ru.ipo.kio._14.tarski.model.predicates.TwoPlacePredicate;

public class LogicItemView extends BasicView{

    private var logicItem:LogicItem;

    private var overed:Boolean = false;

    public function LogicItemView(logicItem:LogicItem) {
        this.logicItem = logicItem;
        if(logicItem is Variable){
            addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
                Statement.instance.activeVariable= Variable(logicItem);
            })
        }

        if(logicItem is Variable){
        addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void{
            overed=true;
            update();
        });
        addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void{
            overed=false;
            update();
        });
        }
    }



    override public function update():void {
        super.update();
        graphics.clear();
        clearAll();
        var x:int=0;


        if(logicItem is OnePlacePredicate){
            (OnePlacePredicate(logicItem)).placeHolder.view.update();
            x=addChildAndShift((OnePlacePredicate(logicItem)).placeHolder.view, x);
        }

        if(logicItem is TwoPlacePredicate){
            (TwoPlacePredicate(logicItem)).placeHolder1.view.update();
            x=addChildAndShift((TwoPlacePredicate(logicItem)).placeHolder1.view, x);
        }

        x = addChildAndShift(createField(logicItem.getToolboxText()), x);

        if(logicItem is TwoPlacePredicate){
            (TwoPlacePredicate(logicItem)).placeHolder2.view.update();
            x=addChildAndShift((TwoPlacePredicate(logicItem)).placeHolder2.view, x);
        }


        graphics.lineStyle(1,0xFFFFFF);
        graphics.beginFill(0xFFFFFF);
        if(overed){
            graphics.beginFill(0xD7EDFF);
        }

        if(logicItem is Variable && (Variable(logicItem)).active){
            graphics.beginFill(0x76E3FC);
        }

        graphics.drawRect(0,0,width,height);
        graphics.endFill();


    }


}
}
