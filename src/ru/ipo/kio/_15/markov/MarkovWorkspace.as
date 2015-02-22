/**
 * Created by Vasiliy on 15.02.2015.
 */
package ru.ipo.kio._15.markov {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
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
        _problem = problem;
        if(level==0){
            loadRidges('wwcwwccwwwcccwww', 'wecececefececeww');
        }else if (level==1){
            loadRidges('ooooooooaaaaaaaa', '');
        }
        update();

    }

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

    public override function update():void {
        clear();
        graphics.drawRect(0,0,SettingsManager.instance.areaWidth,SettingsManager.instance.areaHeight);
        _workingRidge.update();
        _correctRidge.update();
        addChildTo(_correctRidge,0,0);
        addChildTo(_workingRidge,0,SettingsManager.instance.ridgeHeight);
        RuleManager.instance.update();
        addChildTo(RuleManager.instance, 0, 2*(SettingsManager.instance.ridgeHeight));

        if(!RuleManager.instance.finish) {

            var prevButton:SimpleButton = ImageHolder.createButton(this, "<", SettingsManager.instance.areaWidth / 2, 2 * SettingsManager.instance.ridgeHeight + SettingsManager.instance.ruleHeight, function () {
                if(animate){
                    return;
                }
                prev();
                update();
            }, RuleManager.instance.api.localization.button.step_backward);

            if (_history.length == 0) {
                prevButton.enabled = false;
                prevButton.mouseEnabled = false;
            }


            var playButton:SimpleButton = ImageHolder.createButton(this, "exec", SettingsManager.instance.areaWidth / 2 + 100, 2 * SettingsManager.instance.ridgeHeight + SettingsManager.instance.ruleHeight, function () {
                if(animate){
                    return;
                }
                if(!RuleManager.instance.hasRule(_workingRidge) || !RuleManager.instance.isValid()){
                    return;
                }
                RuleManager.instance.setEdit(false);

                while (RuleManager.instance.hasRule(_workingRidge)) {
                    _history.push(_workingRidge.clone());
                    RuleManager.instance.applyRule(_workingRidge);
                }

                checkFinish();
                update();
            }, RuleManager.instance.api.localization.button.execute);


            var animateButton:SimpleButton = ImageHolder.createButton(this, "anim", SettingsManager.instance.areaWidth / 2 + 100, 50 + 2 * SettingsManager.instance.ridgeHeight + SettingsManager.instance.ruleHeight, function () {
                if(animate){
                    return;
                }

                if(!RuleManager.instance.hasRule(_workingRidge) || !RuleManager.instance.isValid()){
                    return;
                }

                RuleManager.instance.setEdit(false);
                animate=true;
                animateStep();
            }, RuleManager.instance.api.localization.button.animate);


            var nextButton:SimpleButton = ImageHolder.createButton(this, ">", SettingsManager.instance.areaWidth / 2 + 200, 2 * SettingsManager.instance.ridgeHeight + SettingsManager.instance.ruleHeight, function () {
                if(animate){
                    return;
                }
                if(!RuleManager.instance.hasRule(_workingRidge) || !RuleManager.instance.isValid()){
                    return;
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


            var resetButton:SimpleButton = ImageHolder.createButton(this, "reset", SettingsManager.instance.areaWidth / 2, 50 + 2 * SettingsManager.instance.ridgeHeight + SettingsManager.instance.ruleHeight, function () {
                animate=false;
                reset();
                RuleManager.instance.setEdit(true);
                update();
            }, RuleManager.instance.api.localization.button.reset);

        }else{

            addChildTo(createField(RuleManager.instance.api.localization.label.solution), SettingsManager.instance.areaWidth / 2+10, 10+2*SettingsManager.instance.ridgeHeight+SettingsManager.instance.ruleHeight);

            RuleManager.instance.result.size = RuleManager.instance.rules.length;
            drawResult(RuleManager.instance.result, SettingsManager.instance.areaWidth / 2+10, 25+2*SettingsManager.instance.ridgeHeight+SettingsManager.instance.ruleHeight);

            var editButton:SimpleButton = ImageHolder.createButton(this, "edit", SettingsManager.instance.areaWidth-50, SettingsManager.instance.areaHeight-25, function () {
                reset();
                RuleManager.instance.setEdit(true);
                RuleManager.instance.finish=false;
                update();
            }, RuleManager.instance.api.localization.button.edit);
        }


        addChildTo(createField(RuleManager.instance.api.localization.label.record), 10, 10+2*SettingsManager.instance.ridgeHeight+SettingsManager.instance.ruleHeight);

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

    private function checkFinish():void {
        if (!RuleManager.instance.hasRule(_workingRidge)) {
            animate=false;
            RuleManager.instance.result.diff=0;
            RuleManager.instance.finish = true;
            deselect();
            RuleManager.instance.deselect();

            for(var i:int=0; i<_workingRidge.tiles.length; i++){
                if(_workingRidge.tiles[i].symbol.code!=_correctRidge.tiles[i].symbol.code){
                   RuleManager.instance.result.diff++;
                    _workingRidge.tiles[i].select=true;
                    _correctRidge.tiles[i].select=true;
                }
            }

        }
    }

    private function drawResult(result:Level0Data, x:Number, y:int):void {
        addChildTo(createField(RuleManager.instance.api.localization.label.difference+":"+result.diff), x, y);
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
