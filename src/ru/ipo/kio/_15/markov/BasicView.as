/**
 *
 * @author: Vasiliy
 * @date: 31.12.12
 */
package ru.ipo.kio._15.markov {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

public class BasicView extends Sprite {

    private static const FIELD_MARGIN:int = 10;

    protected var over:Boolean=false;

    public function BasicView(updateOnOver:Boolean=false) {
        if(updateOnOver) {
            addEventListener(MouseEvent.ROLL_OVER, function (e:Event) {
                over = true;
                update();
            });
            addEventListener(MouseEvent.ROLL_OUT, function (e:Event) {
                over = false;
                update();
            });
        }
    }

    public function update():void{

    }

    protected function clear():void {
        while (numChildren > 0) {
            removeChildAt(0);
        }
        graphics.clear();
        graphics.beginFill(0xFFFFFF);
        graphics.endFill();
    }

    public function addChildTo(field:DisplayObject, x:int, y:int):void {
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

    public function createField(text:String, size:int=12, color:int = 0x000000):TextField {
        var field:TextField = new TextField();
        field.background = false;
        field.selectable = false;
        field.text = text;
        var format:TextFormat = field.getTextFormat();
        format.size = size;
        format.font="Arial";
        format.color=color;
        field.setTextFormat(format);
        field.width = field.textWidth+6;
        field.height = field.textHeight + FIELD_MARGIN;
        return field;
    }


}
}
