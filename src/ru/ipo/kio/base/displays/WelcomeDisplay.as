/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 10.02.11
 * Time: 20:06
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.base.displays {
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.ipo.kio.api.FileUtils;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.base.GlobalMetrics;
import ru.ipo.kio.base.KioBase;

public class WelcomeDisplay extends Sprite {

    public function WelcomeDisplay() {
        DisplayUtils.placeBackground(this);

        var loc:* = KioApi.getLocalization(KioBase.BASE_API_ID).screen;

        var mainMessage:TextField = TextUtils.createCustomTextField();
        mainMessage.htmlText = '<html><p class="h1">' + loc.welcome.greeting + '</p><p></p>' + loc.welcome.mainMessage_0 + '</html>';
        mainMessage.width = GlobalMetrics.DISPLAYS_TEXT_WIDTH;
        mainMessage.x = (GlobalMetrics.STAGE_WIDTH - GlobalMetrics.DISPLAYS_TEXT_WIDTH) / 2;
        mainMessage.y = GlobalMetrics.DISPLAYS_TEXT_TOP;

        addChild(mainMessage);

        var loadWorkspaceMessage:TextField = TextUtils.createCustomTextField();
        loadWorkspaceMessage.htmlText = '<p class="footnote">' + loc.welcome.message_old_participant + '</p>';
        loadWorkspaceMessage.width = GlobalMetrics.DISPLAYS_TEXT_WIDTH;
        loadWorkspaceMessage.x = (GlobalMetrics.STAGE_WIDTH - GlobalMetrics.DISPLAYS_TEXT_WIDTH) / 2;
        loadWorkspaceMessage.y = mainMessage.y + mainMessage.textHeight + 50;

        addChild(loadWorkspaceMessage);

        var loadWorkspaceButton:SimpleButton = new ShellButton(loc.buttons.loadWorkspace);
        loadWorkspaceButton.x = Math.floor((GlobalMetrics.STAGE_WIDTH - loadWorkspaceButton.width) / 2);
        loadWorkspaceButton.y = Math.floor(loadWorkspaceMessage.y + loadWorkspaceMessage.textHeight + 20);

        addChild(loadWorkspaceButton);

        var continueButton:SimpleButton = DisplayUtils.placeContinueButton(this);

        loadWorkspaceButton.addEventListener(MouseEvent.CLICK, loadWorkspaceButtonClicked);
        continueButton.addEventListener(MouseEvent.CLICK, continueButtonClicked);
    }

    private function continueButtonClicked(event:Event):void {
        KioBase.instance.lsoProxy.createNewParticipant();
        KioBase.instance.currentDisplay = new SettingsDisplay;
    }

    private function loadWorkspaceButtonClicked(event:Event):void {
        KioBase.instance.lsoProxy.createNewParticipant();
        FileUtils.loadAll();
    }

}
}
