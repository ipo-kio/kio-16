/**
 *
 * @author: Vasiliy
 * @date: 23.02.13
 */
package ru.ipo.kio._13.clock.view.controls {
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;

import ru.ipo.kio._13.clock.ClockProblem;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.base.displays.ShellButton;

public class AbstractPanel extends Sprite {
    public function AbstractPanel() {
    }


    protected function addSettingField(name:String, x:int, y:int, initialValue:int, action:Function):Object {
        var loc:Object = KioApi.getLocalization(ClockProblem.ID);
        var settingFieldLabel:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        settingFieldLabel.htmlText = "<p align='center'>" + loc.headers[name] + "</p>";;
        settingFieldLabel.type = TextFieldType.DYNAMIC;
        settingFieldLabel.x = x;
        settingFieldLabel.y = y;
        var settingField:TextField = new TextField();
        settingField.type = TextFieldType.INPUT;
        settingField.text=""+initialValue;
        settingField.border=true;
        settingField.x = x+10;
        settingField.y = y+settingFieldLabel.textHeight+5;
        settingField.width=90;
        settingField.height=20;
        settingField.addEventListener(KeyboardEvent.KEY_DOWN, action);
        return {"label":settingFieldLabel, "field":settingField};
    }


    protected function createButton(caption:String, x:int, y:int, func:Function, high:Boolean = true):ShellButton {
        var loc:Object = KioApi.getLocalization(ClockProblem.ID);
        var clearButton:ShellButton = new ShellButton(loc.buttons[caption], false, high);
        addChild(clearButton);
        clearButton.x = x;
        clearButton.y = y;
        clearButton.addEventListener(MouseEvent.CLICK, func);
        return clearButton;
    }

}
}
