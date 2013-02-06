/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 26.01.13
 * Time: 18:56
 */
package ru.ipo.kio._13.cut.view {
import flash.display.Graphics;
import flash.display.GraphicsPathCommand;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

import pl.bmnet.gpcas.geometry.Poly;

import ru.ipo.kio._13.cut.model.ColoredPoly;
import ru.ipo.kio._13.cut.model.Cut;
import ru.ipo.kio._13.cut.model.CutsField;

public class CutsFieldView extends Sprite {

    public static const SCALE:int = 8; //how many elements are in the unit of the pieces field

    private static const GRID_COLOR:uint = 0xAAAAAA;
    private static const GRID_ALPHA:Number = 0.5;
    private static const BACKGROUND_COLOR:uint = 0xFFFFFF;
    private static const COLOR_TRUE:uint = 0xFFCC33;
    private static const COLOR_FALSE:uint = 0x3399FF;
    private static const COLOR_NON_NORMAL:uint = 0xFF0000;

    private var _field: CutsField;
    private var _m: int;
    private var _n: int;

    private const gridLayer:Sprite = new Sprite();
    private const highlightLayer:Sprite = new Sprite();
    private const cutsLayer:Sprite = new Sprite();
    private const polygonsLayer:Sprite = new Sprite();

    //all cuts
    //highlight layer
    //grid layer
    //all polygons
    //this - background
    //layers

    public function CutsFieldView(m:int, n:int, field:CutsField) {
        this._field = field;
        this._m = m;
        this._n = n;

        addChild(polygonsLayer);
        addChild(gridLayer);
        addChild(highlightLayer);
        addChild(cutsLayer);

        drawBackground();
        drawGrid();

        putCutPoints();
        update();

        if (_field != null) //TODO code duplication with set field
            _field.addEventListener(CutsField.CUTS_CHANGED, cutsChanged);

        addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
        addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
    }

    private var prevHighlightPoly:ColoredPoly = null;
    private function mouseMoveHandler(event:MouseEvent):void {
        var x:Number = screen2logicX(event.localX, false);
        var y:Number = screen2logicY(event.localY, false);
        var g:Graphics = highlightLayer.graphics;

        for each (var poly:ColoredPoly in _field.polygons)
            if (poly.poly.isPointInside(new Point(x, y))) {
                if (poly == prevHighlightPoly)
                    return;
                g.clear();
                drawPoly(g, poly.poly, 0x00FF00, 0.3);
                prevHighlightPoly = poly;
                return;
            }

        prevHighlightPoly = null;
        g.clear();
    }

    private function removedFromStage(event:Event):void {
        _field.destroy();
    }

    private function drawGrid():void {
        var g: Graphics = gridLayer.graphics;

        for (var j:int = 0; j <= _m * SCALE; j++) {
            g.lineStyle(j % SCALE == 0 ? 2 : 1, GRID_COLOR, GRID_ALPHA);
            g.moveTo(0, j * PiecesFieldView.CELL_HEIGHT / SCALE);
            g.lineTo(PiecesFieldView.CELL_WIDTH * _n, j * PiecesFieldView.CELL_HEIGHT / SCALE);
        }

        for (var i:int = 0; i <= _n * SCALE; i++) {
            g.lineStyle(i % SCALE == 0 ? 2 : 1, GRID_COLOR, GRID_ALPHA);
            g.moveTo(i * PiecesFieldView.CELL_WIDTH / SCALE, 0);
            g.lineTo(i * PiecesFieldView.CELL_HEIGHT / SCALE, PiecesFieldView.CELL_HEIGHT * _m);
        }

        var ov:OutlineView = new OutlineView(logic2screenX, logic2screenY);
        ov.drawPoly(g, _field.poly, 2, PiecesFieldView.OUTLINE_COLOR);
    }

    private function drawBackground():void {
        graphics.beginFill(BACKGROUND_COLOR);
        graphics.drawRect(0, 0, _n * PiecesFieldView.CELL_WIDTH, _m * PiecesFieldView.CELL_HEIGHT);
        graphics.endFill();
    }

    private function putCutPoints():void {
        for each (var cut:Cut in _field.cuts) {
            var point1:CutPoint = new CutPoint(this, cut, 1);
            var point2:CutPoint = new CutPoint(this, cut, 2);
            cutsLayer.addChild(point1);
            cutsLayer.addChild(point2);
        }
    }

    public function set field(value:CutsField):void {
        if (_field != null)
            _field.removeEventListener(CutsField.CUTS_CHANGED, cutsChanged);

        _field = value;

        if (_field != null)
            _field.addEventListener(CutsField.CUTS_CHANGED, cutsChanged);

        update();
    }

    private function cutsChanged(event:Event):void {
        update();
    }

    private function update():void {
        var g:Graphics = cutsLayer.graphics;

//        while (cutsLayer.numChildren > 0) //remove all points
//            cutsLayer.removeChildAt(0);

        g.clear();
        g.lineStyle(1, 0x000000);
        for each (var cut:Cut in _field.cuts)
            drawCut(g, cut);

        g = polygonsLayer.graphics;
        g.clear();
        for each (var poly:ColoredPoly in _field.polygons) {
            var color:uint = poly.color ? COLOR_TRUE : COLOR_FALSE;
            if (! poly.isNormal /*|| poly.poly.getNumPoints() <= 3*/)
                color = COLOR_NON_NORMAL;
            drawPoly(g, poly.poly, color);
        }
    }

    private function drawPoly(g:Graphics, poly:Poly, color:uint, alpha:Number = 1):void {
        var commands:Vector.<int> = new Vector.<int>();
        var cords:Vector.<Number> = new Vector.<Number>();
        var n:int = poly.getNumPoints();

        commands.push(GraphicsPathCommand.MOVE_TO);
        var lastPoint:Point = poly.getPoint(n - 1);
        cords.push(logic2screenX(lastPoint.x));
        cords.push(logic2screenY(lastPoint.y));

        for (var i:int = 0; i < n; i++) {
            commands.push(GraphicsPathCommand.LINE_TO);
            var p:Point = poly.getPoint(i);
            cords.push(logic2screenX(p.x));
            cords.push(logic2screenY(p.y));
        }

        g.beginFill(color, alpha);
        g.drawPath(commands, cords);
        g.endFill();
    }

    public function drawCut(g:Graphics, cut:Cut):void {

        var xMax:int = _n * CutsFieldView.SCALE;
        var yMax:int = _m * CutsFieldView.SCALE;

        var segment:Array = cut.intersectWith(xMax, yMax);

        if (segment == null)
            return;

        g.moveTo(logic2screenX(segment[0].x), logic2screenY(segment[0].y));
        g.lineTo(logic2screenX(segment[1].x), logic2screenY(segment[1].y));
    }

    public function logic2screenX(x:Number):Number {
        return PiecesFieldView.CELL_WIDTH * x / SCALE;
    }

    public function logic2screenY(y:Number):Number {
        return PiecesFieldView.CELL_HEIGHT * (_m * SCALE - y) / SCALE;
    }

    public function screen2logicX(x:Number, round:Boolean = true):Number {
        var lx:Number = x * SCALE / PiecesFieldView.CELL_WIDTH;
        if (round)
            lx = Math.round(lx);

        if (lx < 0)
            lx = 0;
        if (lx > _n * SCALE)
            lx = _n * SCALE;
        return lx;
    }

    public function screen2logicY(y:Number, round:Boolean = true):Number {
        var ly:int = _m * SCALE - y * SCALE / PiecesFieldView.CELL_HEIGHT;
        if (round)
            ly = Math.round(ly);

        if (ly < 0)
            ly = 0;
        if (ly > _m * SCALE)
            ly = _m * SCALE;
        return ly;
    }
}
}