/**
 *
 * @author: Vasiliy
 * @date: 30.12.12
 */
package ru.ipo.kio._13.clock {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

import ru.ipo.kio._13.clock.model.SettingsHolder;
import ru.ipo.kio._13.clock.model.TransferGear;
import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.utils.ColorGenerator;
import ru.ipo.kio._13.clock.view.controls.AbstractPanel;
import ru.ipo.kio._13.clock.view.controls.AnimatePanel;
import ru.ipo.kio._13.clock.view.controls.EditPanel;
import ru.ipo.kio._13.clock.view.controls.InfoPanel;
import ru.ipo.kio.api.KioApi;

public class ClockSprite extends AbstractPanel {

    //todo remove and add as listener
    public static var instance:ClockSprite;

    private var settingsPanel:Sprite = new Sprite();

    private var animatePanel:AnimatePanel;

    private var editPanel:EditPanel;

    private var resultPanel:InfoPanel;

    private var bestPanel:InfoPanel;

    private var errorSprite:Sprite = new Sprite();

    private var errorText:TextField = new TextField();

    public function ClockSprite() {
        instance=this;
        errorSprite.addChild(errorText);
        errorSprite.addEventListener(MouseEvent.CLICK, function(e:Event):void{
           removeChild(errorSprite);
        });
        addChild(TransmissionMechanism.instance.view);
        addChild(TransmissionMechanism.instance.viewSide);
        TransmissionMechanism.instance.viewSide.y = 400;
        TransmissionMechanism.instance.viewSide.x = 110;
        TransmissionMechanism.instance.view.x = 110;



        if(SettingsHolder.instance.levelImpl.level==0){
            TransmissionMechanism.instance.addTransferGear(new TransferGear(TransmissionMechanism.instance, 320, 200, 30, 15, ColorGenerator.nextHueOfColor(TransmissionMechanism.instance.transferGearList)));
            TransmissionMechanism.instance.addTransferGear(new TransferGear(TransmissionMechanism.instance, 380, 260, 20, 15, ColorGenerator.nextHueOfColor(TransmissionMechanism.instance.transferGearList)));
            TransmissionMechanism.instance.addTransferGear(new TransferGear(TransmissionMechanism.instance, 475, 225, 30, 20, ColorGenerator.nextHueOfColor(TransmissionMechanism.instance.transferGearList)));
        }else  if(SettingsHolder.instance.levelImpl.level==1){
            TransmissionMechanism.instance.addTransferGear(new TransferGear(TransmissionMechanism.instance, 320, 200, 30, 15, ColorGenerator.nextHueOfColor(TransmissionMechanism.instance.transferGearList)));
            TransmissionMechanism.instance.addTransferGear(new TransferGear(TransmissionMechanism.instance, 365, 260, 20, 15, ColorGenerator.nextHueOfColor(TransmissionMechanism.instance.transferGearList)));
            TransmissionMechanism.instance.addTransferGear(new TransferGear(TransmissionMechanism.instance, 450, 225, 30, 20, ColorGenerator.nextHueOfColor(TransmissionMechanism.instance.transferGearList)));
        }else  if(SettingsHolder.instance.levelImpl.level==2){
            TransmissionMechanism.instance.addTransferGear(new TransferGear(TransmissionMechanism.instance, 320, 200, 30, 15, ColorGenerator.nextHueOfColor(TransmissionMechanism.instance.transferGearList)));
            TransmissionMechanism.instance.addTransferGear(new TransferGear(TransmissionMechanism.instance, 360, 275, 20, 15, ColorGenerator.nextHueOfColor(TransmissionMechanism.instance.transferGearList)));
            TransmissionMechanism.instance.addTransferGear(new TransferGear(TransmissionMechanism.instance, 385, 200, 30, 20, ColorGenerator.nextHueOfColor(TransmissionMechanism.instance.transferGearList)));
        }



        /*for(var j:int=1; j<5; j++){
            for(var k:int=1; k<5; k++){
                var y:int = k*87;
                if(j%2==0){
                  y=(5-k)*87;
                }
                if(j ==1 && k ==1){
                    transmissionMechanism.addTransferGear(new TransferGear(transmissionMechanism, j*87, y, 25, 20, ColorGenerator.nextHueOfColor(transmissionMechanism.transferGearList)));
                }else{
                    transmissionMechanism.addTransferGear(new TransferGear(transmissionMechanism, j*87, y, 20, 10, ColorGenerator.nextHueOfColor(transmissionMechanism.transferGearList)));
                }
            }
        }*/

        addSettingsPanel();
    }
    
    public function showError(text:String):void{
        errorSprite.graphics.clear();
        errorSprite.graphics.beginFill(0xffffff,0.7);
        errorSprite.graphics.drawRect(115,0,675,400);
        errorSprite.graphics.endFill();
        errorText.text = text;
        var format:TextFormat = new TextFormat("Arial", 20, 0xff0000);
        errorText.setTextFormat(format);
        errorText.x=100+(700-errorText.textWidth)/2;
        errorText.width=errorText.textWidth+20;
        errorText.height=errorText.textHeight+20;
        errorText.y=(500-errorText.textHeight)/2;

        addChild(errorSprite);
    }


    private function addSettingsPanel():void {
        addChild(settingsPanel);
        settingsPanel.x = 5;
        settingsPanel.graphics.beginFill(0xCCCCCC);
        settingsPanel.graphics.drawRect(0, 0, 110, 600);

        animatePanel = new AnimatePanel();
        animatePanel.y = 5;
        settingsPanel.addChild(animatePanel);

        editPanel = new EditPanel();
        editPanel.y = 145;
        settingsPanel.addChild(editPanel);

        resultPanel=new InfoPanel("result");
        resultPanel.y = 310;
        settingsPanel.addChild(resultPanel);


        bestPanel=new InfoPanel("best");
        if(SettingsHolder.instance.levelImpl.level==0){
            bestPanel.y = 450;
        }else{
            bestPanel.y = 430;
        }
        settingsPanel.addChild(bestPanel);

    }

    public function update():void{
        var error:Number = TransmissionMechanism.instance.relTransmissionError;
        if(resultPanel!=null){
            if(TransmissionMechanism.instance.isFinished()&&
            !TransmissionMechanism.instance.isConflict()){
                resultPanel.updateNumbers(TransmissionMechanism.instance.isCorrectDirection(), SettingsHolder.instance.levelImpl.getFormattedError(error), TransmissionMechanism.instance.square);
            }else{
                resultPanel.updateNumbers(TransmissionMechanism.instance.isCorrectDirection(), SettingsHolder.instance.levelImpl.getFormattedError(error));
            }
            updateAnimateButtons();
            resultPanel.displayCrashMaker(TransmissionMechanism.instance.isConflict());
            KioApi.instance(ClockProblem.ID).submitResult(KioApi.instance(ClockProblem.ID).problem.best);
            updateBest(KioApi.instance(ClockProblem.ID).record_result);
        }
    }

    private function updateBest(result:Object):void{
        if(result==null){
            return;
        }
        var error:Number = SettingsHolder.instance.levelImpl.undoTruncate(result.absTransmissionError);
        if(bestPanel!=null){
            if(result.finished){
                bestPanel.updateNumbers(result.rightDirection, SettingsHolder.instance.levelImpl.getFormattedError(error), result.square);
            }else{
                bestPanel.updateNumbers(result.rightDirection, SettingsHolder.instance.levelImpl.getFormattedError(error));
            }
            bestPanel.displayCrashMaker(result.conflict);
        }
    }

    public function updateAnimateButtons():void {
       animatePanel.updateAnimateButtons();
    }


}
}
