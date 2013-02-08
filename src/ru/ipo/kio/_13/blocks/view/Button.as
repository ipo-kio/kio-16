/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 08.02.13
 * Time: 20:30
 */
package ru.ipo.kio._13.blocks.view {
import flash.display.DisplayObject;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Button extends SimpleButton {

    [Embed(source="../resources/empty.png")]
    public static const EMPTY_CLS:Class;

    [Embed(source="../resources/highlight.png")]
    public static const HIGHLIGHT_CLS:Class;

    [Embed(source="../resources/pressed.png")]
    public static const PRESSED_CLS:Class;

    private var _action:String;
    private static const TEXT_SIZE:int = 20;

    public function Button(value:*, action:String) {
        //TODO report two super are not reported
        _action = action;

        if (value is String) {
            up = doTextSprite(new EMPTY_CLS, value as String);
            over = doTextSprite(new HIGHLIGHT_CLS, value as String);
            down = doTextSprite(new PRESSED_CLS, value as String, 1, 1);
        } else {
            var up:Sprite = doSprite(new EMPTY_CLS, new value);
            var over:Sprite = doSprite(new HIGHLIGHT_CLS, new value);
            var down:Sprite = doSprite(new PRESSED_CLS, new value, 1, 1);
        }

        super(up, over, down, up);

        useHandCursor = true;
    }

    public static function doSprite(do1:DisplayObject, do2:DisplayObject, dx:int = 0, dy:int = 0):Sprite {
        var s:Sprite = new Sprite();
        s.addChild(do1);
        do2.x = dx;
        do2.y = dy;
        s.addChild(do2);
        return s;
    }

    public static function doTextSprite(do1:DisplayObject, text:String, dx:int = 0, dy:int = 0):Sprite {
        var field:TextField = new TextField();

        field.autoSize = TextFieldAutoSize.NONE;
        field.defaultTextFormat = new TextFormat('MONOSPACE', TEXT_SIZE, null, null, null, null, null, null, TextFormatAlign.CENTER);
        field.selectable = false;
        field.text = text;
        field.width = do1.width;
        field.height = field.textHeight;
        field.x = dx;
        field.y = (do1.height - field.textHeight - 2) / 2 + dy;

        var s:Sprite = new Sprite();
        s.addChild(do1);
        s.addChild(field);
        return s;
    }

    public function get action():String {
        return _action;
    }
}
}
