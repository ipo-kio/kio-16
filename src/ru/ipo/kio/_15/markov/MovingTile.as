/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

public class MovingTile extends Tile{


    private var moving:Boolean=false;

    private var _rule:Rule = null;

    private var _fictive:Boolean = false;

    private var _startX:int=0;

    private var _startY:int=0;



    public function get fictive():Boolean {
        return _fictive;
    }

    public function set fictive(value:Boolean):void {
        _fictive = value;
    }

    public function MovingTile(symbol:Symbol, rule:Rule=null, fictive:Boolean=false) {
        super(symbol);
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
            if(rule!=null){
                rule.remove(tile);
                rule.update();
            }
        });

        addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void{
            if(!RuleManager.instance.edit){
                return;
            }
            moving=true;
            startX=x;
            startY=y;
                    startDrag(false,new Rectangle(0,0, SettingsManager.instance.areaWidth, SettingsManager.instance.ruleHeight));

        });

        addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void{
            if(!RuleManager.instance.edit){
                return;
            }
            if(moving){
               stopDrag();
                RuleManager.instance.stopMove(tile);
                x=startX;
                y=startY;
            }
        });
    }


    public override function update():void {
        clear();
        if(fictive){
            var width:int = SettingsManager.instance.tileWidth;
            var height:int = SettingsManager.instance.tileHeight;

            graphics.lineStyle(1,0xCCCCCC);
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
