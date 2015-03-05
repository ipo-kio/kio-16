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

import ru.ipo.kio._15.markov.RuleManager;

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

    private var _result:ResultData = new ResultData();

    private var _record:ResultData = new ResultData();


    public function get record():ResultData {
        return _record;
    }

    public function set record(value:ResultData):void {
        _record = value;
    }

    public function get result():ResultData {
        return _result;
    }

    public function set result(value:ResultData):void {
        _result = value;
    }

    public function RuleManager() {
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
        _scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
//        _scrollPane.horizontalScrollPolicy = ScrollPolicy.AUTO;
        if(RuleManager._instance.level==2) {
            _scrollPane.x = SettingsManager.instance.tileWidth+35;
        }else{
            _scrollPane.x = SettingsManager.instance.tileWidth;
        }
        _scrollPane.y=0;
        if(RuleManager._instance.level==2) {
            _scrollPane.width = SettingsManager.instance.ruleWidth-15;
        }else{
            _scrollPane.width = SettingsManager.instance.ruleWidth;
        }
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

        if(RuleManager._instance.level==2){
            var tile:MovingTile = new MovingTile(Symbol.dictionary["0"]);
            tile.update();
            addChildTo(tile, 0, shiftY);

            var shift2:int= 35;

            var tile1:MovingTile = new MovingTile(Symbol.dictionary["1"]);
            tile1.update();
            addChildTo(tile1, shift2, shiftY);

            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;

            var tile3:MovingTile = new MovingTile(Symbol.dictionary["A"]);
            tile3.update();
            addChildTo(tile3, 0, shiftY);

            var tile4:MovingTile = new MovingTile(Symbol.dictionary["B"]);
            tile4.update();
            addChildTo(tile4, shift2, shiftY);

            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;

            var tile5:MovingTile = new MovingTile(Symbol.dictionary["+"]);
            tile5.update();
            addChildTo(tile5, 0, shiftY);

            var tile6:MovingTile = new MovingTile(Symbol.dictionary["-"]);
            tile6.update();
            addChildTo(tile6, shift2, shiftY);

            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;

            var tile7:MovingTile = new MovingTile(Symbol.dictionary["("]);
            tile7.update();
            addChildTo(tile7, 0, shiftY);

            var tile8:MovingTile = new MovingTile(Symbol.dictionary[")"]);
            tile8.update();
            addChildTo(tile8, shift2, shiftY);

            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;
            shiftY += SettingsManager.instance.tileHeight/2 + SettingsManager.instance.smallSpace;

            var tile9:MovingTile = new MovingTile(Symbol.dictionary["S"]);
            tile9.update();
            addChildTo(tile9, 0, shiftY);

            var tile11:MovingTile = new MovingTile(Symbol.dictionary["X"]);
            tile11.update();
            addChildTo(tile11, shift2, shiftY);


        }


        else if(RuleManager._instance.level==1){
            var tile:MovingTile = new MovingTile(Symbol.dictionary["L"]);
            tile.update();
            addChildTo(tile, 0, shiftY);

            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;

            var tile1:MovingTile = new MovingTile(Symbol.dictionary["K"]);
            tile1.update();
            addChildTo(tile1, 0, shiftY);

            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;

            var tile2:MovingTile = new MovingTile(Symbol.dictionary["l"]);
            tile2.update();
            addChildTo(tile2, 0, shiftY);

            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;

            var tile3:MovingTile = new MovingTile(Symbol.dictionary["k"]);
            tile3.update();
            addChildTo(tile3, 0, shiftY);

            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;

            var tile4:MovingTile = new MovingTile(Symbol.dictionary["b"]);
            tile4.update();
            addChildTo(tile4, 0, shiftY);

            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;

            var tile5:MovingTile = new MovingTile(Symbol.dictionary["p"]);
            tile5.update();
            addChildTo(tile5, 0, shiftY);

            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;

            var tile6:MovingTile = new MovingTile(Symbol.dictionary["n"]);
            tile6.update();
            addChildTo(tile6, 0, shiftY);

            shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;

            var tile7:MovingTile = new MovingTile(Symbol.dictionary["s"]);
            tile7.update();
            addChildTo(tile7, -10, shiftY);


            var tile8:MovingTile = new MovingTile(Symbol.dictionary["x"]);
            tile8.update();
            addChildTo(tile8, 25, shiftY);

        }else {

            for (var k:Object in Symbol.dictionary) {
                var tile:MovingTile = new MovingTile(Symbol.dictionary[k]);
                tile.update();
                addChildTo(tile, 0, shiftY);
                shiftY += SettingsManager.instance.tileHeight + SettingsManager.instance.smallSpace;
            }
        }

        if(edit) {
            _simpleButton = ImageHolder.createButton(this, "+", SettingsManager.instance.areaWidth - 50 - (RuleManager.instance.level == 2 ? 26 : 16), SettingsManager.instance.ruleHeight + 11, function () {
                rules.push(new Rule(_rules.length));
                shouldDown = true;
                update();
            }, level == 2 ? _api.localization.button.add_rule : _api.localization.button.add_direction);

            NormalButton(_simpleButton).enable(edit);

            if(shouldDown) {
                shouldDown=false;
                try {
                    _scrollPane.verticalScrollPosition = _scrollPane.maxVerticalScrollPosition;
                } catch (e) {

                }
            }

        }

    }

    private var shouldDown:Boolean = false;

    public function move(tile:MovingTile):void {
        verticalPosition=_scrollPane.verticalScrollPosition;
        horizontalPosition=_scrollPane.horizontalScrollPosition;
        if(tile.moving && tile.rule==null){


            for each(var rule:Rule in rules){
                if(rule.consumeMove(tile, tile.x+tile.width/2-_scrollPane.x+horizontalPosition, tile.y-rule.y+tile.height/2+verticalPosition)){
                    rule.draw();
                    for each(var rule1:Rule in rules){
                        if(rule1!=rule){
                            rule1.removeAllTemp();
                            rule1.draw();
                        }
                    }
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
            if(!rule.empty && (ridge.indexOf(rule.getStringInput())>=0) || rule.isStart()){
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
        if(rule.isStart()){
            for (var i:int=0; i<rule.output.length; i++){
                _workingRidge.tiles.splice(i, 0, new Tile(rule.output[i].symbol, true));
            }
            return;
        }

        var index:int = ridge.indexOf(rule.getStringInput());
        _workingRidge.tiles.splice(index, rule.input.length);
        if(!rule.isFinish()) {
            for (var i:int = 0; i < rule.output.length; i++) {
                _workingRidge.tiles.splice(index + i, 0, new Tile(rule.output[i].symbol, true));
            }
        }
        RuleManager.instance.result.applyOperations++;
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

    //this function was used to generate 300 examples
    public function loadExamples2():void {
        //первые пять пользователь будет видеть

        _examples.push("1-1+1-1+1");
        _examples.push("-1-1-1+1+1");
        _examples.push("(1-1-1)+1-0");
        _examples.push("(0-1)-(1+1)-(-1-1)");
        _examples.push("1-(((1-1)-1)+1)");

        var example:String = "";
        while (_examples.length<300){
            if(example.indexOf("ex")<0){
                var parser:MathParser = new MathParser([]);
                var compiledObj:CompiledObject = parser.doCompile(example);
                var answer:Number = parser.doEval(compiledObj.PolishArray, []);
                if(_examples.indexOf(example)<0 && ( answer==0 || answer==1 || answer==-1)){
                    _examples.push(example);
                }
                example = "";
            }else if(example.length>20){
                example = "";
            }
            example = genExample(example);
        }
    }

    public function loadExamples():void {
        var allExamples:String = "1-1+1-1+1|||-1-1-1+1+1|||(1-1-1)+1-0|||(0-1)-(1+1)-(-1-1)|||1-(((1-1)-1)+1)|||1|||1-1-1+1+1-1+1-1+1|||1-1|||(1-(1+1)+1)|||(1-1+1)|||1+1-1|||1-1-1|||1-(1-1+1+1)|||(1-1+(1-1)+1-1+1)|||1-(1+1-1-1)|||(1-1)|||1-(1-1+1)|||1-1+1|||((1-1-1+1-1+1)+1)|||(1+1+1+1-(1+1+1))|||(1-1-1)|||1-(1-1)|||1-1-1+1-1|||((1-1-1+1+1)-1)|||1-(1+1)|||(1+1-1+1-1)|||(1-1+1-1-1)|||1+((1-1-1)-1)|||1-1-1-1+1|||1+(1-1-1-1+1)|||1-1+1-1|||1+1-(1+1+1-1+1)|||(1-(1+1-1+1))|||1+((1-1)-1+1)|||1+1-1-1|||(1+1-1)|||(1-1+1+1-1)|||1-((1-1)+1)|||(1-(1+1)+1-1+1)|||(1-(1-1))|||1-1+(1-1)|||(1-1-(1-1)-1+1+1)|||1-1+(1-1+1-1)|||1-1-1+(1+1+1-1)|||(1+1-1-1+1)|||1-(1+1+1-1-1+1-1)|||1-1-1+1|||(1+1-1-1)|||1-(1+1-1-1+1-1-1+1)|||1-(1+(1-1-1))|||1-1+1+(1-(1+1-1+1))|||1-1+1+1-1-1-1+1-1|||(1-1+1-1)|||1+1+1-1-1|||1-1-(1+(1-1-1))|||((1+(1-1-1))+1+1-1)|||(1-1-(1-1-1))|||1-(((1-1)+1)-1)|||1+1-1+1-1-1-(1-1+1)|||(1+1-(1+1)-1)|||(1+1-((1+1+1)-1))|||1-1+(1-(1+1)+1+1)|||(1-1-((1-1)-1))|||1-(1-(1+1+1-1)+1)|||1-(1+1+1-1)|||1-((1+(1-1))+1-1)|||1+1+(1-1-1)|||((1+1)-(1+1))|||(1+(1-1)+1-1)|||((1-1)+1)|||1+(1-1)|||1-1+1-1-1|||(1-1-1+1)|||(1-(1-(1-1+1)))|||(1-1-1-1+1+1+1)|||(1+(1-1+1-1-1)+1)|||1-(1+1-1)|||1+1+1-1-1-1|||1+1-1+1-1|||((1-1-1-1)+1)|||1-1-(1-1+1)|||(1-1-1+1-1)|||1+1-1-1-1|||(1-(1+1+1-1))|||(1-(1-1)+1-1)|||(1-1+1-1+1-1-1)|||(1+1-1+1-1-1)|||1-1-1+(1+1)|||(1+1-1-(1+1-1))|||1+(1-1-1)|||(1-(1-1+1))|||(((1+1-1)+1)-1)|||(1-1+(1-1)-1)|||1+1-((1-1)+1)|||1-1-((1+1-1)-1-1)|||((1+1-1-1-1)-1+1)|||1-1+1+1-1|||(1+1-1-1+(1-1-1))|||1-1+1-1-(1-1+1-1)|||(1-1-1+1-1+1)|||1+1-1-1+1+(1-1)|||(1+(1-1))|||(1+1+1-1-1)|||(1+1+1-1-1-1)|||1-1+1-1-(1-1)|||1+1-(1+1+1-1-1)|||1-1+1-(1-1+1)|||(1-(1+(1-1-1))-1)|||(1-1+(1-1)+1)|||(1+1-(1+1))|||1+1-(1+1)|||(1-(1+1-1))|||1-1+(1+1-1-1-1)|||(1+1-1-1+1+(1-1))|||(1-(1+1-1+1-1-1))|||(1-1+1-(1+1-1)+1)|||1-1+((1-1+1-1)-1+1)|||(1-(1-1)-1)|||(1-1-1-(1+1-1-1))|||1+1-(1+1+1+1-1-1-1)|||(1-1-(1-1+1-1))|||1+((1-1)-1)|||(1-1-(1+1-1-1)+1)|||(1+1+1-(1-1+1+1))|||1-1+1+1-1-1-1|||1+1+(1-1-1+1-1)|||(((1-1)+1)-1-1+1)|||1-((1+1)+1-1-1+1)|||1+1+1-(1+1)|||(1-1-(1-1+1))|||1-1+1+((1-1)-1)|||(1+1-1-1+1+1-1-1)|||((1-1)+1-1-1)|||1-1-1-1+(1+1+1)|||1-(1-1+(1+1)-1+1)|||1-1-((1-1)-1+1+1)|||1-1+1-(1+1-1-1)|||(1-1-1+(1+1))|||1-((1+1)+1-1)|||1-1+(1+1-1-1-1+1)|||1-((1+1)-1)|||((1-1-1+1)-1+1)|||1+1-1-(1-1)|||(1-1+(1-1+1))|||(1-1+1-(1+1))|||1-1+(1-1-1)|||(1-1+1-1+(1-1+1))|||(1-(1+1))|||(1+1+(1-1+1-1-1))|||1+(1-1+1-1)|||(1-1+1+1+1-(1+1))|||(1+(1-1-1-1))|||(1-1+1-1+(1-1-1))|||((1+1-1+1-1+1)-1)|||((1-1-1+1-1)+1)|||(1-1-1-1+1)|||1-(1+1-1+1)|||(1+(1-1-1+(1-1)))|||(1+(1-1-1)+1)|||1-(1+1-(1+1+1-1))|||1+1-1-(1+1)|||(((1-1)-1)+1-1)|||1-(1+1-(1-1))|||1+(1+(1-(1+1)-1))|||1+(1+1-1-1)|||1-(1-1+1-1+1)|||1-1+1+(1-1)|||1+(1-(1+1+1))|||1-(1+1-1-1+1)|||((1-1)-1)|||1+1-1+1-(1-1+1)|||(1-1-(1-(1+1))-1)|||(1+(1-1)-1-1)|||1-(1-(1-1))|||1+(1-1-1+1)|||((1+1-1)-(1+1))|||1-1-1+1+1|||(1-(1-(1-1+1)+1))|||(1+(1-1-1+1))|||(1+1-1-1+1-1)|||(1-1-(1+1+1-1-1))|||1-((1+1-1)-1)|||1-1-(1-1+1-1)|||(1+1-1-1-(1-1))|||1-1-1-1+(1+1-1)|||1+((1-(1+1))+1-1-1)|||(1-1+1-1-1+1)|||1-(1-(1-1-1)-1)|||1-(1-1-(1-1))|||(1-(1-(1+1-1)))|||1-1-(1-1)|||1-(1+1+1-1-1)|||((1-1+1)-1)|||((1-1+1-1)-1)|||((1+1)-1)|||1+(1-1-1-1)|||(1-1+(1+1-(1+1)))|||((1-1)-1+1)|||1-(1-1-(1-1-1))|||1+1-1-(1+(1-1))|||1-1-1+1-1+1|||(1+1+1-(1+1))|||1-1+(1-1-1+1)|||((1-1)-1+1+1-1+1)|||1-1-(1-1-1+1)|||(1-1+1-(1-1+1))|||(1+((1+1)-1)-1)|||(1+1-1-1-1)|||(1-1+(1+1-1))|||(1-(1+1-1-1))|||(1-1-1-(1-1))|||1-1+1+1-1-1+1-1|||((1+1-1-1)+1)|||(1-1+1+1-1+1-1)|||(1-1+1+1-1-1)|||1-1-(1+1-1-1)|||(1-(1-1+1-1+1))|||1-1-(1+1-1)|||1-1-(1-1-1)|||1-1-1+(1+1-1)|||1+1+1-(1+1+1)|||1-1-1-(1-1)|||(1-1-1-(1-1-1))|||(1-1+1+1-1-1+1)|||((1+1-1)-1+1-1)|||(1-1-(1+1-1))|||1-(1-1+1-1)|||(1+1-1+(1-1+1-1))|||(1-(1-1+1+1))|||(1-1-1+1+1-1)|||1+1+1-(1+1+(1+1))|||(1-((1+1)-1))|||1-((1-1+1)-1)|||(1+(1-1-1))|||1-1-1-1+1+1|||1-1-1+(1-1)|||(1-1-1+1-1-1+1)|||(1-(1-1+1-1))|||((1+(1-1-1))-1)|||(1+(1-1-1)-1)|||(1-1-(1-1+1-1-1))|||1-(1+1-(1-1+1))|||1+(1-1-(1+1))|||1+1-1-1+1|||1-(1+(1-1+1))|||(1-1+1-1+1)|||1-(1+1+1+1-(1+1))|||(1-(1-1+1-1)-1)|||(1+(1+1-1)-1)|||((1-1+1-1-1)+1)|||(1-1-1-1+1+1)|||(1-(1-1)-(1+1))|||((1+1-(1+1))-1)|||(1-1-1+1+1)|||1-(1-(1-1-1))|||(1-((1-1)+1+1))|||1-1-1-(1+(1-1-1-1))|||(1-1-1+1+1+1-1)|||(1-1+(1+1-1)-1-1)|||1-(1-1-1+1)|||(1-1+1-(1-1))|||((1-1-1)+1-1)|||((1-1+1+(1-1))-1)|||(1+1-(1-1)-1)|||1-1-1+(1-1+1)|||(1-1-(1-(1+1)))|||((1-1+1)+(1-1))|||1+1-1-1+1-1|||(1-1+1-(1-1+1+1))|||1-(1-1-1+1+1)|||(((1-1)+1-1)-1+1)|||1+1-1-1+1-1+1|||(1-(1+1-1)+1-1+1)|||1+(1-(1+1)+1-1)|||(1+1-(1+1+1-1+1))|||1-1+1-1+1-1|||1-(1+1+1-1-1+1+1-1)|||1-(1-1+1-1-1+1)|||1-(1+1-1+1-1)|||((1+1-1-1)-1)|||(1-1+1+(1-1))|||(1+1-(1+1+1))|||1-1+1+1-1-1+1|||1-(1-(1+1)+(1-1+1))|||1+((1-1)-(1+1-1))|||(1-1-(1-1))|||(1-((1+1)+1)+1+1)|||1+1+1-(1+1-1+1)|||1+1-1-(1+1-1-1)|||((1-1+1)+1-1)|||1-1-1-(1-1-1)|||1-1+(1+1-1-1)|||1-(1+(1+1-1)+1-1-1)|||1-1+(1+1-1-(1+1))|||1-1+(1-(1+1-1-1))|||1+(1-(1+1+1-1))|||(1-1+(1-1))|||1+1+1-1-(1-1+1)|||1+1-1-1-(1-1)|||1-(1-(1-1+1)+1)";
        for each (var ex:String in allExamples.split("|||"))
            _examples.push(ex);
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
        if(!isValid()){
            return false;
        }
        var parser:MathParser = new MathParser([]);
        var compiledObj:CompiledObject = parser.doCompile(str);
        var answer:Number = parser.doEval(compiledObj.PolishArray, []);

        for(var i:int=0; i<1000; i++) {
            if (getRuleStr(str) != null) {
                str = applyRuleStr(str);
            }
        }

        return (answer+""==str);


    }


    public function getRuleStr(str:String):Rule {
        for each(var rule:Rule in rules){
            if(!rule.empty &&( str.indexOf(rule.getStringInput())>=0 || rule.isStart() )){
                return rule;
            }
        }
        return null;
    }

    public function applyRuleStr(str:String):String {
        var rule:Rule = getRuleStr(str);

        if(rule.isStart()){
            var newStr = "";
            for (var i:int=0; i<rule.output.length; i++){
                newStr += rule.output[i].symbol;
            }
            newStr+=str;
            return newStr;
        }


        var index:int = str.indexOf(rule.getStringInput());

        var newstr = str.substr(0, index);
        if(!rule.isFinish()) {
            for (var i:int = 0; i < rule.output.length; i++) {
                newstr += rule.output[i].symbol.code;
            }
        }
        newstr+=str.substr(index+rule.getStringInput().length);

        RuleManager.instance.result.applyOperations++;

        return newstr;


    }

    public function getRuleSize():int{
        var sum:int=0;
        for each(var rule:Rule in rules){
            if(!rule.empty){
                sum++;
            }
        }
        return sum;
    }

    public function submitResult(ridge:Ridge, template:Ridge):void {
        if(RuleManager._instance.level==0) {
            var temp:Ridge = ridge.clone();
            for (var i:int = 0; i < 1000; i++) {
                if (hasRule(temp)) {
                    applyRule(temp);
                }
            }

            for (var i:int = 0; i < temp.tiles.length; i++) {
                if (temp.tiles[i].symbol.code != template.tiles[i].symbol.code) {
                    RuleManager.instance.result.ridgeDiff++;
                }
            }

            RuleManager.instance.result.ruleAmount = getRuleSize();

            api.submitResult(RuleManager.instance.result.clone());

            RuleManager.instance.result.applyOperations = 0;

        }else if(RuleManager._instance.level==2){
            var corCount:int = 0;
            var allCount:int = 0;
            for each(var str:String in RuleManager.instance.examples){
                var result = RuleManager.instance.correct(str);
                if(result){
                    corCount++;
                }
                allCount++;
            }

           RuleManager.instance.result.perc = 100*corCount/allCount;
            RuleManager.instance.result.correctAmount = corCount;

            RuleManager.instance.result.ruleAmount = getRuleSize();

            RuleManager.instance.result.ruleLength = 0;
            for each(var rule:Rule in RuleManager.instance.rules){
                RuleManager.instance.result.ruleLength+=rule.getLength();
            }

            api.submitResult(RuleManager.instance.result.clone());
        }else{
            var temp:Ridge = ridge.clone();
            for (var i:int = 0; i < 1000; i++) {
                if (hasRule(temp)) {
                    applyRule(temp);
                }
            }

            if(checkCorrect(temp)){
                RuleManager.instance.result.error=false;
                var last:Tile = null;
                for (var i:int = 0; i < temp.tiles.length; i++) {
                    if(last!=null){
                        if((last.symbol.code=="l" || last.symbol.code=="L")
                                &&(temp.tiles[i].symbol.code=="k" || temp.tiles[i].symbol.code=="K")){
                            RuleManager.instance.result.wrongPair++;
                        }
                        if((last.symbol.code=="k" || last.symbol.code=="K")
                                &&(temp.tiles[i].symbol.code=="l" || temp.tiles[i].symbol.code=="L")){
                            RuleManager.instance.result.wrongPair++;
                        }
                    }
                    last=temp.tiles[i];
                }

                RuleManager.instance.result.ruleAmount = getRuleSize();
                if( RuleManager.instance.result.wrongPair==1) {
                    RuleManager.instance.result.wrongOrder = RuleManager.instance.getMinWrong(temp);
                }else{
                    RuleManager.instance.result.wrongOrder = 1000;
                }
            }else{
                RuleManager.instance.result.error=true;
                return;
            }




            api.submitResult(RuleManager.instance.result.clone());

            RuleManager.instance.result.applyOperations = 0;
        }


    }

    public function getMinWrong(temp:Ridge):int {
        var template:String;
        if(temp.tiles[0].symbol.code=="k"||temp.tiles[0].symbol.code=="K"){
            template=level1Cor2;
        }else{
            template=level1Cor1;
        }

      var d1:int=0;
        for(var i:int=0; i<temp.tiles.length; i++){
            if(temp.tiles[i].symbol.code!=""+template.charAt(i)){
                d1++;
                temp.tiles[i].select=true;
            }
        }
      return d1;
    }



    public function checkCorrect(ridge:Ridge):Boolean {
        return getNum("K",ridge) == getNumStr("K") && getNum("L",ridge) == getNumStr("L")
                && getNum("k",ridge) == getNumStr("k") && getNum("l",ridge) == getNumStr("l")
                && level1Initial.length == ridge.tiles.length;
    }

    private function getNumStr(s:String):int {
        var res:int=0;
        for(var i:int=0; i<level1Initial.length; i++){
            if(s==""+level1Initial.charAt(i)){
                res++;
            }
        }
        return res;
    }

    private function getNum(s:String, ridge:Ridge):int {
        var res:int=0;
        for each(var tile:Tile in ridge.tiles) {
            if(tile.symbol.code==s){
                res++;
            }
        }
        return res;
    }


    private var level1Cor1:String="llLlLLlKkkkKkK";

    private var level1Cor2:String="KkkkKkKllLlLLl";

    private var level1Initial:String="lKLkLKlkLklklK";
}
}
