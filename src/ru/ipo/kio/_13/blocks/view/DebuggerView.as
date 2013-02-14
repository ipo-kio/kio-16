/**
 * Created with IntelliJ IDEA.
 * User: ilya
 * Date: 12.02.13
 * Time: 20:44
 */
package ru.ipo.kio._13.blocks.view {
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Matrix;

import ru.ipo.kio._13.blocks.model.Block;

import ru.ipo.kio._13.blocks.model.BlocksDebugger;
import ru.ipo.kio._13.blocks.model.BlocksField;
import ru.ipo.kio._13.blocks.model.FieldChangeEvent;
import ru.ipo.kio._13.blocks.parser.Command;

public class DebuggerView extends Sprite {

    private static const BLOCKS_LEFT:int = 40;
    private static const BLOCKS_TOP:int = 80;
    private static const BLOCK_WIDTH:int = 70;
    private static const BLOCK_HEIGHT:int = 34;

    private static const ANIMATION_STEPS:int = 30; //must be even

    [Embed(source="../resources/field.png")]
    public static const FIELD_CLS:Class;

    [Embed(source="../resources/block1.png")]
    public static const BLOCK_1_CLS:Class;
    public static const BLOCK_1_IMG:BitmapData = (new BLOCK_1_CLS).bitmapData;

    [Embed(source="../resources/block2.png")]
    public static const BLOCK_2_CLS:Class;
    public static const BLOCK_2_IMG:BitmapData = (new BLOCK_2_CLS).bitmapData;

    [Embed(source="../resources/block3.png")]
    public static const BLOCK_3_CLS:Class;
    public static const BLOCK_3_IMG:BitmapData = (new BLOCK_3_CLS).bitmapData;

    [Embed(source="../resources/block4.png")]
    public static const BLOCK_4_CLS:Class;
    public static const BLOCK_4_IMG:BitmapData = (new BLOCK_4_CLS).bitmapData;

    private var _dbg:BlocksDebugger;

    private var blocksLayer:Sprite = new Sprite();
    private var movingLayer:Sprite = new Sprite();

    private var animating:Boolean = false;
    private var animationStep:int = 0;
    private var animationAction:int;
    private var animationBlock:Block;
    private var animationX:int;
    private var animationColHeight:int;

    public function DebuggerView(dbg:BlocksDebugger) {
        _dbg = dbg;

        drawBackground();
        redrawField();
        redrawCrane();

        blocksLayer.x = BLOCKS_LEFT;
        blocksLayer.y = BLOCKS_TOP;
        addChild(blocksLayer);
        movingLayer.x = BLOCKS_LEFT;
        addChild(movingLayer);

        _dbg.addEventListener(FieldChangeEvent.FIELD_CHANGED, startAnimation);
    }

    private function startAnimation(event:FieldChangeEvent):void {
        if (animating)
            stopAnimation();

        if (! event.animationPhase) {
            redrawField();
            redrawCrane();
            return;
        }

        animating = true;
        animationStep = 0;
        animationAction = event.command;
        animationBlock = _dbg.currentField.takenBlock;
        animationX = _dbg.currentField.craneX;
        animationColHeight = _dbg.currentField.getColumn(animationX).length;

        addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function stopAnimation():void {
        removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
        animating = false;
        _dbg.animationFinished();
    }

    private function drawBackground():void {
        var bmp:BitmapData = (new FIELD_CLS).bitmapData;
        graphics.beginBitmapFill(bmp);
        graphics.drawRect(0, 0, bmp.width, bmp.height);
        graphics.endFill();
    }

    private function redrawField():void {
        var g:Graphics = blocksLayer.graphics;
        g.clear();
        var fld:BlocksField = _dbg.currentField;

        for (var col:int = 0; col < fld.cols; col ++) {
            var c:Array = fld.getColumn(col);
            for (var line:int = 0; line < c.length; line++) {
                var block:Block = c[line];
                drawBlock(g, BLOCK_WIDTH * col, BLOCK_HEIGHT * (fld.lines - line - 1), block.color);
            }
        }
    }

    private function redrawCrane():void {
        var fld:BlocksField = _dbg.currentField;
        drawCrane(fld.craneX, 0, fld.takenBlock);
    }

    private function drawCrane(x:Number, len:Number, block:Block = null):void {
        var g:Graphics = movingLayer.graphics;
        g.clear();
        g.beginFill(0x000000);
        g.drawRect(x * BLOCK_WIDTH + 10, 9, BLOCK_WIDTH - 20, 20);
        g.endFill();
        g.lineStyle(3, 0);
        g.moveTo((x + 0.5) * BLOCK_WIDTH, 25);
        var h:Number = 36 + len;
        g.lineTo((x + 0.5) * BLOCK_WIDTH, h);

        //horizontal
        g.lineStyle(4, 0);
        g.moveTo(x * BLOCK_WIDTH + 14, h);
        g.lineTo((x + 1) * BLOCK_WIDTH - 14, h);

        //two down lines
        g.lineStyle(2, 0);
        g.moveTo(x * BLOCK_WIDTH + 14, h);
        g.lineTo(x * BLOCK_WIDTH + 14, h + 12);

        g.moveTo((x + 1) * BLOCK_WIDTH - 14, h);
        g.lineTo((x + 1) * BLOCK_WIDTH - 14, h + 12);

        if (block == null)
            return;

        g.moveTo(x * BLOCK_WIDTH + 14 - 3, h + 12);
        g.lineTo(x * BLOCK_WIDTH + 14 + 3, h + 12);

        g.moveTo((x + 1) * BLOCK_WIDTH - 14 - 3, h + 12);
        g.lineTo((x + 1) * BLOCK_WIDTH - 14 + 3, h + 12);

        drawBlock(g, x * BLOCK_WIDTH, h + 4, block.color);
    }

    private static function drawBlock(g:Graphics, x:Number, y:Number, col:int):void {
        var bmp:BitmapData;
        switch (col) {
            case 1:
                bmp = BLOCK_1_IMG;
                break;
            case 2:
                bmp = BLOCK_2_IMG;
                break;
            case 3:
                bmp = BLOCK_3_IMG;
                break;
            case 4:
                bmp = BLOCK_4_IMG;
                break;
        }

        var m:Matrix = new Matrix();
        m.translate(x, y);
        g.lineStyle();
        g.beginBitmapFill(bmp, m);
        g.drawRect(x, y, bmp.width, bmp.height);
        g.endFill();
    }

    private function enterFrameHandler(event:Event):void {
        switch (animationAction) {
            case Command.LEFT:
                drawCrane(animationX - animationStep / ANIMATION_STEPS, 0, animationBlock);
                break;
            case Command.RIGHT:
                drawCrane(animationX + animationStep / ANIMATION_STEPS, 0, animationBlock);
                break;
            case Command.TAKE:
                var fld:BlocksField = _dbg.currentField;
                var height:Number = 40 + BLOCK_HEIGHT * (fld.lines - animationColHeight);
                if (animationStep < ANIMATION_STEPS / 2)
                    drawCrane(animationX, animationStep * 2 * height / ANIMATION_STEPS, null);
                else
                    drawCrane(animationX, (ANIMATION_STEPS - animationStep) * 2 * height / ANIMATION_STEPS, fld.takenBlock);
                if (animationStep == ANIMATION_STEPS / 2)
                    redrawField();
                break;
            case Command.PUT:
                fld = _dbg.currentField;
                height = 40 + BLOCK_HEIGHT * (fld.lines - animationColHeight - 1);
                if (animationStep < ANIMATION_STEPS / 2)
                    drawCrane(animationX, animationStep * 2 * height / ANIMATION_STEPS, animationBlock);
                else
                    drawCrane(animationX, (ANIMATION_STEPS - animationStep) * 2 * height / ANIMATION_STEPS, null);
                if (animationStep == ANIMATION_STEPS / 2)
                    redrawField();
                break;
        }

        animationStep ++;

        if (animationStep > ANIMATION_STEPS)
            stopAnimation();
    }
}
}