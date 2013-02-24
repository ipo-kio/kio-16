/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 10.02.11
 * Time: 21:49
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
import ru.ipo.kio.base.GlobalMetrics;
import ru.ipo.kio.base.KioBase;

public class SettingsDisplay extends Sprite {

    public function SettingsDisplay() {
        DisplayUtils.placeBackground(this);

        var loc:Object = KioApi.getLocalization(KioBase.BASE_API_ID).screen;

        var message:TextField = TextUtils.createCustomTextField();
        message.htmlText = loc.settings.mainMessage;
        message.width = GlobalMetrics.DISPLAYS_TEXT_WIDTH;
        message.x = (GlobalMetrics.STAGE_WIDTH - GlobalMetrics.DISPLAYS_TEXT_WIDTH) / 2;
        message.y = GlobalMetrics.DISPLAYS_TEXT_TOP;

        addChild(message);

        //settings sprite with image and button

        var settings_sprite:Sprite = DisplayUtils.getSettingsSprite();

        settings_sprite.x = Math.floor((GlobalMetrics.STAGE_WIDTH - settings_sprite.width) / 2);
        settings_sprite.y = Math.floor(message.y + message.textHeight + 10);
        addChild(settings_sprite);

        //message continuation

        var messageContinuation:TextField = TextUtils.createCustomTextField();
        messageContinuation.htmlText = loc.settings.mainMessageContinuation;
        messageContinuation.width = GlobalMetrics.DISPLAYS_TEXT_WIDTH;
        messageContinuation.x = (GlobalMetrics.STAGE_WIDTH - GlobalMetrics.DISPLAYS_TEXT_WIDTH) / 2;
        messageContinuation.y = settings_sprite.y + settings_sprite.height + 10;

        addChild(messageContinuation);

        var continueButton:SimpleButton = DisplayUtils.placeContinueButton(this);

        continueButton.addEventListener(MouseEvent.CLICK, continueButtonClicked);
    }

    private function continueButtonClicked(event:Event):void {
        KioBase.instance.log('BTN continue in settings', []);

        KioBase.instance.currentDisplay = new AnketaDisplay;

        var lso:LsoProxy = KioBase.instance.lsoProxy;
        lso.getGlobalData().anketa_filled = false; //used in KioBase to test what screen to display at start
        lso.flush();
    }

}
}
