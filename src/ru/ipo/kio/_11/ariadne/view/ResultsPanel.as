/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 01.03.11
 * Time: 12:43
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.ariadne.view {
import flash.display.Sprite;
import flash.text.TextField;

import ru.ipo.kio._11.ariadne.AriadneProblem;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;

public class ResultsPanel extends Sprite {

    private var _width:int;
    private var _header:String;
    /*private var tfTime:TextField;
     private var tfLength:TextField;*/
    private var tfHeader:TextField;

    private var _time:Number = +Infinity;
    private var _length:Number = +Infinity;

    private var y0:int;

    private var loc:Object = KioApi.getLocalization(AriadneProblem.ID);

    public function ResultsPanel(width:int, header:String) {
        _width = width;
        _header = header;

        var loc:Object = KioApi.getLocalization(AriadneProblem.ID);

        tfHeader = TextUtils.createTextFieldWithFont('KioGreece', Workspace.FONT_HEIGHT, false, true);
        tfHeader.width = _width;
        tfHeader.text = header;
        tfHeader.y = 6;

        /*y0 = tfHeader.y + tfHeader.textHeight;

         tfTime = TextUtils.createTextFieldWithFont('KioGreece', text_height, false);
         tfLength = TextUtils.createTextFieldWithFont('KioGreece', text_height, false);
         */
        addChild(tfHeader);
        /*addChild(tfTime);
         addChild(tfLength);*/
    }

    public function set time(value:Number):void {
        _time = value;
        refresh();
    }

    public function set length(value:Number):void {
        _length = value;
        refresh();
    }

    public function format(n:Number):String {
        return Math.floor(n) + '.' + Math.floor(n * 100) % 100;
    }

    private function refresh():void {

        tfHeader.text =
                _header + '\n' +
                        loc.results.time + ' ' +//'\n' +
                        format(_time) + ' ' +
                        loc.results.time_sec + '\n' +
                        loc.results.length + ' ' +//'\n' +
                        format(_length) + ' ' +
                        loc.results.length_metr;

        tfHeader.x = (_width - tfHeader.textWidth) / 2;

        /*tfTime.text = loc.results.time + ' ' + format(_time) + ' ' + loc.results.time_sec;
         tfLength.text = loc.results.length + ' ' + format(_length) + ' '  + loc.results.length_metr;

         tfTime.y = y0 + 4;
         tfLength.y = tfTime.y + tfTime.textHeight + 4;

         tfTime.x = (_width - tfTime.textWidth) / 2;
         tfLength.x = (_width - tfLength.textWidth) / 2;*/
    }
}
}
