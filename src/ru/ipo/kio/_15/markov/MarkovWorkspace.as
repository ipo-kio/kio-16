/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.utils.Timer;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.base.displays.ShellButton;

public class MarkovWorkspace extends BasicView  {
    private var _problem:KioProblem;
    private var _api:KioApi;

    private var _correctRidge:Ridge = new Ridge();

    private var _workingRidge:Ridge = new Ridge();

    private var _history = new Vector.<Ridge>();

    public function MarkovWorkspace(problem:KioProblem, level:int) {
        _api = KioApi.instance(problem);
        RuleManager.instance.api=_api;
        RuleManager.instance.level=level;
        SettingsManager.instance.level=level;
        _problem = problem;
        if(level==0){
            loadRidges('wecececefececeww', 'wwcwwccwwwcccwww');
        }else if (level==1){
            loadRidges('','ooooooooaaaaaaaaa');

        }else{
            RuleManager.instance.loadExamples();
            Symbol.getSymbol("1");
            Symbol.getSymbol("+");
            Symbol.getSymbol("-");
            Symbol.getSymbol("(");
            Symbol.getSymbol(")");
            Symbol.getSymbol("0");
            Symbol.getSymbol("2");
            examples.push(new Example(RuleManager.instance.examples[0]));
            examples.push(new Example(RuleManager.instance.examples[1]));
            examples.push(new Example(RuleManager.instance.examples[2]));
            examples.push(new Example(RuleManager.instance.examples[3]));
            examples.push(new Example(RuleManager.instance.examples[4]));

        }
        update();
    }

    private var examples:Vector.<Example> = new Vector.<Example>();

    public function loadRidges(correct:String, working:String):void{
        _correctRidge.clearTiles();
        for(var i:int=0; i<correct.length; i++){
            _correctRidge.addTile(correct.charAt(i));
        }
        _workingRidge.clearTiles();
        for(var i:int=0; i<working.length; i++){
            _workingRidge.addTile(working.charAt(i));
        }
        SettingsManager.instance.tileAmount=_workingRidge.tiles.length;
        update();
    }

    private var animate:Boolean = false;

    public var _userField:TextField = new TextField();

    private var userText:String = "1+1";

