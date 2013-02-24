/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 09.02.13
 * Time: 1:02
 */
package ru.ipo.kio._13.blocks.model {

import flash.events.Event;
import flash.events.EventDispatcher;

import ru.ipo.kio._13.blocks.BlocksProblem;

import ru.ipo.kio._13.blocks.parser.Executor;
import ru.ipo.kio.api.KioApi;

public class BlocksField extends EventDispatcher implements Executor {

    public static const MOVE_EVENT:String = 'move event';

    private var loc:Object = KioApi.getLocalization(BlocksProblem.ID);

    private var _lines:int;
    private var _cols:int;
    private var _craneX:int;
    private var _blocks:Array; //array of arrays (columns) with blocks
    private var _takenBlock:Block;
    private var _boundary:int;

    private var _lastStepHadPenalty:Boolean = false;

    public function BlocksField(lines:int, cols:int, blocks:Array, boundary:int, craneX:int) {
        _lines = lines;
        _cols = cols;
        _blocks = blocks;
        _boundary = boundary;
        _craneX = craneX;
    }

    public function clone():BlocksField {
        //deep copy blocks array
        var blocks:Array = [];
        for each (var col:Array in _blocks) {
            var a:Array = [];
            for each (var block:Block in col)
                a.push(new Block(block.color));
            blocks.push(a);
        }

        return new BlocksField(_lines, _cols, blocks, _boundary, _craneX);
    }

    public function get lines():int {
        return _lines;
    }

    public function get cols():int {
        return _cols;
    }

    public function get craneX():int {
        return _craneX;
    }

    public function get takenBlock():Block {
        return _takenBlock;
    }

    public function getColumn(col:int):Array { //array of blocks from top to bottom
        return _blocks[col];
    }

    public function get boundary():int {
        return _boundary;
    }

    public function mayLeft():String {
        if (_craneX == 0)
            return loc.exec_errors.no_left;
        return null;
    }

    public function left():void {
        if (mayLeft() != null)
            return;

        _craneX--;

        _lastStepHadPenalty = false;

        dispatchEvent(new Event(MOVE_EVENT));
    }

    public function mayRight():String {
        if (_craneX == _cols - 1)
            return loc.exec_errors.no_right;
        return null;
    }

    public function right():void {
        if (mayRight() != null)
            return;

        _craneX++;

        _lastStepHadPenalty = false;

        dispatchEvent(new Event(MOVE_EVENT));
    }

    public function mayTake():String {
        if (_takenBlock != null)
            return loc.exec_errors.occupied;

        var col:Array = getColumn(_craneX);
        if (col.length == 0)
            return loc.exec_errors.nothing_to_take;

        return null;
    }

    public function take():void {
        if (mayTake() != null)
            return;

        var col:Array = getColumn(_craneX);

        _takenBlock = col.pop();

        _lastStepHadPenalty = col.length > 0 && !col[col.length - 1].mayBeUnder(_takenBlock);

        dispatchEvent(new Event(MOVE_EVENT));
    }

    public function mayPut():String {
        if (_takenBlock == null)
            return loc.exec_errors.not_occupied;

        //noinspection JSMismatchedCollectionQueryUpdate
        var col:Array = getColumn(_craneX);

        var numInCol:int = col.length;

        if (numInCol >= _lines)
            return loc.exec_errors.nowhere_to_put;

//        if (numInCol > 0 && !col[numInCol - 1].mayBeUnder(_takenBlock))
//            return loc.exec_errors.forbidden_order;

        return null;
    }

    public function put():void {
        if (mayPut() != null)
            return;

        var col:Array = getColumn(_craneX);

        _lastStepHadPenalty = col.length > 0 && !col[col.length - 1].mayBeUnder(_takenBlock);

        col.push(_takenBlock);
        _takenBlock = null;

        dispatchEvent(new Event(MOVE_EVENT));
    }

    public function get lastStepHadPenalty():Boolean {
        return _lastStepHadPenalty;
    }

    public function get blocksInPlace():int {
        var res:int = 0;
        var colInd:int = 0;
        for each (var col:Array in _blocks) {
            for each (var block:Block in col)
                if (block.isFromLeftToRight != colInd < boundary)
                    res++;
            colInd ++;
        }
        return res;
    }

    public function save():Array {
        var data:Array = [];

        for (var col:int = 0; col < cols; col ++) {
            var column:Array = [];
            for each (var block:Block in getColumn(col))
                column.push(block.color);
            data.push(column);
        }

        return data;
    }

    public function load(data:Array):void {
        _blocks = [];
        for each (var column:Array in data) {
            var col:Array = [];

            for each (var color:int in column)
                col.push(new Block(color));

            _blocks.push(col);
        }
    }
}
}