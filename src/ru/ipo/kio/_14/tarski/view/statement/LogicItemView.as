/**
 * @author: Vasily Akimushkin
 * @since: 06.02.14
 */
package ru.ipo.kio._14.tarski.view.statement {
import flashx.textLayout.events.DamageEvent;

import ru.ipo.kio._14.tarski.model.quantifiers.Quantifier;
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
import ru.ipo.kio._14.tarski.TarskiSprite;

public class LogicItemView extends BasicView{

    private var logicItem:LogicItem;

    private var overed:Boolean = false;

    public function LogicItemView(logicItem:LogicItem) {
        this.logicItem = logicItem;
        if(logicItem is Variable){
            addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
                TarskiSprite.instance.statement.activeVariable= Variable(logicItem);
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
        x = buildView(x);
        graphics.lineStyle(1,0xFFFFFF,0);
        graphics.beginFill(0xFFFFFF,0);
        if(overed){
            graphics.beginFill(0xD7EDFF);
        }

        if(logicItem is Variable && (Variable(logicItem)).active){
            graphics.beginFill(0x76E3FC);
        }

        graphics.drawRect(0,0,width,height);
        graphics.endFill();


    }

    private function buildView(x:int):int {
        var text:String = logicItem.getFormulaText();

        //если нет разделителей проставляем дефолтные
        if(text.indexOf("_")==-1){
            if(getFirstPlaceHolder()!=null){
                text="_"+text;
            }
            if(getSecondPlaceHolder()!=null){
                text=text+"_";
            }
        }

        var parts:Array = text.split("_");
        holderCounter=0;

        for(var i:int=0; i<parts.length; i++){
            if(parts[i]!=""){
               x = addChildAndShift(createField(parts[i]), x);
            }
            if(parts[i]=="" && i==parts.length-1){
                break;
            }
            if(hasNextPlaceHolder()){
                x = addChildAndShift(getNextPlaceHolder(), x);
            }
        }

        return x;
    }

    private var holderCounter:int=0;

    private function hasNextPlaceHolder():Boolean {
        var counter:int=holderCounter;
        var view:DisplayObject = getNextPlaceHolder();
        holderCounter=counter;
        return view!=null;
    }

    private function getNextPlaceHolder():DisplayObject {
        if(holderCounter==0){
            holderCounter++;
            return getFirstPlaceHolder()!=null?getFirstPlaceHolder():getSecondPlaceHolder();
        }else if(holderCounter==1){
            holderCounter++;
            return getFirstPlaceHolder()!=null?getSecondPlaceHolder():null;
        }else{
            return null;
        }
    }




    private function buildViewDefault(x:int):int {
        if (logicItem is OnePlacePredicate) {
            (OnePlacePredicate(logicItem)).placeHolder.view.update();
            x = addChildAndShift((OnePlacePredicate(logicItem)).placeHolder.view, x);
        }

        if (logicItem is TwoPlacePredicate) {
            (TwoPlacePredicate(logicItem)).placeHolder1.view.update();
            x = addChildAndShift((TwoPlacePredicate(logicItem)).placeHolder1.view, x);
        }

        x = addChildAndShift(createField(logicItem.getFormulaText()), x);

        if (logicItem is TwoPlacePredicate) {
            (TwoPlacePredicate(logicItem)).placeHolder2.view.update();
            x = addChildAndShift((TwoPlacePredicate(logicItem)).placeHolder2.view, x);
        }

        if (logicItem is Quantifier) {
            (Quantifier(logicItem)).placeHolder.view.update();
            x = addChildAndShift((Quantifier(logicItem)).placeHolder.view, x);
        }
        return x;
    }


    private function getFirstPlaceHolder():BasicView{
        if (logicItem is OnePlacePredicate) {
            (OnePlacePredicate(logicItem)).placeHolder.view.update();
            return (OnePlacePredicate(logicItem)).placeHolder.view;
        }

        if (logicItem is TwoPlacePredicate) {
            (TwoPlacePredicate(logicItem)).placeHolder1.view.update();
            return (TwoPlacePredicate(logicItem)).placeHolder1.view;
        }

        return null;
    }

    private function getSecondPlaceHolder():BasicView{
        if (logicItem is TwoPlacePredicate) {
            (TwoPlacePredicate(logicItem)).placeHolder2.view.update();
           return (TwoPlacePredicate(logicItem)).placeHolder2.view;
        }

        if (logicItem is Quantifier) {
            (Quantifier(logicItem)).placeHolder.view.update();
            return (Quantifier(logicItem)).placeHolder.view;
        }
        return null;
    }


}
}