    public override function update():void {
        clear();
        graphics.drawRect(0,0,SettingsManager.instance.areaWidth,SettingsManager.instance.areaHeight);
        if(RuleManager.instance.level==0) {
            addChild(new ImageHolder.LEVEL0_BG());
        }else if(RuleManager.instance.level==1){
            addChild(new ImageHolder.LEVEL1_BG());
        }else{

            addChild(new ImageHolder.LEVEL2_BG());

            var shiftE:int = 10;
            for(var i:int=0; i<examples.length; i++){
                examples[i].update();
                addChildTo(examples[i], shiftE, 10);
                shiftE+=examples[i].width+20;
            }



            if(RuleManager.instance.edit) {

                _userField.type = TextFieldType.INPUT;
                _userField.restrict = "-1()+";
                _userField.background = false;
                _userField.selectable = true;
                _userField.text = userText;
                var format:TextFormat = _userField.getTextFormat();
                format.size = 40;
                format.font = "Arial";
                _userField.border = false;
                _userField.setTextFormat(format);
                _userField.width = _userField.textWidth + 300;
                _userField.height = _userField.textHeight + 10;

                addChildTo(_userField, SettingsManager.instance.areaWidth/2-70, 90);
            }else{
                addChildTo(_workingRidge, SettingsManager.instance.areaWidth/2-70, 60);
            }

            if(wrong!=null){
                var wf:TextField = createField(wrong, 20);
                addChildTo(wf, 30, 95);
                wf.background = false;
                wf.backgroundColor = 0xff0000;

            }




        }


        _workingRidge.update();
        _correctRidge.update();
        if(RuleManager.instance.level==0) {
            addChildTo(_correctRidge, 0, 0);
            addChildTo(_workingRidge, 0, SettingsManager.instance.ridgeHeight);
        }else if(RuleManager.instance.level==1){
            addChildTo(_workingRidge, 0, SettingsManager.instance.ridgeHeight/2-30);
        }else{

        }
        RuleManager.instance.update();
        if(RuleManager.instance.level==1) {
            addChildTo(RuleManager.instance, 16, 2 * (SettingsManager.instance.ridgeHeight)-65);
        }else if(RuleManager.instance.level==0){
            addChildTo(RuleManager.instance, 16, 2 * (SettingsManager.instance.ridgeHeight));
        }else{
            addChildTo(RuleManager.instance, 16, 2 * (SettingsManager.instance.ridgeHeight)-6);
        }

        var buttonY:int = 11 + 2 * SettingsManager.instance.ridgeHeight + SettingsManager.instance.ruleHeight;


        if(!RuleManager.instance.finish) {

            var shiftX:int = SettingsManager.instance.areaWidth / 2;

              if(RuleManager.instance.level==1){
                buttonY-=65;
            }

            var prevButton:SimpleButton = ImageHolder.createButton(this, "<", shiftX, buttonY, function () {
                if(animate){
                    return;
                }
                prev();
                update();
            }, RuleManager.instance.api.localization.button.step_backward);


            shiftX+=55;

            var nextButton:SimpleButton = ImageHolder.createButton(this, ">", shiftX, buttonY, function () {
                if(animate){
                    return;
                }
                if(!RuleManager.instance.isValid()){
                    return;
                }

                if(RuleManager.instance.level==2 && RuleManager.instance.edit) {
                    loadWorkingRidge();
                }

                RuleManager.instance.setEdit(false);
                RuleManager.instance.deselect();
                deselect();
                if (RuleManager.instance.hasRule(_workingRidge)) {
                    _history.push(_workingRidge.clone());
                    RuleManager.instance.applyRule(_workingRidge);
                }
                checkFinish();
                update();
            }, RuleManager.instance.api.localization.button.step_forward);

            shiftX+=55;

            var stopButton:SimpleButton = ImageHolder.createButton(this, "stop", shiftX, buttonY, function () {
                if(!animate){
                    return;
                }
                animate=false;
                animateButton.visible=true;
                stopButton.visible=false;
            }, RuleManager.instance.api.localization.button.stop);

            var animateButton:SimpleButton = ImageHolder.createButton(this, "anim", shiftX, buttonY, function () {
                if(animate){
                    return;
                }

                if(!RuleManager.instance.isValid()){
                    return;
                }

                if(RuleManager.instance.level==2 && RuleManager.instance.edit) {
                    loadWorkingRidge();
                }

                RuleManager.instance.setEdit(false);
                animate=true;
                animateButton.visible=false;
                stopButton.visible=true;
                animateStep();
            }, RuleManager.instance.api.localization.button.animate);

            if(animate){
                animateButton.visible=false;
                stopButton.visible=true;
            }else{
                animateButton.visible=true;
                stopButton.visible=false;
            }

            shiftX+=55;


            var playButton:SimpleButton = ImageHolder.createButton(this, "exec", shiftX, buttonY, function () {
                if(animate){
                    return;
                }
                if( !RuleManager.instance.isValid()){
                    return;
                }

                if(RuleManager.instance.level==2 && RuleManager.instance.edit) {
                    loadWorkingRidge();
                }
                RuleManager.instance.setEdit(false);

                while (RuleManager.instance.hasRule(_workingRidge)) {
                    _history.push(_workingRidge.clone());
                    RuleManager.instance.applyRule(_workingRidge);
                }

                checkFinish();
                update();
            }, RuleManager.instance.api.localization.button.execute);



            shiftX+=55;


            var resetButton:SimpleButton = ImageHolder.createButton(this, "reset", shiftX, buttonY, function () {
                animate=false;
                reset();
                RuleManager.instance.setEdit(true);
                update();
            }, RuleManager.instance.api.localization.button.reset);

            if (_history.length == 0) {
                NormalButton(prevButton).enable(false);
                NormalButton(resetButton).enable(false);
            }

        }else{

            addChildTo(createField(RuleManager.instance.api.localization.label.solution), SettingsManager.instance.areaWidth / 2+10, 10+2*SettingsManager.instance.ridgeHeight+SettingsManager.instance.ruleHeight);

            RuleManager.instance.result.size = RuleManager.instance.rules.length;
            drawResult(RuleManager.instance.result, SettingsManager.instance.areaWidth / 2+10, 25+2*SettingsManager.instance.ridgeHeight+SettingsManager.instance.ruleHeight);

            var editButton:SimpleButton = ImageHolder.createButton(this, "edit", SettingsManager.instance.areaWidth-100, buttonY, function () {
                reset();
                RuleManager.instance.setEdit(true);
                RuleManager.instance.finish=false;
                update();
            }, RuleManager.instance.api.localization.button.edit);
        }


        if(RuleManager.instance.level==1){
            addChildTo(createField(RuleManager.instance.api.localization.label.record), 10, 10+2*SettingsManager.instance.ridgeHeight+SettingsManager.instance.ruleHeight-65);
        }else{
            addChildTo(createField(RuleManager.instance.api.localization.label.record), 10, 10+2*SettingsManager.instance.ridgeHeight+SettingsManager.instance.ruleHeight);
        }

    }

