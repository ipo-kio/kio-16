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

public class PlainLogicItemView extends BasicView{

    private var logicItem:LogicEvaluatedItem;
    private var text:String;

    public function PlainLogicItemView(logicItem:LogicEvaluatedItem, text: String) {
        this.logicItem = logicItem;
        this.text=text;
    }



    override public function update():void {
        super.update();
        graphics.clear();
        clearAll();
        addChild(createField(text));
        if(logicItem.correct){
            graphics.lineStyle(1,0x00FF00);
        }else{
            graphics.lineStyle(1,0xFF0000);
        }
        graphics.drawRect(0,0,width,height);

    }





}
}
