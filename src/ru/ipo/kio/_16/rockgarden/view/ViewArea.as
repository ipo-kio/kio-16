package ru.ipo.kio._16.rockgarden.view {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio._16.rockgarden.model.Garden;
import ru.ipo.kio._16.rockgarden.model.SegmentsList;

public class ViewArea extends Sprite {

    public static const R:Number = 10;
    private static const c:Number = 0.551915024494; //http://spencermortensen.com/articles/bezier-circle/

    [Embed(source="../res/area.png")]
    public static const AREA_CLASS:Class;
    public static var AREA_IMG:BitmapData = (new AREA_CLASS).bitmapData;

    [Embed(source="../res/area_selected.png")]
    public static const AREA_S_CLASS:Class;
    public static var AREA_S_IMG:BitmapData = (new AREA_S_CLASS).bitmapData;

    private static const FONT_SIZE:int = 14;
    private static const SKIP:int = 16;
    private static const tFormat:TextFormat = new TextFormat('KioArial', FONT_SIZE, 0x000000);

    private var _point:Point;
    private var _loc:Number;
    private var _g:Garden;
    private var _side:int; //Garden.SIDE_*

    private var _visibleCircles:Vector.<int> = null;
    private var _selected:Boolean = false;

    private var _text:TextField;

    public function ViewArea(point:Point, g:Garden) {
        _point = point;
        _g = g;
        _loc = _g.point2location(_point);
        _side = _g.location2side(_loc);

        initTextField();

        redraw();

        addEventListener(MouseEvent.ROLL_OVER, function(event:MouseEvent):void {
            _selected = true;
            redraw();
        });

        addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):void {
            _selected = false;
            redraw();
        });
    }

    private function initTextField():void {
        _text = new TextField();
        _text.defaultTextFormat = tFormat;
        _text.embedFonts = true;
        _text.selectable = false;
        _text.mouseEnabled = false;
        _text.text = "";

        switch (_side) {
            case Garden.SIDE_BOTTOM:
                _text.autoSize = TextFieldAutoSize.CENTER;
                _text.x = 0;
                _text.y = SKIP;
                break;
            case Garden.SIDE_RIGHT:
                _text.autoSize = TextFieldAutoSize.LEFT;
                _text.x = SKIP;
                _text.y = -FONT_SIZE / 2;
                break;
            case Garden.SIDE_TOP:
                _text.autoSize = TextFieldAutoSize.CENTER;
                _text.x = 0;
                _text.y = -FONT_SIZE - SKIP;
                break;
            case Garden.SIDE_LEFT:
                _text.autoSize = TextFieldAutoSize.RIGHT;
                _text.x = -SKIP;
                _text.y = -FONT_SIZE / 2;
                break;
        }

        addChild(_text);
    }

    public function get point():Point {
        return _point;
    }

    public function get g():Garden {
        return _g;
    }

    public function get side():int {
        return _side;
    }

    public function redraw():void {
        graphics.clear();

        var m:Matrix = new Matrix();
        m.translate(-AREA_IMG.width / 2, 0);
        switch (_side) {
            case Garden.SIDE_BOTTOM:
                break;
            case Garden.SIDE_RIGHT:
                m.rotate(-Math.PI / 2);
                break;
            case Garden.SIDE_TOP:
                m.rotate(Math.PI);
                break;
            case Garden.SIDE_LEFT:
                m.rotate(Math.PI / 2);
                break;
        }

        graphics.beginBitmapFill(_selected ? AREA_S_IMG : AREA_IMG, m);
        trace('rotate: ', _side);
        switch (_side) {
            case Garden.SIDE_BOTTOM:
                graphics.drawRect(-AREA_IMG.width / 2, 0, AREA_IMG.width, AREA_IMG.height);
                break;
            case Garden.SIDE_RIGHT:
                graphics.drawRect(0, -AREA_IMG.width / 2, AREA_IMG.height, AREA_IMG.width);
                break;
            case Garden.SIDE_TOP:
                graphics.drawRect(-AREA_IMG.width / 2, -AREA_IMG.height, AREA_IMG.width, AREA_IMG.height);
                break;
            case Garden.SIDE_LEFT:
                graphics.drawRect(-AREA_IMG.height, -AREA_IMG.width / 2, AREA_IMG.height, AREA_IMG.width);
                break;
        }
        graphics.endFill();
    }

//    public function drawArc1():void {
//        graphics.moveTo(0, R);
//        graphics.cubicCurveTo(c * R, R, R, c * R, R, 0);
//    }

    public function get visibleCircles():Vector.<int> {
        return _visibleCircles;
    }

    public function reeval():void {
        var segmentsList:SegmentsList = _g.visible_circles_for_point(_point);
        _visibleCircles = Garden.anglesCircle2visibleCircles(segmentsList);

        _text.text = _visibleCircles.join(_side == Garden.SIDE_LEFT || _side == Garden.SIDE_RIGHT ? "\n" : " ");
        placeText();
    }

    private function placeText():void {
        var dx:Number = 0;
        var dy:Number = 0;

        switch (_side) {
            case Garden.SIDE_BOTTOM:
                dy += SKIP;
                break;
            case Garden.SIDE_RIGHT:
                dx += SKIP;
                break;
            case Garden.SIDE_TOP:
                dy -= SKIP;
                break;
            case Garden.SIDE_LEFT:
                dx -= SKIP;
                break;
        }

        _text.x = dx - _text.width / 2;
        _text.y = dy - _text.height / 2;
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
}
}
