/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import fl.containers.ScrollPane;

import flash.display.SimpleButton;

import flash.display.Sprite;

import flash.events.Event;
import flash.events.MouseEvent;
import flashx.textLayout.container.ScrollPolicy;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.base.displays.ShellButton;

public class RuleManager extends BasicView {

    private static var _instance:RuleManager = new RuleManager();
    private var _api :KioApi;

    private var _level:int;

    public static function get instance():RuleManager {
        return _instance;
    }


    public function get level():int {
        return _level;
    }

    public function set level(value:int):void {
        _level = value;
    }

    public function get api():KioApi {
        return _api;
    }

    public function set api(value:KioApi):void {
        _api = value;
    }

    private var _scrollPane:ScrollPane = new MyScrollPane();

    private var _canvas:BasicView = new BasicView();

    private var _rules:Vector.<Rule> = new Vector.<Rule>();

    private var _edit:Boolean = true;

    private var _finish:Boolean = false;


    public function get finish():Boolean {
        return _finish;
    }

    public function set finish(value:Boolean):void {
        _finish = value;
    }

    private var _result:Level0Data = new Level0Data();


    public function get result():Level0Data {
        return _result;
    }

    public function set result(value:Level0Data):void {
        _result = value;
    }

    public function RuleManager() {



    }


    public function get rules():Vector.<Rule> {
        return _rules;
    }

    public function set rules(value:Vector.<Rule>):void {
        _rules = value;
    }

    private var verticalPosition:int=0;

    private var _simpleButton:SimpleButton;

    public override function update():void{
        clear();

        _scrollPane =new MyScrollPane();
        _scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
        _scrollPane.x=SettingsManager.instance.tileWidth;
        _scrollPane.y=0;
        _scrollPane.width=SettingsManager.instance.ruleWidth;
        _scrollPane.height=SettingsManager.instance.ruleHeight;
        _scrollPane.scrollDrag=true;



        _canvas = new BasicView();
        _canvas.x=0;
        _canvas.y=0;

        var shiftY:int=0;
        for each(var rule:Rule in rules){
            rule.number=_rules.indexOf(rule)+1;
            rule.update();
            _canvas.addChildTo(rule, 0, shiftY);
            shiftY+=SettingsManager.instance.tileHeight+SettingsManager.instance.space;
        }
        _scrollPane.source=_canvas;

        _scrollPane.refreshPane();

        addChild(_scrollPane);

//        _scrollPane.verticalScrollPosition= verticalPosition;


        shiftY=0;
        for(var k:Object in Symbol.dictionary){
            var tile:MovingTile = new MovingTile(Symbol.dictionary[k]);
            tile.update();
            addChildTo(tile, 0, shiftY);
            shiftY+=SettingsManager.instance.tileHeight+SettingsManager.instance.smallSpace;
        }

        _simpleButton = ImageHolder.createButton(this, "+", SettingsManager.instance.areaWidth - 50, shiftY, function () {
            rules.push(new Rule(_rules.length));
            update();
        }, level == 2 ? _api.localization.button.add_rule : _api.localization.button.add_direction);

        _simpleButton.enabled=edit;
        _simpleButton.mouseEnabled=edit;

    }

    public function stopMove(tile:MovingTile):void {
        verticalPosition=_scrollPane.verticalScrollPosition;
        if(tile.rule==null){
            var added:Boolean = false;
            for each(var rule:Rule in rules){
               if(rule.consume(tile, tile.x+tile.width/2-_scrollPane.x, tile.y-rule.y+tile.height/2+verticalPosition)){
                   added=true;
                   rule.update();
                   break;
               }
            }
            if(!added) {
                for each(var rule:Rule in rules) {
                    if (rule.consume(tile, tile.x - _scrollPane.x, tile.y - rule.y+verticalPosition)) {
                        rule.update();
                        break;
                    }
                }
            }
        }else{
            //проверяем на удаление
        }
//        update();

    }

    public function next():void {


    }


    public function hasRule(_workingRidge:Ridge):Boolean {
        return getRule(_workingRidge)!=null;
    }

    public function getRule(_workingRidge:Ridge):Rule {
        var ridge:String = _workingRidge.getString();
        for each(var rule:Rule in rules){
            if(ridge.indexOf(rule.getStringInput())>=0){
                return rule;
            }
        }
        return null;
    }

    internal function deselect():void {
        for each(var rule:Rule in rules) {
            rule.select = false;
        }
    }

    public function applyRule(_workingRidge:Ridge):void {
        var ridge:String = _workingRidge.getString();
        var rule:Rule = getRule(_workingRidge);
        rule.select=true;
        var index:int = ridge.indexOf(rule.getStringInput());
        _workingRidge.tiles.splice(index, rule.input.length);
        for (var i:int=0; i<rule.output.length; i++){
            _workingRidge.tiles.splice(index+i, 0, new Tile(rule.output[i].symbol, true));
        }

        RuleManager.instance.result.oper++;



    }

    public function get edit():Boolean {
        return _edit;
    }

    public function set edit(value:Boolean):void {
        _edit = value;
    }

    public function setEdit(b:Boolean):void {
        edit=b;

        _simpleButton.enabled=b;
        _simpleButton.mouseEnabled=b;
            for each(var rule:Rule in rules) {
                rule.simpleButton.mouseEnabled=b;
                rule.simpleButton.enabled=b;
            }

    }

    public function isValid():Boolean {
        for each(var rule:Rule in rules){
            if(!rule.valid){
                return false;
            }
        }
        return true;
    }
}
}
