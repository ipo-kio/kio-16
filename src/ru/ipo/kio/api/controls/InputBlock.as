/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 12.02.11
 * Time: 16:12
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api.controls {
import flash.display.Sprite;
import flash.text.TextField;

import ru.ipo.kio.api.TextUtils;

public class InputBlock extends Sprite {

    private var _inputs:Array;

    public function InputBlock(caption:String, labels:Array, filters:Array, ids:Array, captionWidth:int, labelWidth:int, inputWidth:int, inputLinesHeight:Array = null) {
        var captionTF:TextField = TextUtils.createCustomTextField();
        captionTF.width = captionWidth;
        addChild(captionTF);
        captionTF.htmlText = "<p class='h2'>" + caption + "</p>";

        _inputs = [];

        //var y0:int = captionTF.textHeight + 4;
        var y0:int = 0;

        for (var i:int = 0; i < labels.length; i++) {
            var lines:int = 1;
            if (inputLinesHeight)
                lines = inputLinesHeight[i];

            var inp:InputTextField = new InputTextField(ids[i], inputWidth, TextUtils.NORMAL_TEXT_SIZE, true, lines);

            var label:TextField = TextUtils.createCustomTextField();
            /*label.wordWrap = false;
            label.multiline = false;*/
            label.width = labelWidth;
            label.htmlText = "<p class='no_justify'>" + labels[i] + "</p>";

            _inputs.push(inp);

            label.x = captionWidth;
            label.y = y0;

            inp.x = captionWidth + labelWidth + 10;
            inp.y = y0;

            inp.filter = filters[i];

            addChild(inp);
            addChild(label);

            y0 += inp.height + 2;
        }
    }

    public function restrict(ind:int, value:String):void {
        _inputs[ind].restrict = value;
    }

    public function get inputs():Array {
        return _inputs;
    }
}
}
