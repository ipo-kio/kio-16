package ru.ipo.kio._16.rockgarden.view {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import mx.utils.HSBColor;


import ru.ipo.kio._16.rockgarden.model.Circle;

import ru.ipo.kio._16.rockgarden.model.Garden;
import ru.ipo.kio._16.rockgarden.model.Segment;
import ru.ipo.kio._16.rockgarden.model.SegmentInfo;

public class GardenView extends Sprite {
    private var _g:Garden;
    private var _mul:Number;
    private var _grid_step:Number;

    private var _circles:Vector.<CircleView> = new <CircleView>[];

    private var _segments_layer:Sprite = null;

    private var _tangent_layer:Sprite = null;

    private var _long_info:TextField = new TextField();

    private var _areas:Vector.<ViewArea>;

    private var _sideView:RocksSideView;

    public function GardenView(g:Garden, mul:Number, grid_step:Number, sideView: RocksSideView, areas:Vector.<ViewArea> = null) {
        _g = g;
        _mul = mul;
        _grid_step = grid_step;
        _sideView = sideView;

        _areas = areas;

        draw_grid();

        for each (var circle:Circle in g.circles) {
            var cv:CircleView = new CircleView(this, circle);
            _circles.push(cv);
            addChild(cv);
        }

        if (showsAreas())
            for each (var area:ViewArea in _areas) {
                var pnt:Point = natural2disp(area.point);
                area.x = pnt.x;
                area.y = pnt.y;
                addChild(area);

                area.addEventListener(MouseEvent.CLICK, area_clickHandler);
            }
        else
            redrawSegments();

        graphics.lineStyle(1, 0);
        graphics.drawRect(0, 0, _g.W * mul, _g.H * mul);

        init_long_info();
    }

    private function showsAreas():Boolean {
        return _areas != null;
    }

    private function init_long_info():void {
        addChild(_long_info);
        _long_info.defaultTextFormat = new TextFormat('KioArial', 16);
        _long_info.selectable = false;
        _long_info.mouseEnabled = false;
        _long_info.embedFonts = true;
        _long_info.autoSize = TextFieldAutoSize.LEFT;

        _long_info.x = 0;
        _long_info.y = _g.H * mul + 20;

        long_info = "";
    }

    private function draw_grid():void {
        var gs:Number = _grid_step * 16;

        graphics.lineStyle(1, 0xAAAAAA, 0.4);
        for (var i:int = 0; i <= _g.W / gs; i++) {
            graphics.moveTo(i * gs * _mul, 0);
            graphics.lineTo(i * gs * _mul, _g.H * _mul);
        }
        for (i = 0; i <= _g.H / gs; i++) {
            graphics.moveTo(0, i * gs * _mul);
            graphics.lineTo(_g.W * _mul, i * gs * _mul);
        }
    }

    public function get garden():Garden {
        return _g;
    }

    public function natural2disp(p:Point):Point {
        return new Point(p.x * _mul, (_g.H - p.y) * _mul);
    }

    public function disp2natural(p:Point):Point {
        return new Point(p.x / _mul, _g.H - p.y / _mul);
    }

    public function snapToGrid(p:Point):Point {
        var x:Number = Math.round(p.x / _grid_step) * _grid_step;
        var y:Number = Math.round(p.y / _grid_step) * _grid_step;

        if (x < 0)
            x = 0;
        if (x > _g.W)
            x = _g.W;
        if (y < 0)
            y = 0;
        if (y > _g.H)
            y = _g.H;

        return new Point(x, y);
    }

    public function get mul():Number {
        return _mul;
    }

    public function redrawSegments():void {
        if (showsAreas())
            return;

        if (_segments_layer != null)
            removeChild(_segments_layer);

        _segments_layer = new Sprite();
        addChild(_segments_layer);

        var segmentsNum:int = _g.segments.segments.length;
        for (var i:int = 0; i < segmentsNum; i++) {
            var c:uint = HSBColor.convertHSBtoRGB(360 * i / segmentsNum, 1, 0.8);
            var s:Segment = _g.segments.segments[i];
            var sv:SegmentView = new SegmentView(s, this, c, getSegmentInfo);
            _segments_layer.addChild(sv);
        }
    }

    public function redrawTangents():void {
        return;

        if (_tangent_layer != null)
            removeChild(_tangent_layer);
        _tangent_layer = new Sprite();
        addChild(_tangent_layer);

        var t:Vector.<Point> = _g.tangent_lines;

        _tangent_layer.graphics.lineStyle(1, 0x888888);

        for (var i:int = 0; i < t.length; i += 2) {
            var t1:Point = natural2disp(t[i]);
            var t2:Point = natural2disp(t[i + 1]);
            _tangent_layer.graphics.moveTo(t1.x, t1.y);
            _tangent_layer.graphics.lineTo(t2.x, t2.y);
        }
    }

    private function getSegmentInfo(visible_circles:Vector.<int>):SegmentInfo {
        if (visible_circles == null)
            return new SegmentInfo("??", "??");

        var circles:int = 0;
        var all_circles:Vector.<int> = new <int>[];
        for each (var c:CircleView in _circles)
            if (c.c.enabled) {
                circles++;
                all_circles.push(c.c.index);
            }
        var hidden_circles:Vector.<int> = new <int>[];

        var i:int = 0;
        var j:int = 0;
        while (i < visible_circles.length) {
            var v:int = visible_circles[i++];
            while (j < all_circles.length && all_circles[j] < v)
                hidden_circles.push(all_circles[j++]);
            j++;
        }
        while (j < all_circles.length)
            hidden_circles.push(all_circles[j++]);

        var visible_circles_cnt:int = visible_circles.length;
        return new SegmentInfo(
                visible_circles_cnt + "",
                "Видно кругов: " + visible_circles_cnt + ", спрятанные круги: " + hidden_circles.toString()
        );
//        return new SegmentInfo(visible_circles + "", visible_circles + "");
    }

    public function get grid_step():Number {
        return _grid_step;
    }

    public function refresh():void {
        _g.refreshCirclesStatus();

        if (showsAreas()) {
            for each (var area:ViewArea in _areas) {
                area.reeval();
                if (area.selected)
                    updateSideView(area);
            }
        } else {
            _g.evalSegments();
            redrawSegments();
            redrawTangents();
        }
    }

    public function redraw_all_circles():void {
        for each (var cv:CircleView in _circles)
            cv.redraw();
    }

    public function set long_info(info:String):void {
        _long_info.text = info;
    }

    private function area_clickHandler(event:MouseEvent):void {
        var area:ViewArea = event.target as ViewArea;

        if (area == null)
            return;

        for each (var a:ViewArea in _areas)
            a.selected = a == area;
        updateSideView(area);
    }

    private function updateSideView(area:ViewArea):void {
        _sideView.location = area.point;
    }
}
}