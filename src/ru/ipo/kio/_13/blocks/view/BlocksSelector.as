/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 15.02.13
 * Time: 17:15
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._13.blocks.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._13.blocks.BlocksProblem;

import ru.ipo.kio._13.blocks.model.Block;

import ru.ipo.kio._13.blocks.model.BlocksField;
import ru.ipo.kio.api.KioApi;

public class BlocksSelector extends Sprite {

    private const COLORS:Array = [
        0,
        0x2ebe0c,//0x00a859,
        0xf80d25,
        0x0d4eba,
        0xffb628
    ];

    private const BLOCK_WIDTH:int = 30;
    private const BLOCK_HEIGHT:int = 21;

    private var _field:BlocksField;
    private var _maxCols:int;

    private static const api:KioApi = KioApi.instance(BlocksProblem.ID);

    public function BlocksSelector(lines:int, cols:int, boundaryX:int, maxCols:int) {
        var blocks:Array = [];
        for (var i:int = 0; i < cols; i++)
            blocks.push([]);
        _field = new BlocksField(lines, cols, blocks, boundaryX, 0);

        _maxCols = maxCols;

        redraw();

        if (api.problem.level == 2) //allow click only for the second level
            addEventListener(MouseEvent.CLICK, clickHandler);
    }

    public function redraw():void {
        graphics.clear();
        graphics.lineStyle(1, 0);
        graphics.beginFill(0xFFFFFF, 0.01);
        graphics.drawRect(0, 0, _field.cols * BLOCK_WIDTH, _field.lines * BLOCK_HEIGHT);
        graphics.endFill();

        for (var j:int = 1; j < _field.cols; j++) {
            if (j == _field.boundary)
                graphics.lineStyle(1, 0, 0.5);
            else
                graphics.lineStyle(1, 0x888888, 0.4);
            graphics.moveTo(j * BLOCK_WIDTH, 0);
            graphics.lineTo(j * BLOCK_WIDTH, _field.lines * BLOCK_HEIGHT);
        }
        for (var i:int = 1; i < field.lines; i++) {
            graphics.moveTo(0, i * BLOCK_HEIGHT);
            graphics.lineTo(_field.cols * BLOCK_WIDTH, i * BLOCK_HEIGHT);
        }

        graphics.lineStyle(1, 0x222222, 0.7);

        for (var c:int = 0; c < _field.cols; c++) {
            var col:Array = _field.getColumn(c);
            var line:int = 0;
            for each (var block:Block in col) {
                graphics.beginFill(COLORS[block.color]);
                graphics.drawRect(c * BLOCK_WIDTH + 2, (_field.lines - line - 1) * BLOCK_HEIGHT + 2, BLOCK_WIDTH - 4, BLOCK_HEIGHT - 4);
                graphics.endFill();
                line++;
            }
        }
    }

    public function get field():BlocksField {
        return _field;
    }

    public function set field(value:BlocksField):void {
        _field = value;

        dispatchEvent(new Event(Event.CHANGE));
        redraw();
    }

    private function clickHandler(event:MouseEvent):void {
        var line:int = _field.lines - int(event.localY / BLOCK_HEIGHT) - 1;

        if (line < 0 || line >= _field.lines)
            return;

        var col:int = event.localX / BLOCK_WIDTH;

        if (col < 0 || col >= _field.cols)
            return;

        var column:Array = _field.getColumn(col);

        var b:Block;

        if (line < column.length)
            b = column[line];
        else if (line == column.length) {
            b = new Block(0);
            column.push(b);
        } else
            return;

        api.log('change block @bb', col, line);

        do {
            b.color += 1;
            if (b.color > _maxCols)
                b.color = 0;

            if (b.color == 0)
                if (line < column.length - 1)
                    b.color = 1;
                else {
                    column.pop();
                    break;
                }
        } while (b.isFromLeftToRight != col < _field.boundary);

        dispatchEvent(new Event(Event.CHANGE));
        api.autoSaveSolution();
        redraw();
    }
}
}
