/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 24.02.11
 * Time: 17:37
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.base.displays {
import fl.controls.UIScrollBar;

import flash.display.DisplayObject;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.base.GlobalMetrics;
import ru.ipo.kio.base.KioBase;

public class HelpDisplay extends Sprite {
    //problem = null means show overall help
    public function HelpDisplay(problem:KioProblem, is_statement:Boolean) {

        DisplayUtils.placeBackground(this);

        var loc:Object = problem ? KioApi.getLocalization(problem.id) : null;
        var loc_sh:Object = KioApi.getLocalization(KioBase.BASE_API_ID);
        var title:String;
        if (problem)
            title = is_statement ? loc_sh.contest_panel.buttons.statement : loc_sh.contest_panel.buttons.help;
        else
            title = loc_sh.contest_panel.help_header;

        var text:String;
        if (problem)
            text = is_statement ?
                    String(DisplayUtils.getKeyByLevel(loc, 'statement', problem.level)) :
                    String(DisplayUtils.getKeyByLevel(loc, 'help', problem.level));
        else
            text = loc_sh.help.all_problems;

        var header:TextField = TextUtils.createCustomTextField();
        header.htmlText = '<p class="h1">' + title + '</p>';
        header.width = GlobalMetrics.DISPLAYS_TEXT_WIDTH;
        header.x = (GlobalMetrics.STAGE_WIDTH - header.textWidth) / 2;
        header.y = GlobalMetrics.DISPLAYS_TEXT_TOP;
        addChild(header);

        var main_text_start:Number = header.y + header.textHeight + 10;

        var imgCl:Class = null;
        if (problem) {
            if (is_statement)
                imgCl = problem.icon_statement;
            else
                imgCl = problem.icon_help;
        }
        var img:DisplayObject = null;
        if (imgCl != null) {
            img = new imgCl;
            img.x = GlobalMetrics.STAGE_WIDTH - GlobalMetrics.H_PADDING - img.width;
            img.y = main_text_start;
            addChild(img);
        }

        var img_x:int = img ? img.x : GlobalMetrics.STAGE_WIDTH - GlobalMetrics.H_PADDING - 200;

        var text_width:int = Math.min(2 * GlobalMetrics.DISPLAYS_TEXT_WIDTH, img_x - 2 * GlobalMetrics.H_PADDING);

        var tf:TextField = TextUtils.createCustomTextField();
        tf.text = text;
        tf.width = text_width;
        tf.x = GlobalMetrics.H_PADDING;
        tf.y = main_text_start;
        tf.background = true;
        tf.backgroundColor = 0xabebeb;
//        tf.border = true;
//        tf.borderColor = 0x888888;
        tf.autoSize = TextFieldAutoSize.NONE;
        tf.selectable = true;

        var textMaxHeight:int = GlobalMetrics.STAGE_HEIGHT - main_text_start - 16;
        var needScroll:Boolean = textMaxHeight < tf.textHeight;
        tf.height = Math.min(tf.textHeight, textMaxHeight);

        if (needScroll) {
            tf.width -= 15; //it seems this is the real width of uiScroll
            var _scroll:UIScrollBar = new UIScrollBar();
            _scroll.height = textMaxHeight;
            _scroll.scrollTarget = tf;
            _scroll.direction = "vertical";
            _scroll.move(tf.x + tf.width + 4, tf.y);
            addChild(_scroll);
        }

        addChild(tf);

        var continueButton:SimpleButton = DisplayUtils.placeContinueButton(this);

        continueButton.addEventListener(MouseEvent.CLICK, function (event:Event):void {
            if (problem)
                KioBase.instance.currentProblem = problem;
            else
                KioBase.instance.currentDisplay = new ProblemsDisplay;
        });

    }

}
}
