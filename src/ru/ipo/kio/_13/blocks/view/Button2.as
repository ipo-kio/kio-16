/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 08.02.13
 * Time: 20:30
 */
package ru.ipo.kio._13.blocks.view {
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;

public class Button2 extends SimpleButton {

    private var _action:String;

//    private static const UPPER_COLOR:uint = 0x66ae59;
//    private static const DOWN_COLOR:uint = 0x4ca13d;
    private static const UPPER_COLOR:uint = 0xEEEEEE;
    private static const DOWN_COLOR:uint = 0xAAAAAA;
    private static const UPPER_COLOR_HOVER:uint = 0xEEEE00;
    private static const DOWN_COLOR_HOVER:uint = 0xAAAA00;

    private static const BORDER_COLOR:uint = 0x444444;
    private static const INNER_BORDER_COLOR:uint = 0x888888;

    private var grayer:Shape;

    public function Button2(value:*, action:String, width:int = 0, height:int = 0, textSize:int = 0) {
        //TODO report two super are not reported
        _action = action;

        if (value is String) {
            var title:String = value as String;
            up = mergeSpriteAndText(createNormalSprite(width, height), title, textSize);
            over = mergeSpriteAndText(createHoverSprite(width, height), title, textSize);
            down = mergeSpriteAndText(createPressedSprite(width, height), title, textSize, 1, 1);
        } else {
            var buttonImage:* = new value;
            if (width == 0)
                width = buttonImage.width;
            if (height == 0)
                height = buttonImage.height;
            var up:Sprite = mergeSprites(createNormalSprite(width, height), buttonImage);
            var over:Sprite = mergeSprites(createHoverSprite(width, height), new value);
            var down:Sprite = mergeSprites(createPressedSprite(width, height), new value, 1, 1);
        }

        super(up, over, down, up);

        useHandCursor = true;

        grayer = new Shape();
        grayer.graphics.beginFill(0x888888, 0.75);
        grayer.graphics.drawRect(0, 0, width + 1, height + 1);
        grayer.graphics.endFill();
        up.addChild(grayer);
        grayer.visible = false;
    }

    private static function twoColoredButton(width:int, height:int, colorUp:uint, colorDown:uint):Sprite {
        var s:Sprite = new Sprite();

        var g:Graphics = s.graphics;

        /*g.beginFill(colorUp);
        g.drawRect(0, 0, width, height / 2);
        g.endFill();
        g.beginFill(colorDown);
        g.drawRect(0, height / 2, width, height / 2);
        g.endFill();*/

        var m:Matrix = new Matrix();
        m.createGradientBox(width, height, Math.PI / 2);
        g.beginGradientFill(GradientType.LINEAR, [colorUp, colorDown], [1, 1], [0, 255], m);
        g.drawRect(0, 0, width, height);
        g.endFill();

        g.lineStyle(1, INNER_BORDER_COLOR);
        g.drawRoundRect(1, 1, width - 2, height - 2, 2);
        g.lineStyle(1, BORDER_COLOR);
        g.drawRoundRect(0, 0, width, height, 2);

        return s;
    }

    private static function createNormalSprite(width:int, height:int):DisplayObject {
        return twoColoredButton(width, height, UPPER_COLOR, DOWN_COLOR);
    }

    private static function createHoverSprite(width:int, height:int):DisplayObject {
        return twoColoredButton(width, height, UPPER_COLOR_HOVER, DOWN_COLOR_HOVER);
    }

    private static function createPressedSprite(width:int, height:int):DisplayObject {
        return createHoverSprite(width, height);
    }

    public static function mergeSprites(do1:DisplayObject, do2:DisplayObject, dx:int = 0, dy:int = 0):Sprite {
        var s:Sprite = new Sprite();
        s.addChild(do1);
        do2.x = dx;
        do2.y = dy;
        s.addChild(do2);
        return s;
    }

    public static function mergeSpriteAndText(do1:DisplayObject, text:String, textSize:int, dx:int = 0, dy:int = 0):Sprite {
        var field:TextField = new TextField();

        field.autoSize = TextFieldAutoSize.NONE;
        field.defaultTextFormat = new TextFormat('MONOSPACE', textSize, null, null, null, null, null, null, TextFormatAlign.CENTER);
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

    override public function set enabled(value:Boolean):void {
        super.enabled = value;
        grayer.visible = ! enabled;
    }
}
}
