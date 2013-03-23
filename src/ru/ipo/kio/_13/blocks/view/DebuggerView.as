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
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import mx.core.BitmapAsset;

import ru.ipo.kio._13.blocks.BlocksWorkspace;

import ru.ipo.kio._13.blocks.model.Block;

import ru.ipo.kio._13.blocks.model.BlocksDebugger;
import ru.ipo.kio._13.blocks.model.BlocksField;
import ru.ipo.kio._13.blocks.model.FieldChangeEvent;
import ru.ipo.kio._13.blocks.parser.Command;

public class DebuggerView extends Sprite {

    private static var BLOCKS_LEFT:int = 40;
    private static const BLOCKS_TOP:int = 80;
    private static const BLOCK_WIDTH:int = 70;
    private static const BLOCK_HEIGHT:int = 34;

    private static const ANIMATION_STEPS:int = 30; //must be even

    [Embed(source="../resources/block1.png")]
    public static const BLOCK_1_CLS:Class;
    public static const BLOCK_1_IMG:BitmapData = (new BLOCK_1_CLS as BitmapAsset).bitmapData;

    [Embed(source="../resources/block2.png")]
    public static const BLOCK_2_CLS:Class;
    public static const BLOCK_2_IMG:BitmapData = (new BLOCK_2_CLS as BitmapAsset).bitmapData;

    [Embed(source="../resources/block3.png")]
    public static const BLOCK_3_CLS:Class;
    public static const BLOCK_3_IMG:BitmapData = (new BLOCK_3_CLS as BitmapAsset).bitmapData;

    [Embed(source="../resources/block4.png")]
    public static const BLOCK_4_CLS:Class;
    public static const BLOCK_4_IMG:BitmapData = (new BLOCK_4_CLS as BitmapAsset).bitmapData;

    [Embed(source="../resources/crane.png")]
    public static const CRANE_CLS:Class;
    public static const CRANE_IMG:BitmapData = (new CRANE_CLS as BitmapAsset).bitmapData;

    private var _dbg:BlocksDebugger;

    private var blocksLayer:Sprite = new Sprite();
    private var movingLayer:Sprite = new Sprite();

    private var animating:Boolean = false;
    private var animationStep:int = 0;
    private var animationAction:int;
    private var animationBlock:Block;
    private var animationX:int;
    private var animationColHeight:int;

    private var manualRegime:Boolean = false;
    private var manualField:BlocksField;

    private var blocksCountFailField:TextField;
    private var _workspace:BlocksWorkspace;

    public function DebuggerView(dbg:BlocksDebugger, workspace: BlocksWorkspace) {
        _dbg = dbg;
        _workspace = workspace;

        if (_workspace.api.problem.level == 0)
            BLOCKS_LEFT += 2 * BLOCK_WIDTH;

        drawBackground();
        redrawField();
        redrawCrane();

        blocksLayer.x = BLOCKS_LEFT;
        blocksLayer.y = BLOCKS_TOP;
        addChild(blocksLayer);
        movingLayer.x = BLOCKS_LEFT;
        addChild(movingLayer);

        _dbg.addEventListener(FieldChangeEvent.FIELD_CHANGED, startAnimation);
        workspace.addEventListener(BlocksWorkspace.MANUAL_REGIME_EVENT, manualRegimeChangeHandler);
        workspace.editor.addEventListener(FieldChangeEvent.FIELD_CHANGED, startAnimation); //fired in manual regime

        createBlocksCountFailField();
    }

    private function getField():BlocksField {
        return manualRegime ? manualField : _dbg.currentField;
    }

    private function startAnimation(event:FieldChangeEvent):void {
        if (animating)
            stopAnimation();

        var blocksCountFail:String = _dbg.validateFieldBlocks();
        if (blocksCountFail == null) {
            blocksCountFailField.visible = false;
        } else {
            blocksCountFailField.text = blocksCountFail;
            blocksCountFailField.visible = true;
        }

        if (!event.animationPhase) {
            redrawField();
            redrawCrane();
            return;
        }

        animating = true;
        animationStep = 0;
        animationAction = event.command;
        animationBlock = getField().takenBlock;
        animationX = getField().craneX;
        animationColHeight = getField().getColumn(animationX).length;

        if (manualRegime)
            try {
                var manualCommand:Command = new Command(event.command, -1);
                manualCommand.execute(getField());
            } catch (e:Error) {
                stopAnimation();
                return;
            }

        addEventListener(Event.ENTER_FRAME, enterFrameHandler);
    }

    private function stopAnimation():void {
        removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
        animating = false;
        _dbg.animationFinished();
    }

