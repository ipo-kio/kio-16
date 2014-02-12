/**
 * @author: Vasily Akimushkin
 * @since: 06.02.14
 */
package ru.ipo.kio._14.tarski.view.statement {
import flash.text.TextField;

import ru.ipo.kio._14.tarski.view.*;

import flash.events.Event;
import flash.events.MouseEvent;
import ru.ipo.kio._14.tarski.TarskiSprite;

import ru.ipo.kio._14.tarski.model.predicates.VariablePlaceHolder;

public class PlaceHolderView extends BasicView {

    private var placeHolder:VariablePlaceHolder;

    private var overed:Boolean = false;

    private var textField:TextField;

    public function PlaceHolderView(placeHolder:VariablePlaceHolder) {
        this.placeHolder = placeHolder;

         textField = createField("_");
        addChild(textField);
        addEventListener(MouseEvent.CLICK, function(e:Event):void{
            TarskiSprite.instance.statement.activePlaceHolder=placeHolder;
        });

        addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void{
            overed=true;
            update();
        });
        addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void{
            overed=false;
            update();
        });
    }

    public override function update():void{
        graphics.clear();
        if(placeHolder.variable!=null){
            textField.text=placeHolder.variable.code;
        }else{
            textField.text="_";
        }
        if(placeHolder.active){
            graphics.beginFill(0X7DE8E4);
        }else if(overed){
            graphics.beginFill(0xD7EDFF);
        }else{
            graphics.beginFill(0xFFFFFF);
        }
        graphics.drawRect(0,0,20,20);
    }





}
}
