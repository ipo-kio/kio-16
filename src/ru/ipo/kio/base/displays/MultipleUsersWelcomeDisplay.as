/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 06.03.11
 * Time: 13:19
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

public class MultipleUsersWelcomeDisplay extends Sprite {
    
    private static const COLUMN_SIZE:int = 8;

    //TODO if there are too many participants, the contents doesn't fit the screen
    public function MultipleUsersWelcomeDisplay() {
        DisplayUtils.placeBackground(this);

        var loc:* = KioApi.getLocalization(KioBase.BASE_API_ID).screen;

        //greeting

        var mainMessage:TextField = TextUtils.createCustomTextField();
        mainMessage.htmlText = '<html><p class="h1">' + loc.welcome.greeting + '</p></html>';
        mainMessage.width = GlobalMetrics.DISPLAYS_TEXT_WIDTH;
        mainMessage.x = (GlobalMetrics.STAGE_WIDTH - GlobalMetrics.DISPLAYS_TEXT_WIDTH) / 2;
        mainMessage.y = GlobalMetrics.DISPLAYS_TEXT_TOP;

        addChild(mainMessage);

        //choose message

        var chooseMessage:TextField = TextUtils.createCustomTextField();
        chooseMessage.htmlText = '<html><p>' + loc.welcome.mainMessage_many + '</p></html>';
        chooseMessage.width = GlobalMetrics.STAGE_WIDTH - 2 * GlobalMetrics.H_PADDING;
        chooseMessage.x = GlobalMetrics.H_PADDING;
        chooseMessage.y = mainMessage.y + mainMessage.textHeight + 10;

        addChild(chooseMessage);

        //all participants list

        var userCount:int = KioBase.instance.lsoProxy.userCount();

        var y0:int = chooseMessage.y + chooseMessage.textHeight + 10;

        if (userCount > COLUMN_SIZE) {
            for (var user:int = 0; user < userCount; user++) {
                var go_user_button:SimpleButton = new ShellButton(KioBase.instance.lsoProxy.getUserInfo(user,  false, false), true);
                
                var col:int = user / COLUMN_SIZE;
                var line:int = user % COLUMN_SIZE;

                go_user_button.x = GlobalMetrics.H_PADDING + col * (go_user_button.width + 7);
                go_user_button.y = y0 + line * (go_user_button.height + 5);
                addChild(go_user_button);

                go_user_button.addEventListener(MouseEvent.CLICK, function(user:int):Function { //TODO code duplication
                    return function(event:Event):void {
                        KioBase.instance.lsoProxy.userIndex = user;
                        KioBase.instance.currentDisplay = new ProblemsDisplay;
                    };
                }(user));
            }
            
            y0 += COLUMN_SIZE * (go_user_button.height + 5);
        } else {
            for (user = 0; user < userCount; user++) {
                go_user_button = new ShellButton(loc.welcome.button_go, false);
                go_user_button.x = GlobalMetrics.H_PADDING;
                go_user_button.y = y0;
                addChild(go_user_button);
                go_user_button.addEventListener(MouseEvent.CLICK, function(user:int):Function { //TODO code duplication
                    return function(event:Event):void {
                        KioBase.instance.lsoProxy.userIndex = user;
                        KioBase.instance.currentDisplay = new ProblemsDisplay;
                    };
                }(user));

                var info:TextField = TextUtils.createCustomTextField(false);
                info.width = GlobalMetrics.STAGE_WIDTH - 2 * GlobalMetrics.H_PADDING - 10 - go_user_button.width;
                info.x = 10 + go_user_button.x + go_user_button.width;
                info.y = y0;

                info.htmlText = "<html><p>" + KioBase.instance.lsoProxy.getUserInfo(user, true) + "</p></html>";

                addChild(info);

                y0 += go_user_button.height + 5;
            }
        }

        var continuationMessage:TextField = TextUtils.createCustomTextField();
        continuationMessage.htmlText = '<html><p class="footnote">' +
                loc.welcome.mainMessage_many_continuation +
                "<li class='footnote'>" + loc.welcome.message_new_participant + "</li>" +
                "<li class='footnote'>" + loc.welcome.message_old_participant + "</li>" +
                '</p></html>';
        continuationMessage.width = GlobalMetrics.STAGE_WIDTH - 2 * GlobalMetrics.H_PADDING;
        continuationMessage.x = GlobalMetrics.H_PADDING;
        continuationMessage.y = y0 + 10;

        addChild(continuationMessage);

        //new participant button

        var newParticipantButton:SimpleButton = new ShellButton(loc.welcome.button_new_participant, false);
        newParticipantButton.x = continuationMessage.x;
        newParticipantButton.y = Math.floor(continuationMessage.y + continuationMessage.height + 10);

        addChild(newParticipantButton);

        //load workspace button

        var loadWorkspaceButton:SimpleButton = new ShellButton(loc.buttons.loadWorkspace, false);
        loadWorkspaceButton.x = newParticipantButton.x + newParticipantButton.width + 10;
        loadWorkspaceButton.y = newParticipantButton.y;

        addChild(loadWorkspaceButton);

        loadWorkspaceButton.addEventListener(MouseEvent.CLICK, loadWorkspaceButtonClicked);
        newParticipantButton.addEventListener(MouseEvent.CLICK, newParticipantButtonClicked);
    }

    private static function loadWorkspaceButtonClicked(event:Event):void {
        KioBase.instance.lsoProxy.createNewParticipant();
        FileUtils.loadAll();
    }

    private static function newParticipantButtonClicked(event:Event):void {
        KioBase.instance.lsoProxy.createNewParticipant();
        KioBase.instance.currentDisplay = new AnketaDisplay(MultipleUsersWelcomeDisplay);
    }
}
}
