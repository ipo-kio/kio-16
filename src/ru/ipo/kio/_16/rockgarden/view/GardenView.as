package ru.ipo.kio._16.rockgarden.view {
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.Dictionary;

import ru.ipo.kio._16.rockgarden.RockGardenWorkspace;
import ru.ipo.kio._16.rockgarden.model.Circle;
import ru.ipo.kio._16.rockgarden.model.Garden;
import ru.ipo.kio._16.rockgarden.model.Segment;
import ru.ipo.kio._16.rockgarden.model.SegmentInfo;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;

public class GardenView extends Sprite {
    [Embed(source="../res/imgs/green-ball.png")]
    public static const BALL_CLASS:Class;

    private var _g:Garden;
    private var _mul:Number;
    private var _grid_step:Number;

    private var _circles:Vector.<CircleView> = new <CircleView>[];

    private var _segments_layer:Sprite = null;

    private var _tangent_layer:Sprite = null;

    private var _long_info:TextField = new TextField();

    private var _areas:Vector.<ViewArea>;
    private var _current_area:ViewArea; //used only in 2nd level
    private var _mouse_over_area:ViewArea; //used only in 2nd level

    private var _sideView:RocksSideView;

    private var _problem_style:int;
    private var _api:KioApi;
    private var _workspace:RockGardenWorkspace;

    private var green_ball:Shape;

    private const _segments_color_palette:Vector.<uint> = new <uint>[
            0x000000,
            70 << 16 | 181 << 8 | 211,
            52 << 16 | 57 << 8 | 60,
            219 << 16 | 73 << 8 | 76,
            235 << 16 | 164 << 8 | 50,
            134 << 16 | 170 << 8 | 109,
            172 << 16 | 61 << 8 | 31,
            32 << 16 | 114 << 8 | 136
    ];

    public function GardenView(g:Garden, mul:Number, grid_step:Number, sideView:RocksSideView, problem_style:int, problem:KioProblem, workspace:RockGardenWorkspace, areas:Vector.<ViewArea> = null) {
        _api = KioApi.instance(problem);
        _problem_style = problem_style;
        _g = g;
        _mul = mul;
        _grid_step = grid_step;
        _sideView = sideView;
        _workspace = workspace;

        _areas = areas;

        _segments_layer = new Sprite();
        addChild(_segments_layer);

        draw_grid();

        if (showsAreas())
            for each (var area:ViewArea in _areas) {
                relocateArea(area);
                addChild(area);

                area.addEventListener(MouseEvent.CLICK, area_clickHandler);
            }
        else
            redrawSegments();

        for each (var circle:Circle in g.circles) {
            var cv:CircleView = new CircleView(this, circle);
            _circles.push(cv);
            addChild(cv);
        }

        graphics.lineStyle(1, 0);
        graphics.drawRect(0, 0, _g.W * mul, _g.H * mul);

        if (problem_style == 2) {
            _current_area = new ViewArea(new Point(0, 0), _g, "", 2);
            _mouse_over_area = new ViewArea(new Point(0, 0), _g, "", 1);

            _current_area.mouseEnabled = false;
            _mouse_over_area.mouseEnabled = false;

            addChild(_current_area);
            addChild(_mouse_over_area);

            _current_area.visible = false;
            _mouse_over_area.visible = false;
        }

        init_long_info();
        init_green_ball();
    }

    private function init_green_ball():void {
        if (_problem_style == 2)
            return;
        green_ball = new Shape();

        var bitmap:BitmapData = (new BALL_CLASS).bitmapData;
        var m:Matrix = new Matrix();
        m.translate(-bitmap.width / 2, -bitmap.height / 2);

        green_ball.graphics.beginBitmapFill(bitmap, m);
        green_ball.graphics.drawRect(-bitmap.width / 2, -bitmap.height / 2, bitmap.width, bitmap.height);
        green_ball.graphics.endFill();
        addChild(green_ball);
        green_ball.visible = false;
    }

    private function relocateArea(area:ViewArea):void {
        var pnt:Point = natural2disp(area.point);
        area.x = pnt.x;
        area.y = pnt.y;
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

        while (_segments_layer.numChildren > 0) {
            SegmentView(_segments_layer.getChildAt(0)).destroy();
            _segments_layer.removeChildAt(0);
        }

        if (_problem_style == 2) {
            _segments_layer.addEventListener(MouseEvent.CLICK, segments_layer_clickHandler);
            _segments_layer.addEventListener(MouseEvent.MOUSE_MOVE, segments_layer_mouseOverHandler);
            _segments_layer.addEventListener(MouseEvent.ROLL_OVER, segments_layer_rollOverHandler);
            _segments_layer.addEventListener(MouseEvent.ROLL_OUT, segments_layer_rollOutHandler);
        }

        var segmentsNum:int = _g.segments.segments.length;
        for (var i:int = 0; i < segmentsNum; i++) {
            var s:Segment = _g.segments.segments[i];
            var j:int = s.value == null ? 0 : s.value.length;
//            var c:uint = HSBColor.convertHSBtoRGB(360 * j / _g.circles.length, 1, 0.8);
//            var c:uint = HSBColor.convertHSBtoRGB(360 * i / segmentsNum, 1, 0.8);
            var c:uint = _segments_color_palette[j];

            if (j <= 3 || j == 7)
                var base_width:Number = 2;
            else if (j == 5)
                base_width = 6;
            else
                base_width = 4;

            var sv:SegmentView = new SegmentView(s, this, c, base_width, getSegmentInfo);
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

            if (_current_area.visible) {
                _current_area.reeval();
                updateSideView(_current_area);
            }
        }

        _workspace.submitResult(result);
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

    private static function nRocks(n:int):String {
        if (n == 1)
            return "1 камень";
        if (n == 2 || n == 3 || n == 4)
            return n + " камня";
        return n + " камней";
    }

    private function updateSideView(area:ViewArea):void {
        _sideView.location = area.point;
        var vis:Vector.<int> = area.visibleCircles;
//        var text:String = (area.viewName != "" ? area.viewName + ", видно " : "Видно ") + nRocks(vis.length) + ": " + vis.join(" ");
        var text:String = "Видно " + nRocks(vis.length) + "|" + vis.join(" ");
        _sideView.text = text;

        //update green circle
        if (_problem_style == 2)
            return;

        green_ball.visible = true;
        switch (area.viewName) {
            case "left":
                var p:Point = new Point(88, 486);
                break;
            case "right":
                p = new Point(166, 486);
                break;
            case "top":
                p = new Point(128, 448);
                break;
            case "bottom":
                p = new Point(128, 526);
                break;

            case "bottom left":
                p = new Point(128 - 14, 526);
                break;
            case "bottom right":
                p = new Point(128 + 14, 526);
                break;
            case "top left":
                p = new Point(128 - 14, 448);
                break;
            case "top right":
                p = new Point(128 + 14, 448);
                break;
        }
        p.y += 25;

        p = globalToLocal(p);
        green_ball.x = p.x;
        green_ball.y = p.y;
    }

    public function get result():Object {
        for each (var cc:Circle in _g.circles)
            if (!cc.enabled)
                return {err: true};

        switch (_problem_style) {
            case 0:
                return resultFor0and1(3);
            case 1:
                return resultFor0and1(5);
            case 2:
                return resultFor2();
        }
        return null;
    }

    private function resultFor0and1(need:int):Object {
        var r:int = 0;
        var crc:Vector.<String> = new <String>[];
        for each (var area:ViewArea in _areas) {
            var vis:Vector.<int> = area.visibleCircles;
            if (vis.length == need) {
                r++;
                crc.push(vis.join(""));
            }
        }

        crc = crc.sort(0);
        var d:int = 0;
        for (var i:int = 0; i < crc.length; i++)
            if (i == 0)
                d++;
            else if (crc[i - 1] != crc[i])
                d++;

        var s:Number = 0;
        for each (var c:Circle in _g.circles)
            if (c.enabled && c.r > s)
                s = c.r;

        return {
            r: r,
            d: d,
            s: int(Math.round(8 * s)),
            err: false
        };
    }

    private function invertVector(v:Vector.<int>):int {
        var aa:Vector.<Boolean> = new Vector.<Boolean>(8, true);
        for (var i:int = 1; i <= 7; i++)
            aa[i] = false;
        for (i = 0; i < v.length; i++)
            aa[v[i]] = true;
        var r:int = 0;
        for (i = 1; i <= 7; i++)
            if (!aa[i])
                r = r * 10 + i;
        return r;
    }

    private function resultFor2():Object {
        var pairsDict:Dictionary = new Dictionary();

        var visibilityDict:Dictionary = new Dictionary();

        for each (var s:Segment in _g.segments.segments) {
            var twoInvisible:int = invertVector(s.value);
            if (twoInvisible < 100 && twoInvisible > 9)
                pairsDict[twoInvisible] = true;

            var l:Number = s.distance(_g.MAX_SEGMENTS_LIST_VALUE);

            for each (var c:int in s.value) {
                if (c in visibilityDict)
                    visibilityDict[c] += l;
                else
                    visibilityDict[c] = l;
            }
        }

        var pairs:int = 0;
        for (var o:Object in pairsDict)
            pairs++;

        var sum:Number = 0;
        var sum2:Number = 0;
        for (c = 1; c <= 7; c++) {
            var d:Number = c in visibilityDict ? visibilityDict[c] : 0;
            sum += d;
            sum2 += d * d;
        }

        return {
            p: pairs,
            v: Math.sqrt(sum2 / 7 - sum * sum / 49)
        }
    }

    private function resultFor2old():Object {
        var n:int = _g.circles.length;

        var sum:Number = 0;
        var visible:Vector.<Boolean> = new Vector.<Boolean>(n + 1);

        for each (var s:Segment in _g.segments.segments) {
            //s.value: vector of ints

            var v:Vector.<int> = s.value;
            if (v == null)
                v = new <int>[];
            if (v.length == 6) {
                sum += s.distance(_g.MAX_SEGMENTS_LIST_VALUE);
                for each (var c_in:int in v)
                    visible[c_in] = true;
            }
        }

        var visible_circles:int = 0;
        for (var i:int = 1; i <= n; i++)
            if (visible[c_in])
                visible_circles++;
        var invisible_circles:int = n - visible_circles;

        return {
            i: invisible_circles,
            s: 100 * sum / _g.MAX_SEGMENTS_LIST_VALUE,
            err: false
        }
    }

    private function segments_layer_clickHandler(event:MouseEvent):void {
        _current_area.visible = true;
        updateViewArea(event, _current_area, true);
    }

    private function segments_layer_mouseOverHandler(event:MouseEvent):void {
        updateViewArea(event, _mouse_over_area, false);
    }

    private function updateViewArea(event:MouseEvent, area:ViewArea, needUpdateSideView:Boolean):void {
        var pos:Point = disp2natural(new Point(event.localX, event.localY));
        //distance to left, right, bottom, top
        var dl:Number = Math.abs(pos.x);
        var dr:Number = Math.abs(_g.W - pos.x);
        var db:Number = Math.abs(pos.y);
        var dt:Number = Math.abs(_g.H - pos.y);

        var dmin:Number = Math.min(dl, dr, db, dt);
        if (dmin == dl)
            pos.x = 0;
        else if (dmin == dr)
            pos.x = _g.W;
        else if (dmin == db)
            pos.y = 0;
        else //if (dmin == dt)
            pos.y = _g.H;

        area.point = pos;
        if (needUpdateSideView)
            updateSideView(area);

        relocateArea(area);
    }

    private function segments_layer_rollOverHandler(event:MouseEvent):void {
        _mouse_over_area.visible = true;
    }

    private function segments_layer_rollOutHandler(event:MouseEvent):void {
        _mouse_over_area.visible = false;
    }

    public function get realWidth():Number {
        return _mul * _g.W;
    }

    public function get realHeight():Number {
        return _mul * _g.H;
    }
}
}