package ru.ipo.kio._16.rockgarden.view {
import flash.display.CapsStyle;
import flash.display.Graphics;
import flash.display.JointStyle;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.ipo.kio._16.rockgarden.model.Garden;
import ru.ipo.kio._16.rockgarden.model.Segment;

public class SegmentView extends Sprite {
    private var _s:Segment;
    private var _g:GardenView;
    private var _c:uint;
    private var _base_width:Number;

    private var state_over:Boolean = false;
    
    private var _tf:TextField;

    private static const tFormat:TextFormat = new TextFormat('KioArial', 12, 0x000000);
    private static const tFormatOver:TextFormat = new TextFormat('KioArial', 12, 0xAB0028);
    private var _getSegmentInfo:Function;

    public function SegmentView(s:Segment, g:GardenView, c:uint, base_width:Number, getSegmentInfo:Function) {
        _s = s;
        _g = g;
        _c = c;
        _base_width = base_width;
        _getSegmentInfo = getSegmentInfo;

        addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);

        initHitArea();

        redraw();

        //initText();
    }

    public function destroy():void {
        removeEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
        removeEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
    }

    private function initText():void {
        _tf = new TextField();

        var center_location:Number = _s.center(_g.garden.MAX_SEGMENTS_LIST_VALUE);
        var center:Point = _g.natural2disp(_g.garden.location2point(center_location));
        var center_side:int = _g.garden.location2side(center_location);

        var dx:int = 0, dy:int = 0;
        switch (center_side) {
            case Garden.SIDE_LEFT: dx = -1; dy = 0; _tf.autoSize = TextFieldAutoSize.RIGHT; break;
            case Garden.SIDE_RIGHT: dx = 1; dy = 0; _tf.autoSize = TextFieldAutoSize.LEFT; break;
            case Garden.SIDE_TOP: dx = 0; dy = -1; _tf.autoSize = TextFieldAutoSize.CENTER; break;
            case Garden.SIDE_BOTTOM: dx = 0; dy = 1; _tf.autoSize = TextFieldAutoSize.CENTER; break;
        }

        addChild(_tf);
        _tf.defaultTextFormat = tFormat;
        _tf.selectable = false;
        _tf.mouseEnabled = false;
        _tf.embedFonts = true;

        _tf.x = center.x + dx * 8;
        _tf.y = center.y + dy * 10 - 8;

        _tf.text = _getSegmentInfo(_s.value).shortText;
    }

    private function initHitArea():void {
        hitArea = new Sprite();
        drawSegments(hitArea.graphics, 20, 0, 1);
        hitArea.visible = false;
        addChild(hitArea);
    }

    private function rollOverHandler(event:MouseEvent):void {
        state_over = true;
        redraw();
    }

    private function rollOutHandler(event:MouseEvent):void {
        state_over = false;
        redraw();
    }

    private function redraw():void {
        graphics.clear();

        var c:uint = /*state_over ? _light_c : */_c;
        var width:Number = state_over ? _base_width + 2 : _base_width;

        drawSegments(graphics, width, c, 1);

        if (_tf != null)
            _tf.setTextFormat(state_over ? tFormatOver : tFormat);

//        _g.long_info = _getSegmentInfo(_s.value).longText;
    }

    private function drawSegments(gr:Graphics, width:int, c:uint, a:Number):void {
        gr.lineStyle(width, c, a, false, "normal", CapsStyle.NONE, JointStyle.ROUND);

        var start:Point = _g.natural2disp(_g.garden.location2point(_s.start));
        var end:Point = _g.natural2disp(_g.garden.location2point(_s.end));

        gr.moveTo(start.x, start.y);

        var side1:int = _g.garden.location2side(_s.start);
        var side2:int = _g.garden.location2side(_s.end);

        if (side2 < side1)
            side2 += 4;
        if (side2 == side1 && _s.start > _s.end)
            side2 += 4;

        while (side1 != side2) {
            var point:Point = _g.natural2disp(_g.garden.sideEnd(side1 % 4));
            gr.lineTo(point.x, point.y);
            side1++;
        }

        gr.lineTo(end.x, end.y);
    }
}
}
