/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 01.02.13
 * Time: 22:27
 */
package ru.ipo.kio._13.cut.view {
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Matrix;

import mx.core.BitmapAsset;

import ru.ipo.kio._13.cut.model.FieldCords;

import ru.ipo.kio._13.cut.model.Piece;

import ru.ipo.kio._13.cut.model.PiecesField;

public class PiecesFieldViewSinglePieces extends PiecesFieldView {

    public static const MAX_PIECES:int = 100500; //as many as wanted

    private var highlightsLayer:Sprite = new Sprite();
    private var _previousX:int = -1;
    private var _previousY:int = -1;

    [Embed(source="../resources/CellHighlight.png")]
    private static const IMG_HIGHLIGHT_CLASS:Class;
    private static const IMG_HIGHLIGHT_BITMAP_DATA:BitmapData = BitmapAsset(new IMG_HIGHLIGHT_CLASS).bitmapData;

    public function PiecesFieldViewSinglePieces(field:PiecesField) {
        super(field);

        addChild(highlightsLayer);

        addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
        addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
        addEventListener(MouseEvent.CLICK, clickHandler);
    }

    private function mouseMoveHandler(event:MouseEvent):void {
        var x:int = screen2logicX(event.localX);
        var y:int = screen2logicY(event.localY);

        var normCords:Object = normalizeCords(x, y);
        x = normCords.x;
        y = normCords.y;

        if (x == _previousX && y == _previousY)
            return;

        _previousX = x;
        _previousY = y;

        var g:Graphics = highlightsLayer.graphics;
        g.clear();

        //test is it possible to switch a cell
        if (isEmpty(x, y) && _field.blocksCount >= MAX_PIECES)
            return;

        var gx:Number = logic2screenX(x);
        var gy:Number = logic2screenY(y);

        var m:Matrix = new Matrix();
        var w:int = IMG_HIGHLIGHT_BITMAP_DATA.width;
        var h:int = IMG_HIGHLIGHT_BITMAP_DATA.height;
        m.translate(gx + CELL_WIDTH / 2 - w / 2, gy - CELL_HEIGHT / 2 - h / 2);
        g.beginBitmapFill(IMG_HIGHLIGHT_BITMAP_DATA, m, false);
        g.drawRect(gx + CELL_WIDTH / 2 - w / 2, gy - CELL_HEIGHT / 2 - h / 2, w, h);
        g.endFill();
    }

    private function normalizeCords(x:int, y:int):Object {
        if (x >= _field.n)
            x = _field.n - 1;
        if (y >= _field.m)
            y = _field.m - 1;
        if (x < 0)
            x = 0;
        if (y < 0)
            y = 0;
        return {x: x, y: y};
    }

    private function isEmpty(x:int, y:int):Boolean {
        var blockType:int = _field.getBlockType(x, y);
        return blockType == PiecesField.BLOCK_EMPTY || blockType == PiecesField.BLOCK_INSIDE;
    }

    private function clickHandler(event:MouseEvent):void {
        var x:int = screen2logicX(event.localX);
        var y:int = screen2logicY(event.localY);

        var normCords:Object = normalizeCords(x, y);
        x = normCords.x;
        y = normCords.y;

        var piece:Piece;

        if (isEmpty(x, y)) {
            var zeroCords:FieldCords = new FieldCords(0, 0);
            if (_field.blocksCount >= MAX_PIECES)
                return;
            piece = new Piece([zeroCords]); //new one element piece
            piece.move(x, y);
            _field.addPiece(piece);
        } else {
            var cords:FieldCords = new FieldCords(x, y);
            //remove the piece
            for each (piece in _field.pieces)
                if (piece.blocks[0].equals(cords)) {
                    _field.removePiece(piece);
                    break;
                }
        }
    }

    private function rollOutHandler(event:MouseEvent):void {
        _previousX = -1;
        _previousY = -1;
        highlightsLayer.graphics.clear();
    }
}
}
