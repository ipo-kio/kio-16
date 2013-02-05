/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 25.01.13
 * Time: 18:40
 */
package ru.ipo.kio._13.cut.view {
import flash.display.Graphics;
import flash.display.Sprite;
import flash.errors.IllegalOperationError;
import flash.events.Event;

import ru.ipo.kio._13.cut.model.Piece;

import ru.ipo.kio._13.cut.model.PiecesField;

public class PiecesFieldView extends Sprite {

    public static const CELL_WIDTH:int = 56;
    public static const CELL_HEIGHT:int = 56;

    private static const GRID_COLOR:uint = 0xAAAAAA;
    private static const GRID_ALPHA:Number = 0.7;
    private static const BG_COLOR:uint = 0xFFFFFF;
    private static const BLOCK_COLOR_NORMAL:uint = 0x00FF00;
    private static const BLOCK_COLOR_INSIDE:uint = 0xFFFFFF;
    private static const BLOCK_COLOR_OUTSIDE:uint = 0x00FF00;
    private static const CROSS_COLOR:uint = 0xFF0000;
    public static const OUTLINE_COLOR:uint = 0xFF0000;

    //layers:
    //           outlinesLayer  - outlines for pieces and for the polygon
    //           gridLayer      - grid
    //           squaresLayer   - squares and triangles
    //    PieceFieldView (this) - background

    protected var _field:PiecesField;
    private var _outlineView:OutlineView;

    private var gridLayer:Sprite = new Sprite();
    private var outlinesLayer:Sprite = new Sprite();
    private var squaresLayer:Sprite = new Sprite();

    private var _drawPicesOutines:Boolean = false;

    public function PiecesFieldView(field:PiecesField) {
        _field = field;
        _outlineView = new OutlineView(logic2screenX, logic2screenY);

        addChild(squaresLayer);
        addChild(gridLayer);
        addChild(outlinesLayer);

        drawBackground();
        drawGrid();

        _field.addEventListener(PiecesField.PIECES_CHANGED, redraw);
        redraw();
    }

    public function get drawPicesOutines():Boolean {
        return _drawPicesOutines;
    }

    public function set drawPicesOutines(value:Boolean):void {
        _drawPicesOutines = value;
    }

    private function drawGrid():void {
        var g:Graphics = gridLayer.graphics;
        var m:int = _field.m;
        var n:int = _field.n;

        g.lineStyle(1, GRID_COLOR, GRID_ALPHA);

        for (var j:int = 0; j <= _field.m; j++) {
            g.moveTo(0, j * CELL_HEIGHT);
            g.lineTo(n * CELL_WIDTH, j * CELL_HEIGHT);
        }

        for (var i:int = 0; i <= _field.m; i++) {
            g.moveTo(i * CELL_WIDTH, 0);
            g.lineTo(i * CELL_WIDTH, m * CELL_HEIGHT);
        }
    }

    private function drawBackground():void {
        graphics.beginFill(BG_COLOR);
        graphics.drawRect(0, 0, _field.n * CELL_WIDTH, _field.m * CELL_HEIGHT);
        graphics.endFill();
    }

    private function redraw(event:Event = null):void {
        var g:Graphics;

        //draw squares

        g = squaresLayer.graphics;

        g.clear();

        for (var x:int = 0; x < _field.n; x ++)
            for (var y:int = 0; y < _field.m; y ++) {
                var type:int = _field.getBlockType(x, y);
                var needCross:Boolean = false;
                switch (type) {
                    case PiecesField.BLOCK_EMPTY:
                        continue;
                    case PiecesField.BLOCK_NORMAL:
                        g.beginFill(BLOCK_COLOR_NORMAL);
                        break;
                    case PiecesField.BLOCK_INSIDE:
                        g.beginFill(BLOCK_COLOR_INSIDE);
                        needCross = true;
                        break;
                    case PiecesField.BLOCK_OUTSIDE:
                        g.beginFill(BLOCK_COLOR_OUTSIDE);
                        needCross = true;
                        break;
                    default:
                        throw IllegalOperationError("It is impossible to draw a block of unknown type");
                }

                var screenX:Number = logic2screenX(x);
                var screenY:Number = logic2screenY(y);
                g.drawRect(screenX, screenY - CELL_HEIGHT, CELL_WIDTH, CELL_HEIGHT);
                g.endFill();

                if (needCross) {
                    g.lineStyle(2, CROSS_COLOR);
                    var cross:int = 4;
                    g.moveTo(screenX + CELL_WIDTH / 2 - cross, screenY - CELL_HEIGHT / 2 - cross);
                    g.lineTo(screenX + CELL_WIDTH / 2 + cross, screenY - CELL_HEIGHT / 2 + cross);
                    g.moveTo(screenX + CELL_WIDTH / 2 - cross, screenY - CELL_HEIGHT / 2 + cross);
                    g.lineTo(screenX + CELL_WIDTH / 2 + cross, screenY - CELL_HEIGHT / 2 - cross);
                    g.lineStyle();
                }
            }

        //draw outlines

        g = outlinesLayer.graphics;

        g.clear();

        //draw pieces outlines

        if (_drawPicesOutines)
            for each (var piece:Piece in _field.pieces)
                _outlineView.drawOutline(g, piece.outline, 2, GRID_COLOR, 1, piece.x, piece.y);

        _outlineView.drawOutline(g, _field.outline, 2, OUTLINE_COLOR);
    }

    public function logic2screenX(x:int):Number {
        return CELL_WIDTH * x;
    }

    public function logic2screenY(y:int):Number {
        return CELL_HEIGHT * (_field.m - y);
    }

    public function screen2logicX(x:Number):int {
        return x / CELL_WIDTH;
    }
    public function screen2logicY(y:Number):int {
        return _field.m - y / CELL_HEIGHT;
    }
}
}
