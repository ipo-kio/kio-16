/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 09.02.11
 * Time: 19:36
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.text.StyleSheet;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.utils.Dictionary;

public class TextUtils {

    /*
     [Embed(source='../../../../../resources/fonts/ds_crystal.ttf', embedAsCFF = "false", fontName="DS Crystal", mimeType="application/x-font-truetype")]
     private static var DC_CRYSTAL_FONT:Class;

     [Embed(source='../base/resources/fonts/ACADEMY.TTF', embedAsCFF = "false", fontName="Academy", mimeType="application/x-font-truetype")]
     private static var ACADEMY_FONT:Class;

     [Embed(source='../base/resources/fonts/PRESENT.TTF', embedAsCFF = "false", fontName="Presentum", mimeType="application/x-font-truetype")]
     private static var PRESENTUM_FONT:Class;

     [Embed(source='../base/resources/fonts/IRISN4.TTF', embedAsCFF = "false", fontName="Iris", mimeType="application/x-font-truetype")]
     private static var IRIS_FONT:Class;


     */

    [Embed(
            source='../base/resources/fonts/tahoma.ttf',
            embedAsCFF = "false",
            fontName="KioTahoma",
            mimeType="application/x-font-truetype",
            unicodeRange = "U+0000-U+FFFF"
            )]
    private static var TAHOMA_FONT:Class;

    [Embed(
            source='../base/resources/fonts/tahomabd.ttf',
            embedAsCFF = "false",
            fontWeight = "bold",
            fontName="KioTahoma",
            mimeType="application/x-font-truetype",
            unicodeRange = "U+0000-U+FFFF"
            )]
    private static var TAHOMA_BD_FONT:Class;

    public static const SMALL_TEXT_SIZE:int = 14;
    public static const NORMAL_TEXT_SIZE:int = 18;
    public static const LARGE_TEXT_SIZE:int = 24;
    public static const X_LARGE_TEXT_SIZE:int = 32;

    public static const FONT_MESSAGES:String = "KioTahoma";
    public static const FONT_INPUT:String = "KioTahoma";

    public static const CSS:String =
            " p , li {font-family: " + FONT_MESSAGES + "; font-size: 14; color:#000000; text-align:justify;} " +
                    ".no_justify {text-align:left;} " +
                    ".h1 { color:#000000; font-size: 16; font-weight:bold;} " +
                    ".h1c { color:#000000; font-size: 16; font-weight:bold; text-align:center;} " +
                    ".h2 { color:#000000; font-size: 14; font-weight:bold; text-align:left;} " +
                    //".footnote {font-size: 12; } " + //font-weight:bold;} " +
                    ".footnote {color:#222266;}" +
                    ".warning {color:#00000; font-weight:bold; font-size: smaller} " +
                    ".warning_anketa {color:#00000; font-size: smaller} " +
                    ".c {textAlign: center;}";

    private static function prepareTextField(text:String, x0:int, y0:int, size:int, align:String, color:uint, alpha:Number):TextField {
        var tf:TextField = new TextField;
        tf.text = text;
        tf.setTextFormat(new TextFormat(FONT_MESSAGES, size));
        tf.x = x0;
        tf.y = y0;
        tf.textColor = color;
        tf.alpha = alpha;
        tf.autoSize = align;
        tf.embedFonts = true;
        return tf;
    }

    public static function drawText(text:String, size:int, align:String, color:uint, alpha:Number):TextField {
        return prepareTextField(text, 0, 0, size, align, color, alpha);
    }

    public static function drawTextWidth(text:String, width:int, size:int, align:String, color:uint, alpha:Number):TextField {
        var tf:TextField = prepareTextField(text, 0, 0, size, align, color, alpha);
        tf.width = width;
        tf.wordWrap = true;
        tf.multiline = true;
        return tf;
    }

    /*public static function drawTextW(text:String, width:int, size:int, align:String, color:uint, alpha:Number, fontName:String):TextField {
        var tf:TextField;
        if (width < 0)
            tf = drawText(text, size, align, color, alpha);
        else
            tf = drawTextWidth(text, width, size, align, color, alpha);

        tf.setTextFormat(new TextFormat(fontName, size));
    }*/

    private static var textOutInfo:Dictionary = new Dictionary();

    public static function moveTo(container:DisplayObjectContainer, x:int, y:int, lineSkip:int, width:int = -1):void {
        textOutInfo[container] = {x : x, y : y, width : width, lineSkip:lineSkip};
    }

    public static function output(container:DisplayObjectContainer, message:DisplayObject, align:String = TextFieldAutoSize.LEFT):void {
        var info:Object = textOutInfo[container];
        var x:int = info.x;
        var y:int = info.y;
        switch (align) {
            case TextFieldAutoSize.RIGHT:
                x = info.x + info.width - message.width;
                break;
            case TextFieldAutoSize.CENTER:
                x = info.x + (info.width - message.width) / 2;
                break;
        }

        message.x = x;
        message.y = y;

        container.addChild(message);
        info.y += message.height + info.lineSkip;
    }

    public static function createCustomTextField(multiline:Boolean = true):TextField {
        var tf:TextField = new TextField();
        tf.multiline = multiline;
        tf.wordWrap = multiline;
        tf.embedFonts = true;
        tf.autoSize = TextFieldAutoSize.LEFT;
        tf.condenseWhite = true;
        tf.styleSheet = new StyleSheet();
        tf.styleSheet.parseCSS(TextUtils.CSS);
        tf.selectable = false;
        return tf;
    }

    public static function createTextFieldWithFont(fontName:String, fontSize:int, multiline:Boolean = true, centered:Boolean = false):TextField {
        var tf:TextField = new TextField();
        tf.multiline = multiline;
        tf.wordWrap = multiline;
        tf.embedFonts = true;
        tf.autoSize = TextFieldAutoSize.LEFT;
        /*tf.styleSheet = new StyleSheet();
         fontName = "Arial";
         tf.styleSheet.parseCSS("p {font-family: " + fontName + "; font-size: " + fontSize +";}");*/
        var format:TextFormat = new TextFormat(fontName, fontSize);
        if (centered)
            format.align = TextFormatAlign.CENTER;
        tf.defaultTextFormat = format;
        tf.selectable = false;
        return tf;
    }

    public static function embedFonts():void {
        //do nothing
    }

}
}
