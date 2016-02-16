package ru.ipo.kio._16.rockgarden.view {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio._16.rockgarden.model.Circle;
import ru.ipo.kio._16.rockgarden.model.RockPalette;

public class CircleView extends Sprite {

    public static const PERIMETER_WIDTH:int = 2;

    private var _g:GardenView;
    private var _c:Circle;

    private var _p:Point;

    private var circle_layer:Sprite = new Sprite();
    private var perimeter_layer:Sprite = new Sprite();

    private var over_perimeter:Boolean = false;
    private var over_circle:Boolean = false;

    private var changing_r:Boolean = false;
    private var moving_xy:Boolean = false;
    private var moving_xy_start_position:Point = null;
    private var moving_xy_start_center:Point = null;

    private var _tix:TextField = new TextField();

    public function CircleView(g:GardenView, c:Circle) {
        _g = g;
        _c = c;

        _p = _g.natural2disp(c.center);

        addChild(circle_layer);
        addChild(perimeter_layer);

        redraw();

        circle_layer.addEventListener(MouseEvent.ROLL_OVER, circle_layer_rollOverHandler);
        circle_layer.addEventListener(MouseEvent.ROLL_OUT, circle_layer_rollOutHandler);
        circle_layer.addEventListener(MouseEvent.MOUSE_DOWN, circle_layer_mouseDownHandler);

        perimeter_layer.addEventListener(MouseEvent.ROLL_OVER, perimeter_layer_rollOverHandler);
        perimeter_layer.addEventListener(MouseEvent.ROLL_OUT, perimeter_layer_rollOutHandler);
        perimeter_layer.addEventListener(MouseEvent.MOUSE_DOWN, perimeter_layer_mouseDownHandler);

        addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

        initText();
    }

    private function initText():void {
        const fontSize:int = 14;
        addChild(_tix);
        _tix.defaultTextFormat = new TextFormat('KioArial', fontSize, RockPalette.textColor(_c.index), true);
        _tix.autoSize = TextFieldAutoSize.CENTER;
        _tix.text = "" + _c.index;
        _tix.x = _p.x - _tix.width / 2;
        _tix.y = _p.y - _tix.height / 2;
        _tix.selectable = false;
        _tix.mouseEnabled = false;
        _tix.embedFonts = true;
    }

    private function redraw_circle():void {
        moveTo();
        circle_layer.graphics.clear();

        circle_layer.alpha = over_circle || moving_xy ? 0.8 : 1;
        if (!_c.enabled) circle_layer.alpha = 0.3;

//        var innerColor:uint = _c.enabled ? 0x00FF66 : 0xFF6600;
//        var innerAlpha:Number = _c.enabled ? (over_circle || moving_xy ? 0.8 : 0.6) : (over_circle || moving_xy ? 0.4 : 0.2);
//        circle_layer.graphics.beginFill(innerColor, innerAlpha);
        RockPalette.beginFill(circle_layer.graphics, _c.index);
        circle_layer.graphics.drawCircle(_p.x, _p.y, c.r * _g.mul - PERIMETER_WIDTH / 2);
        circle_layer.graphics.endFill();

        if (!_c.enabled) {
            circle_layer.graphics.beginFill(0xFF0000, 0.5);
            circle_layer.graphics.drawCircle(_p.x, _p.y, c.r * _g.mul - PERIMETER_WIDTH / 2);
            circle_layer.graphics.endFill();
        }

//        circle_layer.graphics.lineStyle(1, 0xAAAAAA);
//        circle_layer.graphics.moveTo(_p.x - 4, _p.y - 4);
//        circle_layer.graphics.lineTo(_p.x + 4, _p.y + 4);
//        circle_layer.graphics.moveTo(_p.x - 4, _p.y + 4);
//        circle_layer.graphics.lineTo(_p.x + 4, _p.y - 4);
    }

    private function redraw_perimeter():void {
        moveTo();
        perimeter_layer.graphics.clear();

        perimeter_layer.graphics.lineStyle(3 * PERIMETER_WIDTH, 0xFFFFFF, 0.01);
        perimeter_layer.graphics.drawCircle(_p.x, _p.y, c.r * _g.mul - PERIMETER_WIDTH / 2);

        perimeter_layer.graphics.lineStyle(PERIMETER_WIDTH, over_perimeter || changing_r ? 0xAA0000 : 0xAAAAAA, _c.enabled ? 1 : 0.2);
        perimeter_layer.graphics.drawCircle(_p.x, _p.y, c.r * _g.mul - PERIMETER_WIDTH / 2);
    }

    public function get g():GardenView {
        return _g;
    }

    public function get c():Circle {
        return _c;
    }

    private function circle_layer_rollOverHandler(event:MouseEvent):void {
        over_circle = true;

        if (changing_r || moving_xy)
            return;

        redraw_circle();
    }

    private function circle_layer_rollOutHandler(event:MouseEvent):void {
        over_circle = false;

        if (changing_r || moving_xy)
            return;

        redraw_circle();
    }

    private function perimeter_layer_rollOverHandler(event:MouseEvent):void {
        over_perimeter = true;

        if (changing_r || moving_xy)
            return;

        redraw_perimeter();
    }

    private function perimeter_layer_rollOutHandler(event:MouseEvent):void {
        over_perimeter = false;

        if (changing_r || moving_xy)
            return;

        redraw_perimeter();
    }

    private function circle_layer_mouseDownHandler(event:MouseEvent):void {
        if (moving_xy)
            return;

        moving_xy = true;
        moving_xy_start_position = realMousePosition(event);
        moving_xy_start_center = _c.center;
    }

    private function circle_layer_mouseUpHandler(event:MouseEvent):void {
        if (!moving_xy)
            return;

        moving_xy = false;

        _g.refresh();
    }

    private function perimeter_layer_mouseDownHandler(event:MouseEvent):void {
        changing_r = true;
    }

    private function perimeter_layer_mouseUpHandler(event:MouseEvent):void {
        if (!changing_r)
            return;

        changing_r = false;

        redraw_perimeter();
        _g.refresh();
    }

    private function stage_mouseMoveHandler(event:MouseEvent):void {
        if (!changing_r && !moving_xy)
            return;

        var realPosition:Point = realMousePosition(event);
        var pos:Point = _g.disp2natural(realPosition);

        if (changing_r) {
            var new_r:Number = pos.subtract(_c.center).length;

            new_r = Math.round(new_r / _g.grid_step) * _g.grid_step;

            if (new_r < 2 * _g.grid_step)
                new_r = 2 * _g.grid_step;

            var maxR:Number = Math.min(10, _g.garden.W - c.x, c.x, _g.garden.H - c.y, c.y);

            if (new_r > maxR)
                new_r = maxR;

            c.r = new_r;
        } else if (moving_xy) {
            var d:Point = realPosition.subtract(moving_xy_start_position);
            var new_center:Point = moving_xy_start_center.add(new Point(d.x / _g.mul, -d.y / _g.mul));

            //normalize center
            new_center.x = Math.round(new_center.x / _g.grid_step) * _g.grid_step;
            new_center.y = Math.round(new_center.y / _g.grid_step) * _g.grid_step;

            new_center.x = Math.max(new_center.x, _c.r);
            new_center.x = Math.min(new_center.x, _g.garden.W - _c.r);
            new_center.y = Math.max(new_center.y, _c.r);
            new_center.y = Math.min(new_center.y, _g.garden.H - _c.r);

            moveTo(new_center);
        }

        _g.garden.refreshCirclesStatus();

        _g.redraw_all_circles();
//        redraw();
    }

    private function moveTo(new_center:Point = null):void {
        if (new_center != null)
            _c.center = new_center;
        _p = _g.natural2disp(_c.center);
        _tix.x = _p.x - _tix.width / 2;
        _tix.y = _p.y - _tix.height / 2;
    }

    private function realMousePosition(event:MouseEvent):Point {
        return new Point(event.stageX, event.stageY).subtract(this.localToGlobal(new Point(0, 0)));
    }

    private static function pntToString(point:Point):String {
        return "(" + point.x.toFixed(2) + ", " + point.y.toFixed(2) + ")";
    }

    private function addedToStageHandler(event:Event):void {
        stage.addEventListener(MouseEvent.MOUSE_UP, circle_layer_mouseUpHandler);
        stage.addEventListener(MouseEvent.MOUSE_UP, perimeter_layer_mouseUpHandler);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
    }

    private function removedFromStageHandler(event:Event):void {
        stage.removeEventListener(MouseEvent.MOUSE_UP, circle_layer_mouseUpHandler);
        stage.removeEventListener(MouseEvent.MOUSE_UP, perimeter_layer_mouseUpHandler);
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
    }

    public function redraw():void {
        redraw_circle();
        redraw_perimeter();
    }
}
}
