/**
 * Created by user on 22.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.MouseEvent;

public class LineView extends Sprite {

    private var x1:Number;
    private var y1:Number;
    private var x2:Number;
    private var y2:Number;

    private var _isSelected:Boolean;
    private var _line:Line;

    public function LineView(x1:Number, y1:Number) {
        this.x1 = x1;
        this.y1 = y1;
    }

    public function get line():Line {
        return _line;
    }

    public function fixNewLine(line:Line):void {
        _line = line;
        this.x1 = line.s1.x;
        this.y1 = line.s1.y;
        this.x2 = line.s2.x;
        this.y2 = line.s2.y;
        drawDefaultLine();

        addEventListener(MouseEvent.ROLL_OVER, rollOverForLine);
        addEventListener(MouseEvent.ROLL_OUT, rollOutForLine);

        //make big height for line to interact with mouse
        addHitArea();
    }

    private function addHitArea():void {
        var hit:Sprite = new Sprite();
        hit.graphics.lineStyle(8, 0, 0);
        hit.graphics.moveTo(x1, y1);
        hit.graphics.lineTo(x2, y2);

        addChild(hit);
        hit.visible = false;

        this.hitArea = hit;
    }

    private function rollOverForLine(e:MouseEvent):void {
        isSelected = true;
    }

    private function rollOutForLine(e:MouseEvent):void {
        isSelected = false;
    }

    public function get isSelected():Boolean {
        return _isSelected;
    }

    public function set isSelected(value:Boolean):void {
        _isSelected = value;
        if (_isSelected)
            drawSelectedLine();
        else
            drawDefaultLine();
    }

//    public function deleteLineFromField():void {
//        if (_isSelected)
//            graphics.clear();
//    }
//
//    public function deleteLine():void {
//        graphics.clear();
//    }

    public function drawNewLine(x2:Number, y2:Number):void {
        graphics.clear();
        graphics.lineStyle(2, 0xffffff, 0.7);
        graphics.moveTo(x1, y1);
        graphics.lineTo(x2, y2);
    }

    private function drawDefaultLine():void {
        graphics.clear();
        graphics.lineStyle(2, 0xffffff, 0.7);
        graphics.moveTo(x1, y1);
        graphics.lineTo(x2, y2);
    }

    private function drawSelectedLine():void {
        graphics.clear();
        graphics.lineStyle(3, 0xffffff, 1);
        graphics.moveTo(x1, y1);
        graphics.lineTo(x2, y2);
    }

    public function dispose():void {
        removeEventListener(MouseEvent.ROLL_OVER, rollOverForLine);
        removeEventListener(MouseEvent.ROLL_OUT, rollOutForLine);
    }
}
}
