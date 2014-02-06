/**
 *
 * @author: Vasiliy
 * @date: 05.05.13
 */
package ru.ipo.kio.base.logdebug {
import flash.text.TextField;

import ru.ipo.kio.base.*;

import fl.controls.Button;
import fl.controls.TextArea;

import flash.display.Sprite;
import flash.events.MouseEvent;


public class LogDebuggerView  extends Sprite{

    private var playButton:Button = new Button();
    private var pauseButton:Button = new Button();
    private var stopButton:Button = new Button();
    private var loadButton:Button = new Button();

    private var speedInput:TextField = new TextField();

    private var buttonUp:Button = new Button();
    private var buttonDown:Button = new Button();

    private var logDebugger:LogDebugger;

    private var commandArea:TextArea = new TextArea();

    private var indexes:Vector.<Array> = new Vector.<Array>();

    public function LogDebuggerView(logDebugger:LogDebugger){
        this.logDebugger=logDebugger;
        commandArea.text = "Hello World";
        addChild(commandArea);
        commandArea.x = 10;
        commandArea.width=500;
        commandArea.height=GlobalMetrics.DEBUGGER_HEIGHT;

        var label:TextField = new TextField();
        label.text="delay:";
        addChild(label);
        label.x=550;
        label.y=60;

        addChild(speedInput);
        speedInput.text = ""+ logDebugger.delay;
        speedInput.x=600;
        speedInput.y=60;

        addChild(buttonUp);
        buttonUp.label=">" ;
        buttonUp.x = 680;
        buttonUp.y = 60;
        buttonUp.width = 30;
        buttonUp.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            logDebugger.delay++;
            speedInput.text = "" + logDebugger.delay;
        });
        addChild(buttonDown);
        buttonDown.label="<" ;
        buttonDown.x = 650;
        buttonDown.y = 60;
        buttonDown.width = 30;
        buttonDown.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            logDebugger.delay--;
            speedInput.text = "" + logDebugger.delay;
        });

        placeButtons();
    }

    internal function updateSelection():void{
        var index:int = logDebugger.currentIndex;
        commandArea.setSelection(indexes[index][0], indexes[index][1]);
        commandArea.setFocus();
    }

    internal function updateCommands():void{
        commandArea.text = "";
        indexes = new Vector.<Array>();
        for each(var command:LogDebugCommand in logDebugger.commands){
            var commandIndexes:  Array = [];
            commandIndexes.push(commandArea.text.length);
            commandArea.appendText(command.text+"\n");
            commandIndexes.push(commandArea.text.length);
            indexes.push(commandIndexes);
        }
    }

    private function placeButtons():void {
        playButton.label = "play";
        addChild(playButton);
        playButton.x = 550;
        playButton.y = 20;
        playButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            playButton.visible = false;
            pauseButton.visible = true;
            logDebugger.play();
        });

        pauseButton.label = "pause";
        pauseButton.visible=false;
        addChild(pauseButton);
        pauseButton.x = 550;
        pauseButton.y = 20;
        pauseButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            pauseButton.visible = false;
            playButton.visible = true;
            logDebugger.pause();
        });

        stopButton.label = "stop";
        addChild(stopButton);
        stopButton.x = 650;
        stopButton.y = 20;
        stopButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            logDebugger.stop();
            pauseButton.visible = false;
            playButton.visible = true;
        });

        loadButton.label = "load";
        addChild(loadButton);
        loadButton.x = 750;
        loadButton.y = 20;
        loadButton.addEventListener(MouseEvent.CLICK, function (e:MouseEvent):void {
            logDebugger.load();
        });
    }

}
}
