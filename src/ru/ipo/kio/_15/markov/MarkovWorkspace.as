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
import ru.ipo.kio.base.displays.SettingsDisplay;

public class MarkovWorkspace extends BasicView  {
    private var _problem:KioProblem;
    private var _api:KioApi;

    private var _correctRidge:Ridge = new Ridge();

    private var _workingRidge:Ridge = new Ridge();


    public function get correctRidge():Ridge {
        return _correctRidge;
    }

    public function get workingRidge():Ridge {
        return _workingRidge;
    }

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
            Symbol.getSymbol("x");
            Symbol.getSymbol("s");
            Symbol.getSymbol("b");
            Symbol.getSymbol("n");
            Symbol.getSymbol("p");
            loadRidges('','lKLkLKlkLklklK');

        }else{
            RuleManager.instance.loadExamples();
            Symbol.getSymbol("1");
            Symbol.getSymbol("+");
            Symbol.getSymbol("-");
            Symbol.getSymbol("(");
            Symbol.getSymbol(")");
            Symbol.getSymbol("0");
            Symbol.getSymbol("A");
            Symbol.getSymbol("B");
            Symbol.getSymbol("X");
            Symbol.getSymbol("S");
            examples.push(new Example(RuleManager.instance.examples[0]));
            examples.push(new Example(RuleManager.instance.examples[1]));
            examples.push(new Example(RuleManager.instance.examples[2]));
            examples.push(new Example(RuleManager.instance.examples[3]));
            examples.push(new Example(RuleManager.instance.examples[4]));

        }
        _api.addEventListener(KioApi.RECORD_EVENT, function(e:Event):void {
            RuleManager.instance.record = RuleManager.instance.result.clone();
            updateRecord();
        });
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

    private var execution:Boolean = false;

    public var _userField:TextField = new TextField();

    private var userText:String = "1+1";

    private function stepForward():void {
        var rule:Rule = RuleManager.instance.getRule(_workingRidge);
        if(!selectStep && rule.isStart()){
            selectStep=true;
        }
        if (!selectStep) {
            selectStep = true;
            rule.select = true;
            var index:int = _workingRidge.getString().indexOf(rule.getStringInput());
            for(var i:int=0;i<rule.getStringInput().length; i++){
                _workingRidge.tiles[i+index].select=true;
            }
        } else {
            _history.push(_workingRidge.clone());
            RuleManager.instance.applyRule(_workingRidge);
            selectStep = false;
            if(_history.length%100==0){
                if(animate){
                    animate=false;
                }
                if(execution){
                    execution=false;
                }
                showWarning=true;
            }
        }
    }

    private var showWarning:Boolean=  false;

    private function showWarningSp():void {
        var spWar:BasicView = new BasicView();
        spWar.graphics.beginFill(0x000000, 0.5);
        spWar.graphics.drawRect(0,0,SettingsManager.instance.areaWidth, SettingsManager.instance.areaHeight);
        spWar.graphics.endFill();
        spWar.addChildTo(spWar.createField(_history.length+_api.localization.label.warning, 20, 0xFFFFFF),100,300);
        spWar.addEventListener(MouseEvent.CLICK, function(e:Event){
            showWarning=false;
            update();
        });
        addChildTo(spWar,0,0);
    }

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
                _userField.border = true;
                _userField.setTextFormat(format);
                _userField.width = 440;
                _userField.height = _userField.textHeight + 10;

                addChildTo(_userField, SettingsManager.instance.areaWidth/2-70, 80);
            }else{
                addChildTo(_workingRidge, SettingsManager.instance.areaWidth/2-170, 60);
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
            addChildTo(RuleManager.instance, 5, 2 * (SettingsManager.instance.ridgeHeight)-14);
        }

        var buttonY:int = 11 + 2 * SettingsManager.instance.ridgeHeight + SettingsManager.instance.ruleHeight;

        if(RuleManager.instance.level==2){
            buttonY-=14;
        }



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
                   stepForward();
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

                execution=true;
                while (RuleManager.instance.hasRule(_workingRidge) && execution) {
                    stepForward();
                }
                execution=false;
                checkFinish();
                update();
            }, RuleManager.instance.api.localization.button.execute);



            shiftX+=55;


            var resetButton:SimpleButton = ImageHolder.createButton(this, "reset", shiftX, buttonY, function () {
                animate=false;
                reset();
                RuleManager.instance.setEdit(true);
                selectStep=false;
                update();
            }, RuleManager.instance.api.localization.button.reset);

            if (_history.length == 0) {
                NormalButton(prevButton).enable(false);
                NormalButton(resetButton).enable(false);
            }

        }else{

            RuleManager.instance.result.ruleAmount = RuleManager.instance.getRuleSize();
            var spRes =  makeResultPanel(RuleManager.instance.api.localization.label.solution, RuleManager.instance.result);

            var labelY:int = 5+2*SettingsManager.instance.ridgeHeight+SettingsManager.instance.ruleHeight;
            if(RuleManager.instance.level==2){
                labelY-=15
            }

            if(RuleManager.instance.level==1){
                labelY-=65;
            }

            addChildTo(spRes,SettingsManager.instance.areaWidth / 2+10, labelY);

            if(RuleManager.instance.level==1){
                buttonY-=60;
            }

            var editButton:SimpleButton = ImageHolder.createButton(this, "edit", SettingsManager.instance.areaWidth-55, buttonY, function () {
                reset();
                RuleManager.instance.setEdit(true);
                RuleManager.instance.finish=false;
                update();
            }, RuleManager.instance.api.localization.button.edit);
        }

        updateRecord();

        if(showWarning){
            showWarningSp();
        }
    }

    private var selectStep:Boolean = false;

    var recordSprite:BasicView = null;

    private function updateRecord():void {
        if(recordSprite!=null && contains(recordSprite)){
            removeChild(recordSprite);
            recordSprite==null;
        }
        var spRec =  makeResultPanel(RuleManager.instance.api.localization.label.record, RuleManager.instance.record);
        recordSprite = spRec;
        var labelY:int = 5+2*SettingsManager.instance.ridgeHeight+SettingsManager.instance.ruleHeight;
        if(RuleManager.instance.level==2){
            labelY-=15
        }
        if(RuleManager.instance.level==1){
            labelY-=65;
        }
        addChildTo(recordSprite, 70, labelY);

    }

    private function makeResultPanel(header:String, data:ResultData):BasicView {
        var sprite:BasicView = new BasicView();
        sprite.graphics.beginFill(0xFFFFFF, 0);
        sprite.graphics.drawRoundRect(0,0,300,80,40,40);
        sprite.graphics.endFill();
        sprite.addChildTo(createField(header,12,data.error?0xFF0000:0xFFFFFF), 5, 5);
        if(RuleManager.instance.level==0) {
            sprite.addChildTo(createField(RuleManager.instance.api.localization.label.difference + ": " + data.ridgeDiff, 12, 0xFFFFFF), 70, 5);
            sprite.addChildTo(createField(RuleManager.instance.api.localization.label.direction_amount + ": " + data.ruleAmount, 12, 0xFFFFFF), 70, 25);
            sprite.addChildTo(createField(RuleManager.instance.api.localization.label.algorithm_step + ": " + data.applyOperations, 12, 0xFFFFFF), 70, 45);
        }
        if(RuleManager.instance.level==2) {
            var perc:int = data.perc*100;
            sprite.addChildTo(createField(RuleManager.instance.api.localization.label.example_amount + ": " + perc/100+"%", 12, 0xFFFFFF), 65, 5);
            sprite.addChildTo(createField(RuleManager.instance.api.localization.label.rule_amount + ": " + data.ruleAmount, 12, 0xFFFFFF), 65, 25);
//            sprite.addChildTo(createField(RuleManager.instance.api.localization.label.algorithm_length + ": " + data.ruleLength, 12, 0xFFFFFF), 70, 45);
        }
        if(RuleManager.instance.level==1) {
            sprite.addChildTo(createField(RuleManager.instance.api.localization.label.wrongPair + ": " + data.wrongPair, 12, 0xFFFFFF), 70, 5);
            sprite.addChildTo(createField(RuleManager.instance.api.localization.label.wrongOrder + ": " + data.wrongOrder, 12, 0xFFFFFF), 70, 25);
            sprite.addChildTo(createField(RuleManager.instance.api.localization.label.direction_amount + ": " + data.ruleAmount, 12, 0xFFFFFF), 70, 45);

        }


        return sprite;
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
            stepForward();
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
            RuleManager.instance.result.ridgeDiff=0;
            RuleManager.instance.result.wrongPair=0;
            RuleManager.instance.finish = true;
            deselect();
            RuleManager.instance.deselect();

            if(RuleManager.instance.level==0) {
                for (var i:int = 0; i < _workingRidge.tiles.length; i++) {
                    if (_workingRidge.tiles[i].symbol.code != _correctRidge.tiles[i].symbol.code) {
                        RuleManager.instance.result.ridgeDiff++;
                        _workingRidge.tiles[i].select = true;
                        _correctRidge.tiles[i].select = true;
                    }
                }
                RuleManager.instance.result.ruleAmount = RuleManager.instance.getRuleSize();
            }else if (RuleManager.instance.level==1){
                var last:Tile = null;

                if(RuleManager.instance.checkCorrect(_workingRidge)){
                    RuleManager.instance.result.error=false;
                }else{
                    RuleManager.instance.result.error=true;
                    return;
                }





                for (var i:int = 0; i < _workingRidge.tiles.length; i++) {
                    if(last!=null){
                        if((last.symbol.code=="l" || last.symbol.code=="L")
                                &&(_workingRidge.tiles[i].symbol.code=="k" || _workingRidge.tiles[i].symbol.code=="K")){
                            RuleManager.instance.result.wrongPair++;
                        }
                        if((last.symbol.code=="k" || last.symbol.code=="K")
                                &&(_workingRidge.tiles[i].symbol.code=="l" || _workingRidge.tiles[i].symbol.code=="L")){
                            RuleManager.instance.result.wrongPair++;
                        }
                    }
                    last=_workingRidge.tiles[i];
                }
                RuleManager.instance.result.ruleAmount = RuleManager.instance.getRuleSize();
                RuleManager.instance.result.wrongOrder = RuleManager.instance.getMinWrong(_workingRidge);
                _workingRidge.select=true;
            }else{
                var corCount:int = 0;
                var allCount:int = 0;
                wrong=null;
                for each(var str:String in RuleManager.instance.examples){
                    var result = RuleManager.instance.correct(str);
                    if(result){
                        corCount++;
                    }else{
                        if(wrong==null || wrong.length>str.length){
                            wrong=str;
                        }
                    }
                    allCount++;
                }

                for each(var ex:Example in examples){
                    ex.select=true;
                    if(RuleManager.instance.correct(ex.str)){
                        ex.wrong = false;
                    }else{
                        ex.wrong=true;
                    }
                }

                RuleManager.instance.result.perc = 100*corCount/allCount;
                RuleManager.instance.result.correctAmount = corCount;

                RuleManager.instance.result.ruleAmount = RuleManager.instance.getRuleSize();

                RuleManager.instance.result.ruleLength = 0;
                for each(var rule:Rule in RuleManager.instance.rules){
                    RuleManager.instance.result.ruleLength+=rule.getLength();
                }
            }


            _api.submitResult(RuleManager.instance.result.clone());
            _api.autoSaveSolution();
        }
    }





    public function prev():void {
        deselect();
        RuleManager.instance.deselect();
        if(_history.length>0){
            _workingRidge  = _history.pop();
        }
   }

    internal function deselect():void {
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
        RuleManager.instance.result.ridgeDiff=0;
        RuleManager.instance.result.applyOperations=0;
        RuleManager.instance.result.ruleAmount=0;
    }


}
}
