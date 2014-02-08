/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 10.02.11
 * Time: 21:27
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.base.displays {
import flash.display.DisplayObject;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.ipo.kio.api.FileUtils;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.api.controls.BrightnessFilter;
import ru.ipo.kio.base.GlobalMetrics;
import ru.ipo.kio.base.KioBase;
import ru.ipo.kio.base.resources.Resources;

public class ProblemsDisplay extends Sprite {

    public static var firstTimeInitialized:Boolean = false;

    public function ProblemsDisplay() {
        if (!firstTimeInitialized) {
            KioBase.instance.log('Program started', []);
            firstTimeInitialized = true;
        }

        DisplayUtils.placeBackground(this);

        var loc:Object = KioApi.getLocalization(KioBase.BASE_API_ID);

        var message:TextField = TextUtils.createCustomTextField();
        message.htmlText = "<p class='h1'>" + loc.screen.problems.header + "</p>";
        message.width = GlobalMetrics.DISPLAYS_TEXT_WIDTH;
        message.x = (GlobalMetrics.STAGE_WIDTH - message.textWidth/*GlobalMetrics.DISPLAYS_TEXT_WIDTH*/) / 2;
        message.y = GlobalMetrics.DISPLAYS_TEXT_TOP;

        addChild(message);

        for (var i:int = 0; i < 3; i++) {
            var problem:KioProblem = KioBase.instance.problem(i);
            var title:String = String(DisplayUtils.getKeyByLevel(KioApi.getLocalization(problem.id), 'title', problem.level));

            var imageClass:Class;
            if (problem.icon)
                imageClass = problem.icon;
            else
                imageClass = Resources.NO_PROBLEM_IMG;

            var upDownImage:* = new imageClass;

            var over:DisplayObject = new imageClass;
            over.filters = [BrightnessFilter(5/4)];

            var prb:SimpleButton = new SimpleButton(upDownImage, over, upDownImage, upDownImage);

            prb.y = message.y + message.textHeight + 20;
            var skip:int = 20;
            var emptySpace:int = (GlobalMetrics.STAGE_WIDTH - prb.width * 3 - 2 * skip) / 2;
            prb.x = emptySpace + i * prb.width + i * skip;
//            prb.x = (GlobalMetrics.STAGE_WIDTH / 4) * (i + 1) - prb.width / 2;

            addChild(prb);

            var caption:TextField = TextUtils.createCustomTextField();
            caption.width = prb.width;
            //caption.autoSize = TextFieldAutoSize.CENTER;
            caption.htmlText = "<p class='c'>" + title + "</p>";
            caption.x = prb.x;// + (prb.width - caption.textWidth) / 2;
            caption.y = prb.y + prb.height + 10;

            addChild(caption);

            prb.addEventListener(MouseEvent.CLICK, function(pind:int):Function {
                return function(event:Event):void {
                    KioBase.instance.log('BTN select problem ' + pind, []);
                    KioBase.instance.setProblem(pind);
                }
            }(i));
        }

        var formButton:SimpleButton = new ShellButton(loc.screen.problems.fill_form, true);
        var saveButton:SimpleButton = new ShellButton(loc.buttons.save_workspace, true);
        var aboutButton:SimpleButton = new ShellButton(loc.screen.problems.about, true);

        formButton.x = Math.floor((GlobalMetrics.STAGE_WIDTH - formButton.width) / 2);
        saveButton.x = Math.floor((GlobalMetrics.STAGE_WIDTH - saveButton.width) / 2);
        aboutButton.x = Math.floor((GlobalMetrics.STAGE_WIDTH - aboutButton.width) / 2);
        formButton.y = 440;
        saveButton.y = 505;
        aboutButton.y = 540;

        addChild(formButton);
        addChild(aboutButton);
        addChild(saveButton);

        formButton.addEventListener(MouseEvent.CLICK, formButtonClick);
        saveButton.addEventListener(MouseEvent.CLICK, saveButtonClick);
        aboutButton.addEventListener(MouseEvent.CLICK, aboutButtonClick);

        /*var aboutButton:SimpleButton = new ShellButton(loc.screen.problems.about);
        aboutButton.x = GlobalMetrics.H_PADDING;
        aboutButton.y = GlobalMetrics.STAGE_HEIGHT - GlobalMetrics.H_PADDING - aboutButton.height;
        addChild(aboutButton);
        aboutButton.addEventListener(MouseEvent.CLICK, aboutButtonClick);*/

        var helpButton:SimpleButton = new ShellButton(loc.contest_panel.help_header);
        helpButton.x = GlobalMetrics.H_PADDING;
        helpButton.y = GlobalMetrics.STAGE_HEIGHT - GlobalMetrics.H_PADDING - helpButton.height;
        addChild(helpButton);
        helpButton.addEventListener(MouseEvent.CLICK, helpButtonClick);

        KioBase.instance.initMouseKeyboardLoggers();
    }

    private function helpButtonClick(event:Event):void {
        KioBase.instance.log('BTN help in problems', []);
        KioBase.instance.currentDisplay = new HelpDisplay(null, false);
    }

    private function saveButtonClick(event:Event):void {
        KioBase.instance.log('BTN save all in problems', []);
        FileUtils.saveAll();
    }

    private function loadButtonClick(event:Event):void {
        KioBase.instance.log('BTN load in problems', []);
        FileUtils.loadAll();
    }

    private function aboutButtonClick(event:Event):void {
        KioBase.instance.log('BTN about in problems', []);
        KioBase.instance.currentDisplay = new AboutDisplay;
    }

    private function formButtonClick(event:Event):void {
        KioBase.instance.log('BTN anketa in problems', []);
        KioBase.instance.currentDisplay = new AnketaDisplay;
    }

}
}
