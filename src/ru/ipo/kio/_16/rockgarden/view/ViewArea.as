package ru.ipo.kio._16.rockgarden.view {
import flash.display.BitmapData;
import flash.display.Graphics;
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
//    private static const c:Number = 0.551915024494; //http://spencermortensen.com/articles/bezier-circle/

    [Embed(source="../res/imgs/eye.png")]
    public static const AREA_CLASS:Class;
    public static var AREA_IMG:BitmapData = (new AREA_CLASS).bitmapData;

    [Embed(source="../res/imgs/eye-ball.png")]
    public static const AREA_S_CLASS:Class;
    public static var AREA_S_IMG:BitmapData = (new AREA_S_CLASS).bitmapData;

    [Embed(source="../res/imgs/svitok.png")]
    public static const SVITOK_CLASS:Class;
    public static var SVITOK_IMG:BitmapData = (new SVITOK_CLASS).bitmapData;

    private static const FONT_SIZE:int = 16;
    private static const SKIP:int = 16;
    private static const tFormat:TextFormat = new TextFormat('KioArial', FONT_SIZE, 0x000000, true);

    private var _point:Point;
    private var _loc:Number;
    private var _g:Garden;
    private var _side:int; //Garden.SIDE_*

    private var _visibleCircles:Vector.<int> = null;
    private var _over:Boolean = false;
    private var _selected:Boolean = false;
    private var _selectable:int = 0;

    private var _viewName:String;
    private var _text:TextField;

    private var _eye_layer:Sprite;

    /**TextFor
     * @param point
     * @param g
     * @param viewName
     * @param selectable 0 means selectable, 1 means always not selected, 2 means always selected
     */
    public function ViewArea(point:Point, g:Garden, viewName:String, selectable:int = 0) {
        _point = point;
        _g = g;
        _loc = _g.point2location(_point);
        _side = _g.location2side(_loc);

        _viewName = viewName;

        mouseChildren = false;

        _eye_layer = new Sprite();
        addChild(_eye_layer);

        _text = new TextField();
        _text.text = "";
        addChild(_text);

        initTextField();
        redraw();

        _selectable = selectable;

        if (selectable == 0) {
            addEventListener(MouseEvent.ROLL_OVER, function (event:MouseEvent):void {
                _over = true;
                redraw();
            });

            addEventListener(MouseEvent.ROLL_OUT, function (event:MouseEvent):void {
                _over = false;
                redraw();
            });
        }
    }

    private function initTextField():void {
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
    }

    public function get point():Point {
        return _point;
    }

    public function set point(point:Point):void {
        _point = point;

        _loc = _g.point2location(_point);
        _side = _g.location2side(_loc);

        initTextField();
        reeval();
        redraw();
    }

    public function get g():Garden {
        return _g;
    }

    public function get side():int {
        return _side;
    }

    public function redraw():void {
        var g:Graphics = _eye_layer.graphics;

        g.clear();

        var m:Matrix = new Matrix();
        m.translate(-AREA_IMG.width / 2, -AREA_IMG.height / 2);

        g.beginBitmapFill(_selected || _over || _selectable == 2 ? AREA_S_IMG : AREA_IMG, m);
        g.drawRect(-AREA_IMG.width / 2, -AREA_IMG.height / 2, AREA_IMG.width, AREA_IMG.height);
        g.endFill();
    }

    public function redrawOld():void {
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

        graphics.beginBitmapFill(_selected || _over || _selectable == 2 ? AREA_S_IMG : AREA_IMG, m);
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

    private function placeTextOld():void {
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

    private function placeText():void {
        var gw:GardenView = parent as GardenView;
        if (gw == null)
            return;

        graphics.clear();
        var x0:Number;
        var y0:Number;
        var rot:Number;

        var sw:Number = SVITOK_IMG.width;
        var sh:Number = SVITOK_IMG.height;

        var dd:Point = new Point(0, 8);

        var pnt:Point = gw.natural2disp(_point);

        switch (_side) {
            case Garden.SIDE_BOTTOM:
                x0 = 0;
                y0 = 0;
                rot = 0;

                if (pnt.x + x0 + sw > gw.realWidth)
                    x0 = -sw;

                break;
            case Garden.SIDE_RIGHT:
                x0 = 0;
                y0 = 0;
                rot = -Math.PI / 2;

                if (pnt.y + y0 + sw > gw.realHeight)
                    y0 = -sw;

                break;
            case Garden.SIDE_TOP:
                x0 = -sw;
                y0 = -sh;
                rot = Math.PI;

                if (pnt.x + x0 < 0)
                    x0 = 0;

                break;
            case Garden.SIDE_LEFT:
                x0 = -sh;
                y0 = 0;

                rot = Math.PI / 2;

                if (pnt.y + y0 + sw > gw.realHeight)
                    y0 = -sw;

                break;
        }

        //draw scroll
        var cx:Number;
        var cy:Number;

        var m:Matrix = new Matrix();
        m.translate(dd.x, dd.y);
        m.rotate(rot);
        graphics.beginBitmapFill(SVITOK_IMG, m);

        var dd_transformed:Point = m.transformPoint(new Point(0, 0));

        if (_side == Garden.SIDE_TOP || _side == Garden.SIDE_BOTTOM) {
            graphics.drawRect(x0 + dd_transformed.x, y0 + dd_transformed.y, sw, sh);
            cx = x0 + sw / 2;
            cy = y0 + sh / 2;
        } else {
            graphics.drawRect(x0 + dd_transformed.x, y0 + dd_transformed.y, sh, sw);
            cx = x0 + sh / 2;
            cy = y0 + sw / 2;
        }
        graphics.endFill();

        _text.x = cx + dd_transformed.x / 2 - _text.width / 2;
        _text.y = cy + dd_transformed.y / 2 - _text.height / 2;
    }

    public function get selected():Boolean {
        return _selected;
    }

    public function get viewName():String {
        return _viewName;
    }

    public function set selected(value:Boolean):void {
        if (_selected == value)
            return;
        _selected = value;
        redraw();
    }
}
}
