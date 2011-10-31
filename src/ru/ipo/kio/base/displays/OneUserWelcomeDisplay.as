/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 06.03.11
 * Time: 13:12
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

public class OneUserWelcomeDisplay extends Sprite {
    public function OneUserWelcomeDisplay() {
        DisplayUtils.placeBackground(this);

        var loc:* = KioApi.getLocalization(KioBase.BASE_API_ID).screen;

        //prepare texts

        var welcomeText:String = '<html>' +
                "<p class='h1'>" + loc.welcome.greeting + "</p>" +
                '<p></p>' +
                '<p>' + loc.welcome.mainMessage_1 + '</p>';

        var welcomeText_continuation:String = '<html>' +
                '<p class="footnote">' + loc.welcome.mainMessage_1_continuation + '</p>' +
                "<li class='footnote'>" + loc.welcome.message_new_participant + "</li>" +
                "<li class='footnote'>" + loc.welcome.message_old_participant + "</li>" +
                '</html>';

        var userInfo:String = KioBase.instance.lsoProxy.getUserInfo(0, false);

        welcomeText = welcomeText.replace(/\{name\}/g, userInfo);
        welcomeText_continuation = welcomeText_continuation.replace(/\{name\}/g, userInfo);

        //main message

        var mainMessage:TextField = TextUtils.createCustomTextField();

        mainMessage.htmlText = welcomeText;
        mainMessage.width = GlobalMetrics.DISPLAYS_TEXT_WIDTH;
        mainMessage.x = (GlobalMetrics.STAGE_WIDTH - GlobalMetrics.DISPLAYS_TEXT_WIDTH) / 2;
        mainMessage.y = GlobalMetrics.DISPLAYS_TEXT_TOP;

        addChild(mainMessage);

        //continue button

        var continueButton:SimpleButton = new ShellButton(loc.buttons.continue_, true);
        continueButton.x = Math.floor((GlobalMetrics.STAGE_WIDTH - continueButton.width) / 2);
        continueButton.y = Math.floor(mainMessage.y + mainMessage.textHeight + 10);

        addChild(continueButton);

        //next main message

        var mainMessageCont:TextField = TextUtils.createCustomTextField();

        mainMessageCont.htmlText = welcomeText_continuation;
        mainMessageCont.width = GlobalMetrics.DISPLAYS_TEXT_WIDTH * 2;
        mainMessageCont.x = (GlobalMetrics.STAGE_WIDTH - 2 * GlobalMetrics.DISPLAYS_TEXT_WIDTH) / 2;
        mainMessageCont.y = Math.floor(continueButton.y + continueButton.height + 20);

        addChild(mainMessageCont);

        //new participant button

        var newParticipantButton:SimpleButton = new ShellButton(loc.welcome.button_new_participant, false);
        newParticipantButton.x = mainMessageCont.x;
//        newParticipantButton.x = Math.floor((GlobalMetrics.STAGE_WIDTH - newParticipantButton.width) / 2);
        newParticipantButton.y = Math.floor(mainMessageCont.y + mainMessageCont.height + 10);

        addChild(newParticipantButton);

        //load workspace button

        var loadWorkspaceButton:SimpleButton = new ShellButton(loc.buttons.loadWorkspace, false);
        loadWorkspaceButton.x = newParticipantButton.x + newParticipantButton.width + 10;
//        loadWorkspaceButton.x = Math.floor((GlobalMetrics.STAGE_WIDTH - loadWorkspaceButton.width) / 2);
//        loadWorkspaceButton.y = Math.floor(newParticipantButton.y + newParticipantButton.height + 10);
        loadWorkspaceButton.y = newParticipantButton.y;

        addChild(loadWorkspaceButton);

        loadWorkspaceButton.addEventListener(MouseEvent.CLICK, loadWorkspaceButtonClicked);
        newParticipantButton.addEventListener(MouseEvent.CLICK, newParticipantButtonClicked);
        continueButton.addEventListener(MouseEvent.CLICK, continueButtonClicked);
    }

    private function newParticipantButtonClicked(event:Event):void {
        KioBase.instance.lsoProxy.createNewParticipant();
        KioBase.instance.currentDisplay = new AnketaDisplay(OneUserWelcomeDisplay);
    }

    private function continueButtonClicked(event:Event):void {
        KioBase.instance.lsoProxy.userIndex = 0;
        KioBase.instance.currentDisplay = new ProblemsDisplay;
    }

    private function loadWorkspaceButtonClicked(event:Event):void {
        KioBase.instance.lsoProxy.createNewParticipant();
        FileUtils.loadAll();
    }
}
}
