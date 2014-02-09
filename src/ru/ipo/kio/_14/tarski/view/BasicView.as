/**
 *
 * @author: Vasiliy
 * @date: 31.12.12
 */
package ru.ipo.kio._14.tarski.view {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.text.TextField;

public class BasicView extends Sprite {
    public function BasicView() {
    }

    public function update():void{

    }


    protected function clearAll():void {
        while (numChildren > 0) {
            removeChildAt(0);
        }
    }

    protected function addChildAndShift(field:DisplayObject, x:int):int {
        addChild(field);
        field.x = x;
        x += field.width;
        return x;
    }

    protected function createField(text:String):TextField {
        var field:TextField = new TextField();
        field.background = false;
        field.selectable = false;
        field.text = text;
        field.width = field.textWidth + 10;
        field.height = field.textHeight + 10;
        return field;
    }


}
}
