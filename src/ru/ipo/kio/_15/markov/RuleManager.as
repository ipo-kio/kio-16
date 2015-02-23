/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import bkde.as3.parsers.CompiledObject;
import bkde.as3.parsers.MathParser;

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

    public var movingTile:MovingTile;

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
        rules.push(new Rule(_rules.length));
        rules.push(new Rule(_rules.length));
        rules.push(new Rule(_rules.length));
    }


    public function get rules():Vector.<Rule> {
        return _rules;
    }

    public function set rules(value:Vector.<Rule>):void {
        _rules = value;
    }

    private var verticalPosition:int=0;

    private var horizontalPosition:int=0;

    private var _simpleButton:SimpleButton;

    public override function update():void{
        clear();

        _scrollPane =new MyScrollPane();
//        _scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
//        _scrollPane.horizontalScrollPolicy = ScrollPolicy.AUTO;
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

        if(RuleManager._instance.level==1){
            var tile:MovingTile = new MovingTile(Symbol.dictionary["o"]);
            tile.update();
            addChildTo(tile, 0, shiftY);
            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace+10;
            var tile1:MovingTile = new MovingTile(Symbol.dictionary["a"]);
            tile1.update();
            addChildTo(tile1, 0, shiftY);

        }else {

            for (var k:Object in Symbol.dictionary) {
                var tile:MovingTile = new MovingTile(Symbol.dictionary[k]);
                tile.update();
                addChildTo(tile, 0, shiftY);
                shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;
            }
        }

        _simpleButton = ImageHolder.createButton(this, "+", SettingsManager.instance.areaWidth - 50 - (16), SettingsManager.instance.ruleHeight+11, function () {
            rules.push(new Rule(_rules.length));
            update();
        }, level == 2 ? _api.localization.button.add_rule : _api.localization.button.add_direction);

        NormalButton(_simpleButton).enable(edit);

    }

    public function move(tile:MovingTile):void {
        verticalPosition=_scrollPane.verticalScrollPosition;
        horizontalPosition=_scrollPane.horizontalScrollPosition;
        if(tile.moving && tile.rule==null){


            for each(var rule:Rule in rules){
                if(rule.consumeMove(tile, tile.x+tile.width/2-_scrollPane.x+horizontalPosition, tile.y-rule.y+tile.height/2+verticalPosition)){
                    rule.draw();
                    _scrollPane.refreshPane();
                    break;
                }
            }
        }

    }

    public function stopMove(tile:MovingTile):void {
        verticalPosition=_scrollPane.verticalScrollPosition;
        horizontalPosition=_scrollPane.horizontalScrollPosition;
//        if(tile.rule==null){
            for each(var rule:Rule in rules){
               if(rule.consume(tile, tile.x+tile.width/2+(tile.rule==null?-_scrollPane.x+horizontalPosition:0), tile.y+tile.height/2+(tile.rule==null?-rule.y+verticalPosition:0))){
                   rulesUpdate();
                   _scrollPane.refreshPane();
                   break;
               }
            }
//        }
//        update();

    }

    private function rulesUpdate(){
        for each(var rule:Rule in rules){
            rule.update();
        }
    }

    public function next():void {


    }


    public function hasRule(_workingRidge:Ridge):Boolean {
        return getRule(_workingRidge)!=null;
    }

    public function getRule(_workingRidge:Ridge):Rule {
        var ridge:String = _workingRidge.getString();
        for each(var rule:Rule in rules){
            if(!rule.empty && ridge.indexOf(rule.getStringInput())>=0){
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

        NormalButton(_simpleButton).enable(!b);
            for each(var rule:Rule in rules) {
                NormalButton(rule.deleteButton).enable(!b);
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

    private var _examples:Vector.<String> = new Vector.<String>();


    public function get examples():Vector.<String> {
        return _examples;
    }

    public function set examples(value:Vector.<String>):void {
        _examples = value;
    }

    public function loadExamples():void {
        //первые пять пользователь будет видеть

        _examples.push("1+1-1+1-1+1+1-1");
        _examples.push("1-1+1-1+1");
        _examples.push("1+1+1-1-1");
        _examples.push("(1-1+1)+(1+1-1)");
        _examples.push("1+(((1-1)-1)+1)");

        var example:String = "";
        while (_examples.length<200){
            if(example.indexOf("ex")<0){
                var parser:MathParser = new MathParser([]);
                var compiledObj:CompiledObject = parser.doCompile(example);
                var answer:Number = parser.doEval(compiledObj.PolishArray, []);
                if(_examples.indexOf(example)<0 && ( answer==0 || answer==1 || answer==2 )){
                    _examples.push(example);
                    trace(_examples.length+": "+ example);
                }
                example = "";
            }else if(example.length>20){
                example = "";
            }
            example = genExample(example);
        }



    }

    private function genExample(example:String):String {
        if(example==""){
            return randExample();
        }else if(example.indexOf("ex")>=0){
            var index:int = example.indexOf("ex");
            var result:String = example.substr(0,index);
            result+=randExample();
            result+= example.substr(index+2);
            return result;
        }
        return example;
    }

    private function randExample():String {
        var rand:Number =  Math.random();
        if(rand<0.2){
            return "1+ex";
        }else if (rand<0.4){
            return "1-ex";
        }else if (rand<0.6){
            return "(ex+ex)";
        }else if (rand<0.8){
            return "(ex-ex)";
        }else{
            return "1";
        }
    }


    public function correct(str:String):Boolean {
        var parser:MathParser = new MathParser([]);
        var compiledObj:CompiledObject = parser.doCompile(str);
        var answer:Number = parser.doEval(compiledObj.PolishArray, []);

        while(getRuleStr(str)!=null){
            str = applyRuleStr(str);
        }

        return (answer+""==str);


    }


    public function getRuleStr(str:String):Rule {
        for each(var rule:Rule in rules){
            if(!rule.empty && str.indexOf(rule.getStringInput())>=0){
                return rule;
            }
        }
        return null;
    }

    public function applyRuleStr(str:String):String {
        var rule:Rule = getRuleStr(str);
        var index:int = str.indexOf(rule.getStringInput());

        var newstr = str.substr(0, index);
        for (var i:int=0; i<rule.output.length; i++){
            newstr+= rule.output[i].symbol;
        }
        newstr+=str.substr(index+rule.getStringInput().length);

        RuleManager.instance.result.oper++;

        return newstr;


    }
}
}
