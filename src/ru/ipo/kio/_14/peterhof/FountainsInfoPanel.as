/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 17.02.13
 * Time: 21:23
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._14.peterhof {
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio.api.KioApi;

public class FountainsInfoPanel extends Sprite {

    private var textFieldsValues:Array = []; //array of text fields

//    private var animating:Boolean = false; //TODO report Boolean may be assigned to null or to []
//    private var animationStep:int = 0;
    //TODO in sending report end button moves to the end of the text and not to the end of the line

    public function FountainsInfoPanel(titleSkip:Number, titleColor:uint, labelColor:uint, valueColor:uint, title:String, labels:Array, right:int) {
        var titleFormat:TextFormat = new TextFormat(KioApi.language == 'th' ? 'KioTahoma' : 'KioEkaterina', 24, titleColor, true);
        var labelFormat:TextFormat = new TextFormat(KioApi.language == 'th' ? 'KioTahoma' : 'KioArial', 18, labelColor, false);
        var valueFormat:TextFormat = new TextFormat(KioApi.language == 'th' ? 'KioTahoma' : 'KioArial', 18, valueColor, true);

        var embeddedFonts:Boolean = true;
        var lineSkip:Number = 60;

        var titleField:TextField = new TextField();
        titleField.embedFonts = embeddedFonts;
        titleField.defaultTextFormat = titleFormat;
        titleField.autoSize = TextFieldAutoSize.LEFT;
        titleField.text = title;
        titleField.selectable = false;
        titleField.x = titleSkip;

        var y0:Number = 0;

        for each (var label:String in labels) {
            y0 += lineSkip;

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
