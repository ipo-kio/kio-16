/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._15.markov.RuleManager;

import ru.ipo.kio.base.displays.ShellButton;

public class Rule extends BasicView{


    private var _number:int=0;

    private var _input:Vector.<MovingTile> = new Vector.<MovingTile>();

    private var _output:Vector.<MovingTile> = new Vector.<MovingTile>();

    private var _valid:Boolean = false;


    public function get valid():Boolean {
        return _valid;
    }

    private var _select:Boolean=false;


    public function get select():Boolean {
        return _select;
    }

    public function set select(value:Boolean):void {
        _select = value;
    }

    public function Rule(number:int) {
        this._number = number;
    }


    public function get number():int {
        return _number;
    }

    public function get input():Vector.<MovingTile> {
        return _input;
    }

    public function get output():Vector.<MovingTile> {
        return _output;
    }

    private function hasFictive(list:Vector.<MovingTile>):Boolean{
        for each(var tile: MovingTile  in list){
         if(tile.fictive){
             return true;
         }
        }
        return false;
}

    private function removeFictive(list:Vector.<MovingTile>):void {
        for each(var tile: MovingTile  in list){
            if(tile.fictive){
                list.splice(list.indexOf(tile), 1);
            }
        }
    }

    private var _simpleButton:SimpleButton;

    public override function update():void{

        if(hasFictive(input) && hasFictive(output)){
            removeFictive(input);
            removeFictive(output);
        }




            if(input.length==0 && output.length==0){
            input.push(new MovingTile(null, null, true));
            output.push(new MovingTile(null, null, true));
        }


        for(var i=0; i<input.length-output.length; i++){
            output.push(new MovingTile(null, null, true));
        }

        for(var i=0; i<output.length-input.length; i++){
            input.push(new MovingTile(null, null, true));
        }

        if(hasFictive(input) || hasFictive(output)){
            _valid=false;
        }else{
            _valid=true;
        }

        clear();
        graphics.lineStyle(0,0xFFFFFF);
        if(select){
            graphics.lineStyle(0,0x43869F);
        }
        if(!_valid){
            graphics.lineStyle(0, 0xFF1493);
        }
        graphics.drawRect(1,0,SettingsManager.instance.ruleWidth-20, SettingsManager.instance.tileHeight);
        addChildTo(createField(number+"", 20),0,(SettingsManager.instance.tileHeight-20)/2);

        _simpleButton = ImageHolder.createButton(this, "X", SettingsManager.instance.ruleWidth - 75, (SettingsManager.instance.tileHeight - 25) / 2, function () {
            RuleManager.instance.rules.splice(RuleManager.instance.rules.indexOf(this), 1);
            RuleManager.instance.update();
        }, RuleManager.instance.level == 2 ? RuleManager.instance.api.localization.button.delete_rule : RuleManager.instance.api.localization.button.delete_direction);

        _simpleButton.enabled=RuleManager.instance.edit;
        _simpleButton.mouseEnabled=RuleManager.instance.edit;
        var shiftX:int = 20;

        for each(var tile: MovingTile  in input){
            tile.update();
            addChildTo(tile, shiftX, 0);
            shiftX+=SettingsManager.instance.tileWidth+1;
        }

        shiftX+=20;
        addChildTo(createField("заменить на", 14), shiftX, (SettingsManager.instance.tileHeight-14)/2);
        shiftX+=105;

        for each(var tile: MovingTile  in output){
            tile.update();
            addChildTo(tile, shiftX, 0);
            shiftX+=SettingsManager.instance.tileWidth+1;
        }

    }



    public function set number(number:int):void {
        _number = number;
    }

    public function consume(ntile:MovingTile, x:int, y:int):Boolean {
        if(input.length>=5 && !hasFictive(input)){

        }else {

            for each(var tile:MovingTile  in _input) {
                if (tile.fictive) {
                    if (x > tile.x && x < tile.x + tile.width &&
                            y > tile.y && y < tile.y + tile.height) {

                        input.splice(input.indexOf(tile), 1, new MovingTile(ntile.symbol, this));
                        return true;
                    }
                    continue;
                }

                if (x > tile.x && x < tile.x + tile.width / 2 &&
                        y > tile.y && y < tile.y + tile.height) {
                    input.splice(input.indexOf(tile), 0, new MovingTile(ntile.symbol, this));
                    return true;
                }
                if (x > tile.x + tile.width / 2 && x < tile.x + tile.width &&
                        y > tile.y && y < tile.y + tile.height) {
                    input.splice(input.indexOf(tile) + 1, 0, new MovingTile(ntile.symbol, this));
                    return true;
                }
            }
        }

        if(output.length>=5 && !hasFictive(output)){

        }else {

            for each(var tile:MovingTile  in _output) {

                if (tile.fictive) {
                    if (x > tile.x && x < tile.x + tile.width &&
                            y > tile.y && y < tile.y + tile.height) {
                        output.splice(output.indexOf(tile), 1, new MovingTile(ntile.symbol, this));
                        return true;
                    }
                    continue;
                }


                if (x > tile.x && x < tile.x + tile.width / 2 &&
                        y > tile.y && y < tile.y + tile.height) {
                    _output.splice(input.indexOf(tile), 0, new MovingTile(ntile.symbol, this));
                    return true;
                }
                if (x > tile.x + tile.width / 2 && x < tile.x + tile.width &&
                        y > tile.y && y < tile.y + tile.height) {
                    _output.splice(input.indexOf(tile) + 1, 0, new MovingTile(ntile.symbol, this));
                    return true;
                }
            }
        }


        return false;
    }

    public function remove(tile:MovingTile):void {
        if(_input.indexOf(tile)>=0){
            _input.splice(_input.indexOf(tile),1, new MovingTile(null, null, true));
        }

        if(_output.indexOf(tile)>=0){
            _output.splice(_output.indexOf(tile),1, new MovingTile(null, null, true));
        }
    }

    public function getStringInput():String {
        var str:String="";
        for each(var tile:Tile in _input){
            str+=tile.symbol.code;
        }
        return str;
    }

    public function getStringOutput():String {
        var str:String="";
        for each(var tile:Tile in _output){
            str+=tile.symbol.code;
        }
        return str;
    }

    public function load(code:String):void{
       var index:int = code.indexOf(":");
       var first:String = code.substr(0,index);
       var second:String = code.substr(index);
        for(var i:int=0; i<first.length; i++){
            var s:Symbol = Symbol.getSymbol(first.charAt(i));
            if(s!=null){
                input.push(new MovingTile(s, this));
            }else{
                input.push(new MovingTile(null, null, true));
            }
        }
        for(var i:int=0; i<second.length; i++){
            var s:Symbol = Symbol.getSymbol(second.charAt(i));
            if(s!=null){
                output.push(new MovingTile(s, this));
            }else{
                output.push(new MovingTile(null, null, true));
            }
        }

    }


    public function toCode():String {
        var result:String = "";
        for each(var tile: MovingTile  in _input){
            if(tile.fictive){
                result+="-";
            }else{
                result+=tile.symbol.code;
            }
        }
        result+=":";
        for each(var tile: MovingTile  in _output){
            if(tile.fictive){
                result+="-";
            }else{
                result+=tile.symbol.code;
            }
        }
        return result;
    }

    public function get simpleButton(): SimpleButton{
        return _simpleButton;
    }
}
}
