/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 11.02.11
 * Time: 10:04
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.base.displays {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.LsoProxy;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.api.controls.InputBlock;
import ru.ipo.kio.api.controls.InputTextField;
import ru.ipo.kio.base.GlobalMetrics;
import ru.ipo.kio.base.KioBase;

public class AnketaDisplay extends Sprite {

    private var inputTextFields:Array;
    private var continueButton:SimpleButton;

    public function AnketaDisplay(previousDisplay:Class = null) {
        DisplayUtils.placeBackground(this);

        var loc:Object = KioApi.getLocalization(KioBase.BASE_API_ID).screen;

        var must_be_filled:Function = function(text:String):String {
            if (trim(text).length == 0)
                return loc.form.field_must_be_filled;
            return null;
        };

        var header:TextField = TextUtils.createCustomTextField();
        header.htmlText = '<p class="h1">' + loc.form.header + '</p>';
        header.width = GlobalMetrics.DISPLAYS_TEXT_WIDTH;
        header.x = (GlobalMetrics.STAGE_WIDTH - header.textWidth) / 2;
        header.y = GlobalMetrics.DISPLAYS_TEXT_TOP;

        addChild(header);

        continueButton = DisplayUtils.placeContinueButton(this);
        continueButton.addEventListener(MouseEvent.CLICK, continueButtonClicked);

        var captionWidth:int = 150;
        var labelWidth:int = 100;
        var inputWidth:int = 300;

        var fio:InputBlock = new InputBlock(
                loc.form.participant_name,
                [
                    loc.form.surname,
                    loc.form.name,
                    loc.form.second_name
                ],
                [
                    must_be_filled,
                    must_be_filled,
                    must_be_filled
                ],
                ['surname', 'name', 'second_name'],
                captionWidth,
                labelWidth,
                inputWidth
                );

        fio.x = GlobalMetrics.ANKETA_LEFT;
        fio.y = header.y + header.textHeight + GlobalMetrics.ANKETA_BLOCK_SKIP;
        addChild(fio);

        inputTextFields = [];
        inputTextFields = inputTextFields.concat(fio.inputs);

        //load values, add listeners
        var anketa:Object = KioBase.instance.lsoProxy.getAnketa();
        for each (var inp:InputTextField in inputTextFields) {
            inp.text = anketa[inp.id];
            inp.addEventListener(Event.CHANGE, valueChanged);
        }

        setEnabledForContinueButton();

        if (previousDisplay) {
            var backButton:SimpleButton = new ShellButton(KioApi.getLocalization(KioBase.BASE_API_ID).screen.buttons.back);
            backButton.x = GlobalMetrics.H_PADDING;
            backButton.y = GlobalMetrics.STAGE_HEIGHT - backButton.height - GlobalMetrics.V_PADDING;
            addChild(backButton);

            backButton.addEventListener(MouseEvent.CLICK, function(event:Event):void {
                KioBase.instance.log('BTN back in anketa', []);
                KioBase.instance.currentDisplay = new previousDisplay;
            });
        }
    }

    private function valueChanged(event:Event):void {
        var i:InputTextField = InputTextField(event.currentTarget);
        var anketa:Object = KioBase.instance.lsoProxy.getAnketa();
        if (!i.error) {
            anketa[i.id] = i.text;
            //KioBase.instance.lsoProxy.flush(); // flush only on continue button
        }
        setEnabledForContinueButton();
    }

    private function setEnabledForContinueButton():void {
        var hasError:Boolean = false;
        for each (var inp:InputTextField in inputTextFields)
            if (inp.error) {
                hasError = true;
                break;
            }

        continueButton.enabled = ! hasError;
    }

    private function continueButtonClicked(event:Event):void {
        KioBase.instance.log('BTN continue in anketa', []);
        var anketa:Object = KioBase.instance.lsoProxy.getAnketa();
        if (continueButton.enabled) {
            KioBase.instance.log('Entered name and surname@ttt', [anketa.name, anketa.surname, anketa.second_name]);
            KioBase.instance.currentDisplay = new ProblemsDisplay;
            var lso:LsoProxy = KioBase.instance.lsoProxy;
            lso.getGlobalData().anketa_filled = true;
            lso.getGlobalData().level = KioBase.instance.level;
            lso.getGlobalData().language = KioApi.language;
            lso.flush();
        }
    }

    private static function trim(s:String):String {
        return s.replace('/ /', '');
    }
}
}