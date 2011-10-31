/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 12.02.11
 * Time: 10:40
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api.controls {
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import ru.ipo.kio.api.TextUtils;

public class InputTextField extends Sprite {

    private static const ERROR_BORDER_COLOR:uint = 0xda5594;
    private static const CORRECT_BORDER_COLOR:uint = 0x33CC99;

    private static const H_PADDING:int = 3;
    private static const V_PADDING:int = 3;

    private var tf:TextField;
    private var errorTf:TextField;
    private var errorLabel:String;
    private var border:Sprite;

    private var fontSize:int;
    private var effectiveFontSize:int;
    private var fieldWidth:int;

    private var _filter:Function = null;
    private var _id:String;

    private var lines:int;

    public function InputTextField(id:String, width:int, fontSize:int, errorToTheRight:Boolean = true, lines:int = 1) {
        this.fontSize = fontSize;
        this.effectiveFontSize = fontSize + 3;
        this.fieldWidth = width;
        this.lines = lines;
        this._id = id;

        tf = new TextField;
        /*var enumerateFonts:Array = Font.enumerateFonts();
        enumerateFonts.sortOn("fontName");
        for each (var e:Font in enumerateFonts) {
            trace(e.fontName);
        }*/

        tf.embedFonts = true;
        tf.defaultTextFormat = new TextFormat(TextUtils.FONT_INPUT, fontSize);
        tf.type = TextFieldType.INPUT;

        if (lines > 1) {
            tf.wordWrap = true;
            tf.multiline = true;
        }

        /*var ba:BitmapAsset = new Resources.INPUT_BG;
        var b:BitmapData = ba.bitmapData;
        //b.copyPixels(b, new Rectangle(0, 0, Math.min(width, b.width), fontSize + 3 + 2 * V_PADDING), new Point(0, 0));

        graphics.beginBitmapFill(b);*/
        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(0, 0, width, lines * effectiveFontSize + 2 * V_PADDING);
        graphics.endFill();

        tf.height = getHeight();
        tf.x = H_PADDING;
        tf.y = 0;
        tf.width = width - 10;

        addChild(tf);

        border = new Sprite;
        border.x = 0;
        border.y = 0;
        addChild(border);

        tf.addEventListener(Event.CHANGE, function(event:Event):void {
            dispatchEvent(event);
            updateErrorInfo();
        });

        errorTf = TextUtils.createCustomTextField();

        if (errorToTheRight) {
            errorTf.x = fieldWidth + 10;
            errorTf.y = tf.y;
            errorTf.multiline = false;
            errorTf.wordWrap = false;
        } else {
            errorTf.x = 0;
            errorTf.y = effectiveFontSize * lines + 2 * V_PADDING;
            errorTf.width = width;
        }

        addChild(errorTf);

        updateErrorInfo();
    }

    private function getHeight():int {
        return effectiveFontSize * lines + 10;
    }

    public function get filter():Function {
        return _filter;
    }

    /**
     * Sets filter, function String -> String, tests text and returns error, null if no error
     * @param value text to test
     */
    public function set filter(value:Function):void {
        _filter = value;
        updateErrorInfo();
    }

    private function updateErrorInfo(event:Event = null):void {
        if (filter == null)
            errorLabel = null;
        else
            errorLabel = filter(tf.text);

        if (errorLabel == null)
            errorTf.text = "";
        else
            errorTf.htmlText = "<p class='warning_anketa'>" + errorLabel + "</p>";

        updateBorder();
    }

    private function updateBorder():void {
        border.graphics.clear();
        border.graphics.lineStyle(2, errorLabel ? ERROR_BORDER_COLOR : CORRECT_BORDER_COLOR);
        border.graphics.drawRect(0, 0, fieldWidth, effectiveFontSize * lines + 2 * V_PADDING);
    }

    public function get text():String {
        return tf.text;
    }

    public function set text(value:String):void {
        if (!value)
            value = '';
        tf.text = value;

        updateErrorInfo();
    }

    public function get hasError():Boolean {
        //Yoda condition in action
        return null == errorLabel;
    }

    public function set restrict(value:String):void {
        tf.restrict = value;
    }

    public function get restrict():String {
        return tf.restrict;
    }

    public function get id():String {
        return _id;
    }

    public function get error():String {
        return _filter != null ? _filter(tf.text) : null; // != null is needed to suppress warnings
    }
}
}
