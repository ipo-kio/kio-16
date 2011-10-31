/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 22.02.11
 * Time: 20:45
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.digit {
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;

public class SolutionState1 extends Sprite implements SolutionState {

    private var _data:Array = new Array(10); //digit -> right or wrong
    private var _recognized:int;

    private var state_text_fields:Array;
    private var cur_state_marker:Shape = new Shape;

    private var loc:Object = KioApi.getLocalization(DigitProblem.ID);

    private static const CORRECT_COLOR:uint = 0x083f08;
    private static const WRONG_COLOR:uint = 0x9b0000;

    public function SolutionState1() {
        state_text_fields = new Array(10);
        for (var d:int = 0; d < 10; d++) {
            var tf:TextField = TextUtils.createTextFieldWithFont("KioDigits", 12);
            var i:int = 3;
            var j:int = 1;
            if (d != 0) {
                i = (d - 1) / 3;
                j = (d - 1) % 3;
            }

            tf.x = 194 + j * 68;
            tf.y = 424 + i * 15;

            state_text_fields[d] = tf;

            addChild(tf);
        }

        addChild(cur_state_marker);
    }

    public function updateData():void {
        var f:Field = Globals.instance.workspace.field;

        if (!f)
            return;

        _recognized = 0;

        //rd - real digit, td - test digit
        for (var rd:int = 0; rd < 10; rd++) {
            f.resetAllGates();
            Globals.instance.forced_digit = rd;
            _data[rd] = true;
            _recognized ++;
            for (var td:int = 0; td < 10; td++) {
                //true must be only when td == rd
                var r1:Boolean = f.exits[td].value == 1;
                var r2:Boolean = td == rd;
                if (r1 != r2) {
                    _data[rd] = false;
                    _recognized --;
                    break;
                }
            }
        }

        Globals.instance.forced_digit = -1;
    }

    //must be called only right after updateData if needed
    public function updateView():void {
        for (var d:int = 0; d < 10; d++) {
            state_text_fields[d].text = d + " : " + (_data[d] ? loc.results.correct : loc.results.wrong);
            state_text_fields[d].textColor = _data[d] ? CORRECT_COLOR : WRONG_COLOR;
        }

        d = Globals.instance.workspace.digit.val;

        cur_state_marker.graphics.clear();
        var tf:TextField = state_text_fields[d];
        cur_state_marker.x = tf.x;
        cur_state_marker.y = tf.y;

        cur_state_marker.graphics.lineStyle(2, _data[d] ? CORRECT_COLOR : WRONG_COLOR);
        cur_state_marker.graphics.drawRect(-2, -2, tf.textWidth + 8, tf.textHeight + 6);

    }

    public function get recognized():int {
        return _recognized;
    }
}
}
