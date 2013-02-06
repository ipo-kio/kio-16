/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 25.01.13
 * Time: 16:13
 */
package ru.ipo.kio._13.cut.model {

import flash.events.Event;
import flash.events.EventDispatcher;

public class PiecesField extends EventDispatcher {

    public static const PIECES_CHANGED:String = 'pieces';

    public static const BLOCK_EMPTY:int = 0;
    public static const BLOCK_NORMAL:int = 1;
    public static const BLOCK_INSIDE:int = 2;
    public static const BLOCK_OUTSIDE:int = 3;

    private var _pieces:Array = [];
    private var _m:int;
    private var _n:int;
    private var _blocks:Array;
    private var _outline:Array;

    private var _blocksCount:int = 0;
    private var _hasInnerBlocks:Boolean = false;
    private var _hasOuterBlocks:Boolean = false;
    private var _thinPoly:Boolean = false;

    public function PiecesField(m:int, n:int) {
        _m = m;
        _n = n;

        piecesChanged();
    }

    public function get m():int {
        return _m;
    }

    public function get n():int {
        return _n;
    }

    public function get pieces():Array { //TODO return immutable collection
        return _pieces;
    }

    public function get outline():Array {
        return _outline;
    }

    public function get hasInnerBlocks():Boolean {
        return _hasInnerBlocks;
    }

    public function get hasOuterBlocks():Boolean {
        return _hasOuterBlocks;
    }

    public function get blocksCount():int {
        return _blocksCount;
    }

    public function get thinPoly():Boolean {
        return _thinPoly;
    }

    private function piecesChanged():void {
        evaluateBlocks();

        dispatchEvent(new Event(PIECES_CHANGED));
    }

    public function addPiece(piece:Piece):void {
        _pieces.push(piece);

        piecesChanged();
    }

    public function clearPieces():void {
        _pieces = [];

        piecesChanged();
    }

    public function removePiece(piece:Piece):void {
        var index:int = _pieces.indexOf(piece);
        _pieces.splice(index, 1);

        piecesChanged();
    }

    /**
     * @param blocks
     * @return array with outline, external blocks, empty internal blocks
     */
    public static function generateOutline(blocks:Array):Array {
        //find left most of the lowest
        if (blocks.length == 0)
            return [[], [], []];

        var leftLowest:FieldCords = blocks[0];

        for each (var fc:FieldCords in blocks)
            if (fc.y < leftLowest.y || fc.y == leftLowest.y && fc.x < leftLowest.x)
                leftLowest = fc;

        var outline:Array = [];
        var prev2:FieldCords = new FieldCords(leftLowest.x, leftLowest.y);
        var prev1:FieldCords = new FieldCords(leftLowest.x + 1, leftLowest.y);
        var start:FieldCords = prev2;
        outline.push(prev2);
        outline.push(prev1);

        do {
            var dx:int = prev1.x - prev2.x;
            var dy:int = prev1.y - prev2.y;
            var hasL:Boolean = hasBlock(blocks, prev1.x + Math.floor((dx - dy) / 2), prev1.y + Math.floor((dy + dx) / 2));
            var hasR:Boolean = hasBlock(blocks, prev1.x + Math.floor((dx + dy) / 2), prev1.y + Math.floor((dy - dx) / 2));

            var next:FieldCords;
            if (hasR)
                next = new FieldCords(prev1.x + dy, prev1.y - dx);
            else if (hasL)
                next = new FieldCords(prev1.x + dx, prev1.y + dy);
            else
                next = new FieldCords(prev1.x - dy, prev1.y + dx);

            //push new or substitute the last if the points are on one line
            if ((prev1.x - next.x) * (prev2.y - next.y) == (prev2.x - next.x) * (prev1.y - next.y))
                outline[outline.length - 1] = next;
            else
                outline.push(next);

            prev2 = prev1;
            prev1 = next;

        } while (next.x != start.x || next.y != start.y);

        //test that all are inside
        var externalBlocks:Array = [];
        for each (var block:FieldCords in blocks)
            if (! blockInsideOutline(block.x, block.y, outline))
                externalBlocks.push(block);

        //find all internal
        var internalBlocks:Array = [];

        var minX:int = blocks[0].x;
        var minY:int = blocks[0].y;
        var maxX:int = blocks[0].x;
        var maxY:int = blocks[0].y;
        for each (block in blocks) {
            if (block.x < minX)
                minX = block.x;
            if (block.x > maxX)
                maxX = block.x;
            if (block.y < minY)
                minY = block.y;
            if (block.y > maxY)
                maxY = block.y;
        }

        for (var x:int = minX; x <= maxX; x ++)
            for (var y:int = minY; y <= maxY; y ++)
                if (blockInsideOutline(x, y, outline) && ! hasBlock(blocks, x, y))
                    internalBlocks.push(new FieldCords(x, y));

        return [outline, externalBlocks, internalBlocks];
    }

    private static function blockInsideOutline(x:int, y:int, outline:Array):Boolean {
        var cnt:int = 0;
        for (var i:int = 0; i < outline.length - 1; i++)
            if (x < outline[i].x && (2 * outline[i].y - 2 * y - 1) * (2 * outline[i+1].y - 2 * y - 1) < 0)
                cnt ++;

        return cnt % 2 == 1;
    }

    private static function hasBlock(blocks:Array, x:int, y:int):Boolean {
        for each (var fc:FieldCords in blocks)
            if (fc.x == x && fc.y == y)
                return true;

        return false;
    }

    private function evaluateBlocks():void {
        var blocks:Array = new Array(_m);
        for (var i:int = 0; i < _m; i ++) {
            blocks[i] = new Array(_n);
            for (var j:int = 0; j < _n; j ++)
                blocks[i][j] = BLOCK_EMPTY;
        }

        var piecesBlocks:Array = [];
        for each (var piece:Piece in _pieces)
            for each (var block:FieldCords in piece.blocks)
                piecesBlocks.push(block);

        var outlineInfo:Array = generateOutline(piecesBlocks);

        _outline = outlineInfo[0];

        _blocksCount = piecesBlocks.length;

        for each (var normalBlock:FieldCords in piecesBlocks)
            blocks[normalBlock.y][normalBlock.x] = BLOCK_NORMAL;

        _hasOuterBlocks = outlineInfo[1].length > 0;
        for each (var externalBlock:FieldCords in outlineInfo[1])
            blocks[externalBlock.y][externalBlock.x] = BLOCK_OUTSIDE;

        _hasInnerBlocks = outlineInfo[2].length > 0;
        for each (var internalBlock:FieldCords in outlineInfo[2])
            blocks[internalBlock.y][internalBlock.x] = BLOCK_INSIDE;

        //test outline has same points
        _thinPoly = false;
        for (i = 1; i < outline.length; i++) //don't test the first point
            for (j = i + 1; j < outline.length; j++)
                if (outline[i].equals(outline[j]))
                    _thinPoly = true;

        _blocks = blocks;
    }

    public function getBlockType(x:int, y:int):int {
        if (x < 0 || x >= n || y < 0 || y >= m)
            return BLOCK_EMPTY;
        return _blocks[y][x];
    }
}
}
