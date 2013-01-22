/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 24.02.11
 * Time: 12:52
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.base.displays {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.system.Security;
import flash.system.SecurityPanel;
import flash.text.TextField;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.base.GlobalMetrics;
import ru.ipo.kio.base.KioBase;
import ru.ipo.kio.base.resources.Resources;

public class DisplayUtils {

    private static var BG_IMAGE:DisplayObject = new Resources.BG_IMAGE;

    public static function placeBackground(display:Sprite):void {
        //place background

        display.addChild(BG_IMAGE);

        //place title

        placeHeader(display);
    }

    public static function placeHeader(display:DisplayObjectContainer, problem:KioProblem = null):TextField {
        var loc:Object = KioApi.getLocalization(KioBase.BASE_API_ID);
        var title:String;
        if (problem) {
            var loc_pr:Object = KioApi.getLocalization(problem.id);
            title = loc.contest_panel.problem_header + " \"" +
                    getKeyByLevel(loc_pr, 'title', problem.level) +
                    "\"";
        }
        else
            title = loc.contest_header + ", " + loc.contest_level[KioBase.instance.level];

        var header:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13, false);
        header.x = 10;
        header.y = 2;
        header.text = title;
        display.addChild(header);

        return header;
    }

    public static function placeContinueButton(display:Sprite):SimpleButton {
        var continueButton:SimpleButton = new ShellButton(KioApi.getLocalization(KioBase.BASE_API_ID).screen.buttons.continue_);
        continueButton.x = GlobalMetrics.STAGE_WIDTH - continueButton.width - GlobalMetrics.H_PADDING;
        continueButton.y = GlobalMetrics.STAGE_HEIGHT - continueButton.height - GlobalMetrics.V_PADDING;

        display.addChild(continueButton);

        return continueButton;
    }

    public static function getSettingsSprite():Sprite {
        var loc:Object = KioApi.getLocalization(KioBase.BASE_API_ID).screen;

        var settings_sprite:Sprite = new Sprite;

        var img:* = new Resources.SETTINGS_HELPER_RU;
        settings_sprite.addChild(img);

        var setupButton:SimpleButton = new ShellButton(loc.settings.configure_button);
        setupButton.x = Math.floor(img.x + img.width + 32);
        setupButton.y = Math.floor(img.y + (img.height - setupButton.height) / 2);
        setupButton.addEventListener(MouseEvent.CLICK, setupClicked);

        settings_sprite.addChild(setupButton);
        return settings_sprite;
    }

    private static function setupClicked(event:Event):void {
        Security.showSettings(SecurityPanel.LOCAL_STORAGE);
    }

    public static function getKeyByLevel(o:Object, key:String, level:int):Object {
        if (o[key + level])
            return o[key + level];
        else if (o[key])
            return o[key];
        else
            return "no key";
    }

}
}