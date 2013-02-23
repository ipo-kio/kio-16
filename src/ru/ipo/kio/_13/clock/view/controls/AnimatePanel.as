/**
 *
 * @author: Vasiliy
 * @date: 23.02.13
 */
package ru.ipo.kio._13.clock.view.controls {
import fl.controls.ComboBox;

import flash.events.Event;

import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import ru.ipo.kio._13.clock.ClockProblem;

import ru.ipo.kio._13.clock.model.SettingsHolder;

import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.base.displays.ShellButton;

public class AnimatePanel extends AbstractPanel {

    private var _playButton:ShellButton;

    private var _stopButton:ShellButton;

    private var _cbSpeed:ComboBox = new ComboBox();


    public function AnimatePanel() {
        addChild(addSettingField("rotate", 0, 5, 0, function (e:KeyboardEvent):void {}).label);

        var loc:Object = KioApi.getLocalization(ClockProblem.ID);
        addChild(_cbSpeed);
        _cbSpeed.x = 5;
        _cbSpeed.y=25;
        _cbSpeed.width= 100;
        _cbSpeed.addItem( { label: loc.headers.very_slow, data:TransmissionMechanism.VERY_SLOW_SPEED } );
        _cbSpeed.addItem( { label: loc.headers.slow, data:TransmissionMechanism.SLOW_SPEED } );
        _cbSpeed.addItem( { label: loc.headers.middle, data:TransmissionMechanism.MIDDLE_SPEED } );
        _cbSpeed.addItem( { label: loc.headers.fast, data:TransmissionMechanism.FAST_SPEED } );
        _cbSpeed.addItem( { label: loc.headers.very_fast, data:TransmissionMechanism.VERY_FAST_SPEED } );
        _cbSpeed.selectedIndex=2;

        _cbSpeed.addEventListener(Event.CHANGE, speedSelected);


        addChild(createButton("step", 5, 55, function (event:MouseEvent):void {
            KioApi.instance(ClockProblem.ID).log("BTN STEP ROTATE");
            TransmissionMechanism.instance.rotate(SettingsHolder.instance.stepRotateInRadians);
        }, false));

        _playButton = createButton("play", 5, 85, function (event:MouseEvent):void {
            KioApi.instance(ClockProblem.ID).log("BTN PLAY");
            TransmissionMechanism.instance.playStop();
        }, false);
        addChild(_playButton);

        _stopButton = createButton("stop", 5, 85, function (event:MouseEvent):void {
            KioApi.instance(ClockProblem.ID).log("BTN STOP");
            TransmissionMechanism.instance.playStop();
        }, false);
        addChild(_stopButton);

        _stopButton.visible=false;
        _playButton.visible=true;

        addChild(createButton("reset", 5, 115, function (event:MouseEvent):void {
            KioApi.instance(ClockProblem.ID).log("BTN RESET");
            TransmissionMechanism.instance.resetAlpha();
            TransmissionMechanism.instance.view.update();
        }, false));

    }

    private function speedSelected(e:Event):void {
        SettingsHolder.instance.stepRotate = Number(_cbSpeed.selectedItem.data);
    }

    public function updateAnimateButtons():void {
        if (TransmissionMechanism.instance.isPlay()) {
            _stopButton.visible = true;
            _playButton.visible = false;
        } else {
            _stopButton.visible = false;
            _playButton.visible = true;
        }
    }
}
}
