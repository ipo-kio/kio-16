package ru.ipo.kio.base {
import com.adobe.serialization.json.JSON_k;

import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.ipo.kio.api.FileUtils;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.base.displays.HelpDisplay;
import ru.ipo.kio.base.displays.ProblemsDisplay;
import ru.ipo.kio.base.displays.ShellButton;

/**
 * ...
 * @author Ilya
 */
public class ContestPanel extends Sprite {

    private var __y0:int; // y0 is the top position of current inserting element

    public function ContestPanel() {
        __y0 = 30;

        var loc:Object = KioApi.getLocalization(KioBase.BASE_API_ID).contest_panel;

        placeText(loc.records_and_anketa_header);
        var saveAllDataButton:SimpleButton = placeButton(loc.buttons.save);

        __y0 += 20;

        placeText(loc.help_header);
        var statementButton:SimpleButton = placeButton(loc.buttons.statement);
        var helpButton:SimpleButton = placeButton(loc.buttons.help);

        __y0 += 20;

        placeText(loc.record_header);
        var recordButton:SimpleButton = placeButton(loc.buttons.load);

        __y0 += 20;

        placeText(loc.current_solution_caption);
        var loadButton:SimpleButton = placeButton(loc.buttons.load);
        var saveButton:SimpleButton = placeButton(loc.buttons.save);
        //TODO clear button

        __y0 = 590;

        var backButton:SimpleButton = placeButton(loc.buttons.back);

        loadButton.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            KioBase.instance.log('BTN load in contest', []);
            FileUtils.loadSolution(KioBase.instance.currentProblem);
//                KioBase.instance.lsoProxy.getGlobalData().push = 239;
//                KioBase.instance.lsoProxy.flush();             0
        });

        saveButton.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            KioBase.instance.log('BTN save in contest', []);
            FileUtils.saveSolution(KioBase.instance.currentProblem);
        });


        backButton.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            KioBase.instance.log('BTN back in contest', []);
            KioBase.instance.currentDisplay = new ProblemsDisplay;
        });

        recordButton.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            KioBase.instance.log('BTN record in contest', []);
            var problem:KioProblem = KioBase.instance.currentProblem;
            var pd:Object = KioBase.instance.lsoProxy.getProblemData(problem.id);
            if (pd.best) {
                KioApi.instance(problem).log("Loading best solution@t", JSON_k.encode(pd.best));
                problem.loadSolution(pd.best);
            }
        });

        saveAllDataButton.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            KioBase.instance.log('BTN saveAll in contest', []);
            FileUtils.saveAll();
        });

        helpButton.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            KioBase.instance.log('BTN help in contest', []);
            if (testNonBrokenProblem())
                KioBase.instance.currentDisplay = new HelpDisplay(KioBase.instance.currentProblem, false);
        });

        statementButton.addEventListener(MouseEvent.CLICK, function(e:Event):void {
            KioBase.instance.log('BTN statement in contest', []);
            if (testNonBrokenProblem())
                KioBase.instance.currentDisplay = new HelpDisplay(KioBase.instance.currentProblem, true);
        });
    }

    private function testNonBrokenProblem():Boolean {
        return true;
        /*var id:String = KioBase.instance.currentProblem.id;
        return KioBase.instance.currentProblem.id != PhysicsProblem.ID && id != CrossedCountry.ID;*/
    }

    private function placeButton(caption:String):SimpleButton {
        var b:SimpleButton = new ShellButton(caption);
        b.x = Math.floor((GlobalMetrics.CONTEST_PANEL_WIDTH - b.width) / 2) + 2;
        b.y = __y0;
        __y0 += b.height + 4;
        addChild(b);
        return b;
    }

    private function placeText(text:String):void {
        var tf:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        tf.width = GlobalMetrics.CONTEST_PANEL_WIDTH;
        tf.htmlText = "<p align='center'>" + text + "</p>";

        tf.x = Math.floor((GlobalMetrics.CONTEST_PANEL_WIDTH - tf.width) / 2) + 2;
        tf.y = __y0;

        __y0 += tf.height + 4;
        addChild(tf);
    }

}

}