/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import mx.events.DragEvent;

import ru.ipo.kio._15.markov.RuleManager;

public class MovingTile extends Tile{


    private var _moving:Boolean=false;


    public function get moving():Boolean {
        return _moving;
    }

    public function set moving(value:Boolean):void {
        _moving = value;
    }

    private var _rule:Rule = null;

    private var _fictive:Boolean = false;

    private var _temp:Boolean = false;

    private var _startX:int=0;

    private var _startY:int=0;


    public function get temp():Boolean {
        return _temp;
    }

    public function set temp(value:Boolean):void {
        _temp = value;
    }

    public function get fictive():Boolean {
        return _fictive;
    }

    public function set fictive(value:Boolean):void {
        _fictive = value;
    }


    public function MovingTile(symbol:Symbol, rule:Rule=null, fictive:Boolean=false, temp:Boolean = false) {
        super(symbol);
        _temp=temp;
        if(fictive){
            _fictive=fictive;
            return;
        }

        this.rule=rule;
        var tile=this;

        addEventListener(MouseEvent.CLICK, function(e:Event):void{
            if(!RuleManager.instance.edit){
                return;
            }
        });

        addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void{
            if(!RuleManager.instance.edit){
                return;
            }
            if(rule!=null && RuleManager.instance.level!=1){
                return;
            }
            _moving=true;
            startX=x;
            startY=y;
            if(rule!=null) {
                RuleManager.instance.movingTile = tile;
                tile.parent.addChild(tile);
                startDrag(false, new Rectangle(0, 0, SettingsManager.instance.areaWidth, 0));
            }else{
                startDrag(false, new Rectangle(0, 0, SettingsManager.instance.areaWidth, SettingsManager.instance.ruleHeight));
            }

        });

        addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void{
            if(!RuleManager.instance.edit){
                return;
            }
            if(rule!=null && RuleManager.instance.level!=1){
                return;
            }
            if(_moving){
               stopDrag();
                RuleManager.instance.movingTile = null;
                RuleManager.instance.stopMove(tile);
                x=startX;
                y=startY;
            }
        });

        addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent):void{
            RuleManager.instance.move(tile);
        });


    }


    public override function update():void {
        clear();
        if(fictive){
            var width:int = SettingsManager.instance.tileWidth;
            var height:int = SettingsManager.instance.tileHeight;

            graphics.lineStyle(1,0x000000, 0.5);
            graphics.drawRect(0,0,width,height);
            graphics.endFill();

            return;
        }



        var bg = ImageHolder.getVegetable(symbol.code);

        if(select) {
            var bg = ImageHolder.getVegetableSelected(symbol.code);
        }

        if(over && RuleManager.instance.edit) {
            var bg = ImageHolder.getVegetableOver(symbol.code);
        }

        addChild(bg);

        if(RuleManager.instance.edit){
            useHandCursor = true;
        }else{
            useHandCursor = false;
        }


        var tile=this;
        if(rule!=null  && RuleManager.instance.edit && over){
            ImageHolder.createButton(this, "x", 25, 5, function(){
                rule.remove(tile);
                rule.update();
            },  RuleManager.instance.level == 2 ? RuleManager.instance.api.localization.button.delete_element_from_rule : RuleManager.instance.api.localization.button.delete_element_from_direction);
        }
    }


    public function get rule():Rule {
        return _rule;
    }

    public function set rule(value:Rule):void {
        _rule = value;
    }

    public function get startX():int {
        return _startX;
    }

    public function set startX(value:int):void {
        _startX = value;
    }

    public function get startY():int {
        return _startY;
    }

    public function set startY(value:int):void {
        _startY = value;
    }
}
}
