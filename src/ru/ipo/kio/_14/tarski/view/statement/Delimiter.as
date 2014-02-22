/**
 *
 * @author: Vasily Akimushkin <vasiliy.akimushkin@gmail.com>
 * @date: 09.02.14
 */
package ru.ipo.kio._14.tarski.view.statement {
import ru.ipo.kio._14.tarski.TarskiSprite;
import ru.ipo.kio._14.tarski.view.*;

import flash.events.MouseEvent;

import ru.ipo.kio._14.tarski.model.Statement;

import ru.ipo.kio._14.tarski.model.editor.LogicItem;

public class Delimiter extends BasicView {

    private var _active:Boolean = false;

    private var _beforeItem:LogicItem;

    private var _afterItem:LogicItem;

    private var _self:Delimiter;

    private var overed:Boolean = false;

    private var statement:Statement;

    public function Delimiter(statement:Statement) {
        update();

        _self=this;

        this.statement=statement;

        addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
            if(statement!=TarskiSprite.instance.statementManager.statement){
                TarskiSprite.instance.statementManager.activate(statement);
                statement.setLastItemBefore(_self);
            }else{
                statement.activeDelimiter=_self;
            }
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
        graphics.lineStyle(0,0xFFFFFF,0);
        if(overed){
            graphics.beginFill(0xD7EDFF);
        }else{
            graphics.beginFill(0xffffff,0);
        }
        graphics.drawRect(0,0,10,30);
        graphics.endFill();

        if(active && statement.active){
            graphics.lineStyle(2,0x000000);
            graphics.moveTo(5,0);
            graphics.lineTo(5,30);
        }
    }



    public function get active():Boolean {
        return _active;
    }

    public function set active(value:Boolean):void {
        _active = value;
    }

    public function get beforeItem():LogicItem {
        return _beforeItem;
    }

    public function set beforeItem(value:LogicItem):void {
        _beforeItem = value;
    }

    public function get afterItem():LogicItem {
        return _afterItem;
    }

    public function set afterItem(value:LogicItem):void {
        _afterItem = value;
    }
}
}
