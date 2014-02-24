/**
 *
 * @author: Vasiliy
 * @date: 31.12.12
 */
package ru.ipo.kio._14.tarski.view {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class BasicView extends Sprite {
    private static const FIELD_MARGIN:int = 10;


    public function BasicView() {
    }

    public function update():void{

    }


    protected function clearAll():void {
        while (numChildren > 0) {
            removeChildAt(0);
        }
    }

    protected function addChildTo(field:DisplayObject, x:int, y:int):void {
        addChild(field);
        field.x = x;
        field.y = y;
    }

    protected function addChildAndShift(field:DisplayObject, x:int):int {
        addChild(field);
        field.x = x;
        x += field.width;
        return x;
    }

    protected function createField(text:String, size:int=12):TextField {
        var field:TextField = new TextField();
        field.background = false;
        field.selectable = false;
        field.text = text;
        var format:TextFormat = field.getTextFormat();
        format.size = size;
        field.setTextFormat(format);
        field.width = field.textWidth + FIELD_MARGIN;
        field.height = field.textHeight + FIELD_MARGIN;

        return field;
    }


}
}
