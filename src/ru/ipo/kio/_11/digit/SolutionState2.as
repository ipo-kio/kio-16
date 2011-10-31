/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 22.02.11
 * Time: 20:45
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.digit {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;

public class SolutionState2 extends Sprite implements SolutionState {

    private var _data:Array = new Array(10); //broken+1 -> rd -> bool
    private var _recognized:int;

    private var _info:Sprite;

    private var popup:Sprite;
    private var popup_tf:TextField;

    [Embed(source="resources/Table_01.png")]
    private static const CORRECT_EVEN:Class;
    private static const CORRECT_EVEN_BMP:BitmapData = new CORRECT_EVEN().bitmapData;

    [Embed(source="resources/Table_02.png")]
    private static const CORRECT_ODD:Class;
    private static const CORRECT_ODD_BMP:BitmapData = new CORRECT_ODD().bitmapData;

    [Embed(source="resources/Table_03.png")]
    private static const WRONG_EVEN:Class;
    private static const WRONG_EVEN_BMP:BitmapData = new WRONG_EVEN().bitmapData;

    [Embed(source="resources/Table_04.png")]
    private static const WRONG_ODD:Class;
    private static const WRONG_ODD_BMP:BitmapData = new WRONG_ODD().bitmapData;

    private static const INFO_BRICK_WIDTH:int = CORRECT_EVEN_BMP.width;
    private static const INFO_BRICK_HEIGHT:int = CORRECT_EVEN_BMP.height;

    private var loc:Object = KioApi.getLocalization(DigitProblem.ID);

    public function SolutionState2() {
        for (var i:int = 0; i < 10; i++)
            _data[i] = new Array(10);

        for (i = 0; i < 10; i++) {
            var tf:TextField = TextUtils.createTextFieldWithFont("KioDigits", 12, false);
            tf.text = '' + i;
            tf.x = 209 + 18 * i - tf.textWidth / 2;
            tf.y = 413;

            //_text_labels[i] = tf;
            addChild(tf);
        }

        _info = new Sprite;
        _info.x = 200;
        _info.y = 426;
        addChild(_info);

        _info.addEventListener(MouseEvent.MOUSE_MOVE, mouseRollOver);
        _info.addEventListener(MouseEvent.ROLL_OUT, mouseRollOut);
        _info.addEventListener(MouseEvent.CLICK, mouseClick);

        popup = new Sprite;
        popup_tf = TextUtils.createTextFieldWithFont("KioDigits", 12, true);
        popup_tf.width = 240;
        popup.addChild(popup_tf);

        _info.addChild(popup);
    }

    private function getMouseInfoPos():* {
        var i:int = Math.floor(_info.mouseY / INFO_BRICK_HEIGHT);
        if (i < 0 || i > 9)
            return null;
        var j:int = Math.floor(_info.mouseX / INFO_BRICK_WIDTH);
        if (j < 0 || j > 9)
            return null;
        return [i, j];
    }

    private function mouseRollOver(event:Event):void {
        var r:* = getMouseInfoPos();
        if (!r)
            return;
        var i:int = r[0];
        var j:int = r[1];

        var hint:String;
        if (i == 0)
            hint = _data[i][j] >= 0 ? loc.results.hint_wrong_0 : loc.results.hint_correct_0;
        else
            hint = _data[i][j] >= 0 ? loc.results.hint_wrong : loc.results.hint_correct;

        hint = hint.replace(/\{line\}/, loc.results.lines[i]).replace(/\{digit\}/, j);

        showPopup(hint, _info.mouseX, _info.mouseY);
    }

    private function mouseRollOut(event:Event):void {
        hidePopup();
    }

    private function mouseClick(event:Event):void {
        var r:* = getMouseInfoPos();
        if (!r)
            return;
        var i:int = r[0];
        var j:int = r[1];
        if (_data[i][j] >= 0)
            Globals.instance.workspace.digit.val = _data[i][j];
        else
            Globals.instance.workspace.digit.val = r[1];
        Globals.instance.workspace.digit.broken_index = r[0] - 1;
    }

    public function updateData():void {
        var f:Field = Globals.instance.workspace.field;

        if (!f)
            return;

        _recognized = 0;
        for (var br:int = -1; br < 9; br++) {
            Globals.instance.forced_broken = br;
            for (var rd:int = 0; rd < 10; rd++) {
                _data[br + 1][rd] = -1;
                _recognized ++;
                for (var td:int = 0; td < 10; td++) {
                    Globals.instance.forced_digit = td;
                    f.resetAllGates(); //TODO optimize evaluations

                    //true must be only when td == rd
                    var r1:Boolean = f.exits[rd].value == 1;
                    var r2:Boolean = td == rd;
                    if (r1 != r2) {
                        _data[br + 1][rd] = td;
                        _recognized --;
                        break;
                    }
                }
            }
        }

        Globals.instance.forced_digit = -1;
        Globals.instance.forced_broken = -2;
    }

    public function updateView():void {
        _info.graphics.clear();
        for (var i:int = 0; i < 10; i++) {
            for (var j:int = 0; j < 10; j++) {
                var bmp:BitmapData;
                if ((i + j) % 2 == 0) {
                    bmp = _data[i][j] < 0 ? CORRECT_EVEN_BMP : WRONG_EVEN_BMP;
                } else {
                    bmp = _data[i][j] < 0 ? CORRECT_ODD_BMP : WRONG_ODD_BMP;
                }
                _info.graphics.beginBitmapFill(bmp);
                _info.graphics.drawRect(j * INFO_BRICK_WIDTH, i * INFO_BRICK_HEIGHT, INFO_BRICK_WIDTH, INFO_BRICK_HEIGHT);
                _info.graphics.endFill();
            }
        }
    }

    private function showPopup(text:String, x0:int, y0:int):void {
        popup_tf.text = text;
        popup.x = x0 + 6;
        popup.y = y0 - 6 - popup_tf.textHeight;
        popup.graphics.clear();
        popup.graphics.beginFill(0xFFFF00);
        popup.graphics.drawRect(-2, -2, popup_tf.textWidth + 4, popup_tf.textHeight + 4);
        popup.graphics.endFill();

        popup.visible = true;
    }

    private function hidePopup():void {
        popup.visible = false;
    }

    public function get recognized():int {
        return _recognized;
    }
}
}
