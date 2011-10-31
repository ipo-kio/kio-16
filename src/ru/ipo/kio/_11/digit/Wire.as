/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 21.02.11
 * Time: 0:49
 */
package ru.ipo.kio._11.digit {
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class Wire {

    public static const NO_CONNECTION:int = -1;
    public static const ZERO:int = 0;
    public static const ONE:int = 1;

    private var _mouse_over:Boolean;
    private var _selected:Boolean;
    private var _type:int = NO_CONNECTION;
    private var _start:Point = new Point(0, 0);
    private var _finish:Point = new Point(0, 0);

    private var _hit_area:Sprite;
    private var _body:Sprite;
    private var _selectable:Boolean = true;

    private var _connector:Connector;

    public function Wire() {
        _hit_area = new Sprite;
        _body = new Sprite;

        _hit_area.mouseEnabled = false;
        _hit_area.visible = false;

        _body.hitArea = _hit_area;

        _body.addEventListener(MouseEvent.ROLL_OVER, mouseRollOver);
        _body.addEventListener(MouseEvent.ROLL_OUT, mouseRollOut);
        _body.addEventListener(MouseEvent.CLICK, mouseClick);

        redraw();
    }

    public function get mouse_over():Boolean {
        return _mouse_over;
    }

    public function set mouse_over(value:Boolean):void {
        if (_mouse_over == value)
            return;
        _mouse_over = value;
        redraw();
    }

    public function get selected():Boolean {
        return _selected;
    }

    public function set selected(value:Boolean):void {
        if (_selected == value)
            return;
        _selected = value;
        redraw();
    }

    public function get type():int {
        return _type;
    }

    public function set type(value:int):void {
        if (_type == value)
            return;
        _type = value;
        redraw();
    }

    public function get start():Point {
        return _start;
    }

    public function set start(value:Point):void {
        if (_start == value)
            return;
        _start = value;
        redraw();
    }

    public function get finish():Point {
        return _finish;
    }

    public function set finish(value:Point):void {
        if (_finish == value)
            return;
        _finish = value;
        redraw();
    }

    public function redraw():void {
        /*
         не выделенные - 2п
         выделенные - 3п

         нет сигнала - чёрный - #000000
         1           - жёлтый - #fac134
         0           - белый  - #111111

         Подсветка - полупрозрачная подложка под проводом.

         подсветка не выделенного провода - 6п
         подсветка выделенного провода    - 9п

         цвет подсветки чёрного провода #383838 (50% прозрачности)
         жёлтого провода #efce57 (50% прозрачности)
         белого провода  #dedede (50% прозрачности)

         */

        var cl:uint;
        var cl_hl:uint;
        switch (_type) {
            case NO_CONNECTION:
                cl = 0x000000;
                cl_hl = 0x383838;
                break;
            case ONE:
                cl = 0xfac134;
                cl_hl = 0xefce57;
                break;
            case ZERO:
                cl = 0xeeeeee;
                cl_hl = 0xdedede;
                break;
        }
        _body.graphics.clear();
        _body.graphics.lineStyle(_selected ? 3 : 2, cl);
        _body.graphics.moveTo(_start.x, _start.y);
        _body.graphics.lineTo(_finish.x, _finish.y);

        _hit_area.graphics.clear();
        _hit_area.graphics.lineStyle(_selected ? 9 : 6, cl_hl, 0.5);
        _hit_area.graphics.moveTo(_start.x, _start.y);
        _hit_area.graphics.lineTo(_finish.x, _finish.y);

        _hit_area.visible = mouse_over;
    }

    public function addTo(stage:DisplayObjectContainer):void {
        stage.addChild(_body);
        stage.addChild(_hit_area);
    }

    private function mouseRollOver(event:Event):void {
        if (!_selectable)
            return;
        if (!_selected)
            mouse_over = true;
    }

    private function mouseRollOut(event:Event):void {
        if (!_selectable)
            return;
        mouse_over = false;
    }

    private function mouseClick(event:Event):void {
        if (!_selectable)
            return;
        Globals.instance.selected_wire = this;
    }

    public function get connector():Connector {
        return _connector;
    }

    //may be set only by connector in its constructor, don't use it in other ways
    public function set connector(value:Connector):void {
        _connector = value;
    }

    public function removeFromDisplay():void {
        _body.parent.removeChild(_body);
        _hit_area.parent.removeChild(_hit_area);
    }

    public function get selectable():Boolean {
        return _selectable;
    }

    public function set selectable(value:Boolean):void {
        _selectable = value;
    }
}
}
