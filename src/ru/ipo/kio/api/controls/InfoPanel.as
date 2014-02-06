/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 17.02.13
 * Time: 21:23
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.api.controls {
import flash.display.Sprite;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class InfoPanel extends Sprite {

    private var textFieldsValues:Array = []; //array of text fields

//    private var animating:Boolean = false; //TODO report Boolean may be assigned to null or to []
//    private var animationStep:int = 0;
    //TODO in sending report end button moves to the end of the text and not to the end of the line

    public function InfoPanel(fontName:String, embeddedFonts:Boolean, fontSize:int, titleColor:uint, labelColor:uint, valueColor:uint, lineSkip:Number, title:String, labels:Array, right:int) {
        var titleFormat:TextFormat = new TextFormat(fontName, fontSize, titleColor, true);
        var labelFormat:TextFormat = new TextFormat(fontName, fontSize, labelColor, false);
        var valueFormat:TextFormat = new TextFormat(fontName, fontSize, valueColor, true);

        var titleField:TextField = new TextField();
        titleField.embedFonts = embeddedFonts;
        titleField.defaultTextFormat = titleFormat;
        titleField.autoSize = TextFieldAutoSize.LEFT;
        titleField.text = title;
        titleField.selectable = false;

        var y0:Number = 0;

        for each (var label:String in labels) {
            y0 += fontSize * lineSkip;

            var labelField:TextField = new TextField();
            labelField.embedFonts = embeddedFonts;
            labelField.defaultTextFormat = labelFormat;
            labelField.autoSize = TextFieldAutoSize.LEFT;
            labelField.text = label;
            labelField.selectable = false;

            var valueField:TextField = new TextField();
            valueField.embedFonts = embeddedFonts;
            valueField.defaultTextFormat = valueFormat;
            valueField.autoSize = TextFieldAutoSize.RIGHT;
            valueField.selectable = false;

            valueField.x = right;

            labelField.y = y0;
            valueField.y = y0;

            textFieldsValues.push(valueField);

            addChild(labelField);
            addChild(valueField);
        }

        addChild(titleField);
    }

    public function setValue(ind:int, value:*):void {
        textFieldsValues[ind].text = String(value);
    }

    public function animateChange():void {
//        animating = true;
        //TODO implement
    }

}
}
