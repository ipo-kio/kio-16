/**
 * Created by user on 22.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.MouseEvent;

public class LineView extends Sprite {

    private static const LINE_COLOR:uint = 0xffff66;
    private static const ERROR_LINE_COLOR:int = 0xff0000;

    private var x1:Number;
    private var y1:Number;
    private var x2:Number;
    private var y2:Number;

    private var _isSelected:Boolean = false;
    private var _error:Boolean = false;

    private var _line:Line;

    private var _workspace:StarsWorkspace;

    public function LineView(x1:Number, y1:Number, workspace:StarsWorkspace) {
        _workspace = workspace;
        this.x1 = x1;
        this.y1 = y1;
    }

    public function get line():Line {
        return _line;
    }

    public function get workspace():StarsWorkspace {
        return _workspace;
    }

    public function fixNewLine(line:Line):void {
        _line = line;
        this.x1 = line.s1.x;
        this.y1 = line.s1.y;
        this.x2 = line.s2.x;
        this.y2 = line.s2.y;
        redraw();

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
        workspace.panel.text = "Длина выбранной линии: " + text + " св. л.";
        workspace.skyView.findAndRedrawGraph(line.s1.index);
    }

    private function rollOutForLine(e:MouseEvent):void {
        isSelected = false;
        workspace.panel.text = "";
        workspace.skyView.redrawGraphs();
    }

    public function get isSelected():Boolean {
        return _isSelected;
    }

    public function set isSelected(value:Boolean):void {
        _isSelected = value;

        redraw();
    }

    public function get error():Boolean {
        return _error;
    }

    public function set error(value:Boolean):void {
        _error = value;

        redraw();
    }

    private function redraw():void {
        if (_error) {
            if (_isSelected)
                drawSelectedErrorLine();
            else
                drawErrorLine();
        } else {
            if (_isSelected)
                drawSelectedLine();
            else
                drawDefaultLine();
        }
    }

    private function drawErrorLine():void {
        graphics.clear();
        graphics.lineStyle(3, ERROR_LINE_COLOR, 0.45);
        graphics.moveTo(x1, y1);
        graphics.lineTo(x2, y2);
    }

    private function drawSelectedErrorLine():void {
        graphics.clear();
        graphics.lineStyle(4, ERROR_LINE_COLOR, 1);
        graphics.moveTo(x1, y1);
        graphics.lineTo(x2, y2);
    }

    public function drawNewLine(x2:Number, y2:Number):void {
        graphics.clear();
        graphics.lineStyle(2, LINE_COLOR, 1);
        graphics.moveTo(x1, y1);
        graphics.lineTo(x2, y2);
    }

    private function drawDefaultLine():void {
        graphics.clear();
        graphics.lineStyle(3, LINE_COLOR, 0.45);
        graphics.moveTo(x1, y1);
        graphics.lineTo(x2, y2);
    }

    private function drawSelectedLine():void {
        graphics.clear();
        graphics.lineStyle(3, LINE_COLOR, 1);
        graphics.moveTo(x1, y1);
        graphics.lineTo(x2, y2);
    }

    public function dispose():void {
        removeEventListener(MouseEvent.ROLL_OVER, rollOverForLine);
        removeEventListener(MouseEvent.ROLL_OUT, rollOutForLine);
    }

    public function computeDistance(localX:Number, localY:Number):String {
        var dx:Number = x1 - localX;
        var dy:Number = y1 - localY;
        return "" + Math.sqrt(dx * dx + dy * dy).toFixed(1);
    }

    public function get text():String {
        return "" + _line.distance.toFixed(1);
    }
}
}