    private function drawBackground():void {
        graphics.lineStyle(1, 0x888888, 0.5);
        for (var j:int = 0; j <= getField().cols; j++) {
            graphics.moveTo(BLOCKS_LEFT + j * BLOCK_WIDTH, BLOCKS_TOP);
            graphics.lineTo(BLOCKS_LEFT + j * BLOCK_WIDTH, BLOCKS_TOP + getField().lines * BLOCK_HEIGHT);
        }
        for (var i:int = 0; i <= getField().lines; i++) {
            graphics.moveTo(BLOCKS_LEFT, BLOCKS_TOP + i * BLOCK_HEIGHT);
            graphics.lineTo(BLOCKS_LEFT + getField().cols * BLOCK_WIDTH, BLOCKS_TOP + i * BLOCK_HEIGHT);
        }
    }

    private function redrawField():void {
        var g:Graphics = blocksLayer.graphics;
        g.clear();
        var fld:BlocksField = getField();

        for (var col:int = 0; col < fld.cols; col++) {
            var c:Array = fld.getColumn(col);
            for (var line:int = 0; line < c.length; line++) {
                var block:Block = c[line];
                drawBlock(g, BLOCK_WIDTH * col, BLOCK_HEIGHT * (fld.lines - line - 1), block.color);
            }
        }
    }

    private function redrawCrane():void {
        var fld:BlocksField = getField();
        drawCrane(fld.craneX, 0, fld.takenBlock);
    }

    private function drawCrane(x:Number, len:Number, block:Block = null):void {
        var g:Graphics = movingLayer.graphics;
        g.clear();

        var x0:Number = x * BLOCK_WIDTH + (BLOCK_WIDTH - CRANE_IMG.width) / 2;
        var y0:Number = 9;
        var m:Matrix = new Matrix();
        m.translate(x0, y0);
        g.beginBitmapFill(CRANE_IMG, m);
        g.drawRect(x0, y0, CRANE_IMG.width, CRANE_IMG.height);
        g.endFill();

        //two down lines
        var h0:int = 36;
        var h:int = h0 + len;

        g.lineStyle(2, 0x4b4b4b);
        g.moveTo(x * BLOCK_WIDTH + 14, h0 - 2);
        g.lineTo(x * BLOCK_WIDTH + 14, h + 12);

        g.moveTo((x + 1) * BLOCK_WIDTH - 14, h0 - 2);
        g.lineTo((x + 1) * BLOCK_WIDTH - 14, h + 12);

        var capture:int = block == null ? 1 : 3;

        g.moveTo(x * BLOCK_WIDTH + 14 - capture, h + 12);
        g.lineTo(x * BLOCK_WIDTH + 14 + capture, h + 12);

        g.moveTo((x + 1) * BLOCK_WIDTH - 14 - capture, h + 12);
        g.lineTo((x + 1) * BLOCK_WIDTH - 14 + capture, h + 12);

        if (block != null)
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
                var fld:BlocksField = getField();
                var height:Number = 40 + BLOCK_HEIGHT * (fld.lines - animationColHeight);
                if (animationStep < ANIMATION_STEPS / 2)
                    drawCrane(animationX, animationStep * 2 * height / ANIMATION_STEPS, null);
                else
                    drawCrane(animationX, (ANIMATION_STEPS - animationStep) * 2 * height / ANIMATION_STEPS, fld.takenBlock);
                if (animationStep == ANIMATION_STEPS / 2)
                    redrawField();
                break;
            case Command.PUT:
                fld = getField();
                height = 40 + BLOCK_HEIGHT * (fld.lines - animationColHeight - 1);
                if (animationStep < ANIMATION_STEPS / 2)
                    drawCrane(animationX, animationStep * 2 * height / ANIMATION_STEPS, animationBlock);
                else
                    drawCrane(animationX, (ANIMATION_STEPS - animationStep) * 2 * height / ANIMATION_STEPS, null);
                if (animationStep == ANIMATION_STEPS / 2)
                    redrawField();
                break;
        }

        animationStep++;

        if (animationStep > ANIMATION_STEPS)
            stopAnimation();
    }

    private function startManualRegime(field:BlocksField):void {
        manualField = field;
        manualRegime = true;

        redrawField();
        redrawCrane();
    }

    private function stopManualRegime():void {
        manualRegime = false;

        stopAnimation();
    }

    private function manualRegimeChangeHandler(event:Event):void {
        if (_workspace.manualRegime)
            startManualRegime(_dbg.currentField.clone());
        else
            stopManualRegime();
    }

    private function createBlocksCountFailField():void {
        blocksCountFailField = new TextField();
        blocksCountFailField.selectable = false;
        blocksCountFailField.embedFonts = true;
        blocksCountFailField.defaultTextFormat = new TextFormat('KioArial', 20, 0xFF0000, true);
        blocksCountFailField.autoSize = TextFieldAutoSize.CENTER;
        blocksCountFailField.x = 780 / 2;
        blocksCountFailField.y = 40;
        blocksCountFailField.background = true;
        blocksCountFailField.backgroundColor = 0xFFFFFF;
        blocksCountFailField.border = true;
        blocksCountFailField.borderColor = 0x000000;
        blocksCountFailField.visible = false;

        addChild(blocksCountFailField);
    }
}
}