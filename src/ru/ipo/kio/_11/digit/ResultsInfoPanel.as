/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 16.02.11
 * Time: 22:37
 */
package ru.ipo.kio._11.digit {
import flash.display.Sprite;
import flash.text.TextField;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;

public class ResultsInfoPanel extends Sprite {

    private var _recognized:int;
    private var _elements:int;

    private var ftRecognized:TextField;
    private var ftElements:TextField;

    private var _h:int;

    private var loc:Object = KioApi.getLocalization(DigitProblem.ID);

    //constructor takes positions of text
    public function ResultsInfoPanel(caption:String, h:int, v1:int, v2:int, v3:int, v4:int) {
//        var api:KioApi = KioApi.instance(SemiramidaProblem.ID);

        /*var ftCaption:TextField = */createField(h, v1, caption);

        /*var ft1:TextField = */createField(h, v2, loc.results.recognition_info_header);

        _h = h;

        ftRecognized = createField(h, v3, "");
        ftElements = createField(h, v4, "");
    }

    private function createField(x:int, y:int, caption:String):TextField {
        var ft:TextField = TextUtils.createTextFieldWithFont("KioDigits", 12, false);
        ft.text = caption;
        ft.x = x - ft.textWidth / 2;
        ft.y = y;
        addChild(ft);
        return ft;
    }

    public function get recognized():int {
        return _recognized;
    }

    public function set recognized(value:int):void {
        _recognized = value;
        if (Globals.instance.level == 1)
            ftRecognized.text = loc.results.recognition_info_1;
        else
            ftRecognized.text = loc.results.recognition_info_2;
        ftRecognized.appendText(": " + value);
        ftRecognized.x = _h - ftRecognized.textWidth / 2;
    }

    public function get elements():int {
        return _elements;
    }

    public function set elements(value:int):void {
        _elements = value;
        ftElements.text = loc.results.elements_info + ": " + value;
        ftElements.x = _h - ftElements.textWidth / 2;
    }

}
}