    public function loadWorkingRidge():void {
        userText = _userField.text;
        _workingRidge.clearTiles();
        for (var i:int = 0; i < userText.length; i++) {
            _workingRidge.addTile(userText.charAt(i));
        }
    }

    private function animateStep():void {
        if(!animate){
            return;
        }

        RuleManager.instance.deselect();
        deselect();
        if (RuleManager.instance.hasRule(_workingRidge)) {
            _history.push(_workingRidge.clone());
            RuleManager.instance.applyRule(_workingRidge);
        }
        checkFinish();
        update();

        if(!RuleManager.instance.finish){
            var myTimer:Timer = new Timer(800, 1);
            myTimer.start();
            myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent){
                animateStep();
            });

        }
    }

    public var wrong:String = null;

    private function checkFinish():void {
        if (!RuleManager.instance.hasRule(_workingRidge)) {
            animate=false;
            RuleManager.instance.result.diff=0;
            RuleManager.instance.finish = true;
            deselect();
            RuleManager.instance.deselect();

            if(RuleManager.instance.level==0) {

                for (var i:int = 0; i < _workingRidge.tiles.length; i++) {
                    if (_workingRidge.tiles[i].symbol.code != _correctRidge.tiles[i].symbol.code) {
                        RuleManager.instance.result.diff++;
                        _workingRidge.tiles[i].select = true;
                        _correctRidge.tiles[i].select = true;
                    }
                }
            }else if (RuleManager.instance.level==1){
                var last:Tile = null;
                for (var i:int = 0; i < _workingRidge.tiles.length; i++) {
                    if(last!=null){
                        if(last.symbol.code!=_workingRidge.tiles[i].symbol.code){
                            RuleManager.instance.result.diff++;
                        }
                    }
                    last=_workingRidge.tiles[i];
                }
                _workingRidge.select=true;
            }else{
                RuleManager.instance.result.oper = 0;
                for each(var rule:Rule in RuleManager.instance.rules){
                    RuleManager.instance.result.oper+=rule.getLength();
                }

                var corCount:int = 0;

                var allCount:int = 0;



                for each(var str:String in RuleManager.instance.examples){
                    var result = RuleManager.instance.correct(str);
                    if(result){
                        corCount++;
                    }else{
                        if(wrong==null || wrong.length<str.length){
                            wrong=str;
                        }
                    }
                    allCount++;
                }


                for each(var ex:Example in examples){
                    if(RuleManager.instance.correct(ex.str)){
                        ex.wrong = false;
                    }else{
                        ex.wrong=true;
                    }
                }

                RuleManager.instance.result.perc = 100*corCount/allCount;
            }


        }
    }

    private function drawResult(result:Level0Data, x:Number, y:int):void {
        if(RuleManager.instance.level==2) {

            addChildTo(createField(RuleManager.instance.api.localization.label.example_amount + ":" + result.perc+"%"), x, y);
            addChildTo(createField(RuleManager.instance.api.localization.label.rule_amount+":"+result.size), x, y+15);
            addChildTo(createField(RuleManager.instance.api.localization.label.algorithm_length+":"+result.oper), x, y+30);

            return;
        }

        if(RuleManager.instance.level==0) {
            addChildTo(createField(RuleManager.instance.api.localization.label.difference + ":" + result.diff), x, y);
        }else if(RuleManager.instance.level==1){
            addChildTo(createField(RuleManager.instance.api.localization.label.pair_amount + ":" + result.diff), x, y);
        }
        addChildTo(createField(RuleManager.instance.api.localization.label.direction_amount+":"+result.size), x, y+15);
        addChildTo(createField(RuleManager.instance.api.localization.label.algorithm_step+":"+result.oper), x, y+30);
    }

    public function prev():void {
        deselect();
        RuleManager.instance.deselect();
        if(_history.length>0){
            _workingRidge  = _history.pop();
        }
   }

    private function deselect():void {
        for each(var tile:Tile in _workingRidge.tiles) {
            tile.select = false;
        }
        for each(var tile:Tile in _correctRidge.tiles) {
            tile.select = false;
        }
        _workingRidge.select=false;
    }


    public function reset():void {
        RuleManager.instance.deselect();
        deselect();
        if(_history.length>0){
            _workingRidge  = _history[0];
            _history = new Vector.<Ridge>();
        }
        RuleManager.instance.result.diff=0;
        RuleManager.instance.result.oper=0;
        RuleManager.instance.result.size=0;
    }


}
}
