package ru.ipo.kio._16.rockgarden.view {
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio._16.rockgarden.model.*;

import flash.geom.Point;

public class RocksSideView extends Sprite {

    [Embed(source="../res/teni-pramougoln-gorizontal-1.png")]
    public static const HOR_SHADOWS:Class;
    public static var HOR_SHADOWS_IMG:BitmapData = (new HOR_SHADOWS).bitmapData;

    [Embed(source="../res/teni-pramougoln-vertikal-1.png")]
    public static const VERT_SHADOWS:Class;
    public static var VERT_SHADOWS_IMG:BitmapData = (new VERT_SHADOWS).bitmapData;

    private var _location:Point = null;
    private var _g:Garden;
    private var _side:int; //Garden.SIDE_*

    private var _width:Number;
    private var _height:Number;

    private var _text:TextField;
    private var _text_2:TextField;

    public function RocksSideView(g:Garden, width:Number, height:Number) {
        _g = g;
        _width = width;
        _height = height;

        redraw();

        initText();
    }

    private function initText():void {
        _text = new TextField();
        _text.autoSize = TextFieldAutoSize.LEFT;
        _text.embedFonts = true;
        _text.defaultTextFormat = new TextFormat('KioArial', 16);
        _text.mouseEnabled = false;
        _text.selectable = false;
        addChild(_text);
        _text.text = "";

        _text_2 = new TextField();
        _text_2.autoSize = TextFieldAutoSize.LEFT;
        _text_2.embedFonts = true;
        _text_2.defaultTextFormat = new TextFormat('KioArial', 16, 0x000000, true);
        _text_2.mouseEnabled = false;
        _text_2.selectable = false;
        addChild(_text_2);
        _text_2.text = "";
    }

    public function redraw():void {
        if (_location == null)
            return;

        var anglesCircle:SegmentsList = _g.visible_circles_for_point(_location);
        switch (_side) {
            // 0  pi/2 pi
            case Garden.SIDE_BOTTOM:
                anglesCircle.modify(function (x:Number):Number {
                    return Math.PI - x;
                }, true);
                break;    // pi pi/2 0
            case Garden.SIDE_LEFT:
                anglesCircle.modify(function (x:Number):Number {
                    return Math.PI / 2 - x;
                }, true);
                break;      // pi/2 0 -pi/2
            case Garden.SIDE_TOP:
                anglesCircle.modify(function (x:Number):Number {
                    return -x;
                }, true);
                break;       // 0  3pi/2 pi
            case Garden.SIDE_RIGHT:
                anglesCircle.modify(function (x:Number):Number {
                    return 3 * Math.PI / 2 - x;
                }, true);

                break;     // 3pi/2 pi pi/2
        }

        var neg_point:Number = 3 * Math.PI / 2;

        graphics.clear();
        var maxDist:Number = Math.sqrt(_g.W * _g.W + _g.H * _g.H);
        for each (var s:Segment in anglesCircle.segments)
            if (s.value >= 0 && !s.pointInside(neg_point)) {
                var c:Circle = _g.getCircleByIndex(s.value);
                var dx:Number = c.x - _location.x;
                var dy:Number = c.y - _location.y;
                var d:Number = Math.sqrt(dx * dx + dy * dy) - c.r * 0.95;

                var circle_height:Number = _height * (maxDist - d) / maxDist;

                if (s.start > Math.PI + 0.1)
                    s.start -= 2 * Math.PI;

                draw_rect(s.value, _width * s.start / Math.PI, _width * s.end / Math.PI, circle_height);
            }

        //draw border
        graphics.lineStyle(1, 0xFF0000);
        graphics.moveTo(0, _height);
        graphics.lineTo(_width, _height);
    }

    private function draw_rect(value:int, start:Number, end:Number, height:Number):void {
//        graphics.lineStyle(1, 0xFF0000);
        RockPalette.beginFill(graphics, value);
        graphics.drawRect(start, _height - height, end - start, height);
        graphics.endFill();

        var m:Matrix = new Matrix();
        m.scale((end - start) / HOR_SHADOWS_IMG.width, height / HOR_SHADOWS_IMG.height);
        m.translate(start, _height - height);
        graphics.beginBitmapFill(HOR_SHADOWS_IMG, m);
        graphics.drawRect(start, _height - height, end - start, height);
        graphics.endFill();

        m = new Matrix();
        m.scale((end - start) / VERT_SHADOWS_IMG.width, height / VERT_SHADOWS_IMG.height);
        m.translate(start, _height - height);
        graphics.beginBitmapFill(VERT_SHADOWS_IMG, m);
        graphics.drawRect(start, _height - height, end - start, height);
        graphics.endFill();
    }

    public function get location():Point {
        return _location;
    }

    public function set location(value:Point):void {
        _location = value;
        if (_location != null)
            _side = _g.location2side(_g.point2location(_location));
        redraw();
    }

    public function set text(value:String):void {
        var p:Point = globalToLocal(new Point(104, 25 + 550));

        _text.text = value;
        var split:Array = value.split("|");
        _text.text = split[0];
        _text_2.text = split[1];

        _text.x = p.x - _text.width / 2;
        _text.y = p.y - _text.height / 2;

        _text_2.x = p.x - _text_2.width / 2;
        _text_2.y = 16 + p.y - _text_2.height / 2;
    }
}
}
