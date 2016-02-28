package ru.ipo.kio._16.mower.view {
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Point;

import ru.ipo.kio._16.mower.model.Field;

public class CellsDrawer {

    public static const SIZE_BIG:int = 0;
    public static const SIZE_SMALL:int = 1;
    
    public static const BIG_LENGTH:Number = 30;
    public static const SMALL_LENGTH:Number = 25;
    public static const SIGN_SELECTION_SIZE:Number = 13;

    public static const SIGN_SIZE:Number = 8;

    public static function size2length(size:int):Number {
        return size == SIZE_BIG ? BIG_LENGTH : SMALL_LENGTH;
    }
    
    public static function drawCell(g:Graphics, i:int, j:int, typ:int, size:int/*, highlight:Boolean = false*/):void {
        var length:Number = size2length(size);

        var x0:Number = j * length;
        var y0:Number = i * length;

        x0 += (length - 25) / 2;
        y0 += (length - 25) / 2;

        var m:Matrix = new Matrix();
        m.translate(x0, y0);
        var bmp:BitmapData = null;

        switch (typ) {
            case Field.FIELD_GRASS:
            case Field.FIELD_PROGRAM_GRASS:
                bmp = GRASS_BMP;
                break;
            case Field.FIELD_GRASS_MOWED:
            case Field.FIELD_PROGRAM_MOWED_GRASS:
                bmp = MOWED_GRASS_BMP;
                break;
            case Field.FIELD_TREE:
            case Field.FIELD_PROGRAM_TREE:
                bmp = TREE_BMP;
                break;
            case Field.FIELD_SWAMP:
                //do nothing
                break;
            case Field.FIELD_PROGRAM_SWAMP:
                bmp = SWAMP_BMP;
                break;
            case Field.FIELD_PROGRAM_MOWER:
                bmp = MOWER_BMP;
                break;
            case Field.FIELD_TURN_LEFT:
                bmp = ARROW_LEFT_BMP;
                break;
            case Field.FIELD_TURN_RIGHT:
                bmp = ARROW_RIGHT_BMP;
                break;
            case Field.FIELD_FORWARD:
                bmp = ARROW_TOP_BMP;
                break;
            case Field.FIELD_NOP:
                g.drawCircle(x0 + length / 2, y0 + length / 2, 4);
                break;
        }

        if (bmp != null) {
            if (size == SIZE_SMALL)
                g.lineStyle(1, 0x000000);
            else
                g.lineStyle();
            g.beginBitmapFill(bmp, m);
            g.drawRect(x0, y0, bmp.width, bmp.height);
            g.endFill();
        }
    }

    public static function position2point(i:Number, j:Number, size:int = SIZE_SMALL):Point {
        var length:Number = size2length(size);

        var x0:Number = j * length;
        var y0:Number = i * length;

        return new Point(x0, y0);
    }

    public static function drawSymbol(g:Graphics, i:Number, j:Number, typ:int, size:int = SIZE_BIG):void {
        var p:Point = position2point(i, j, size);
        var x0:Number = p.x;
        var y0:Number = p.y;
        g.lineStyle(1, 0);

        x0 += (SIGN_SELECTION_SIZE - SIGN_SIZE) / 2;
        y0 += (SIGN_SELECTION_SIZE - SIGN_SIZE) / 2;

        switch (typ) {
            case 1: //blue circle
                g.beginFill(0x0000FF);
                g.drawCircle(x0 + SIGN_SIZE / 2, y0 + SIGN_SIZE / 2, SIGN_SIZE / 2);
                g.endFill();
                break;
            case 2: //red triangle
                g.beginFill(0xFF0000);
                g.moveTo(x0 + SIGN_SIZE / 2, y0);
                g.lineTo(x0 + SIGN_SIZE, y0 + SIGN_SIZE);
                g.lineTo(x0, y0 + SIGN_SIZE);
                g.endFill();
                break;
            case 3: //green square
                g.beginFill(0x00FF00);
                g.drawRect(x0, y0, SIGN_SIZE, SIGN_SIZE);
                g.endFill();
                break;
        }
    }

    //embed images
    [Embed(source="../res/cells/25-derevo.png")]
    public static const TREE_CLASS:Class;
    public static const TREE_BMP:BitmapData = (new TREE_CLASS).bitmapData;

    [Embed(source="../res/cells/25-kosilka-3.png")]
    public static const MOWER_CLASS:Class;
    public static const MOWER_BMP:BitmapData = (new MOWER_CLASS).bitmapData;

    [Embed(source="../res/cells/25-kosilka-4.png")]
    public static const BROKEN_MOWER_CLASS:Class;
    public static const BROKEN_MOWER_BMP:BitmapData = (new BROKEN_MOWER_CLASS).bitmapData;

    [Embed(source="../res/cells/25-skos.png")]
    public static const MOWED_GRASS_CLASS:Class;
    public static const MOWED_GRASS_BMP:BitmapData = (new MOWED_GRASS_CLASS).bitmapData;

    [Embed(source="../res/cells/25-trava.png")]
    public static const GRASS_CLASS:Class;
    public static const GRASS_BMP:BitmapData = (new GRASS_CLASS).bitmapData;

    [Embed(source="../res/cells/25-swamp.png")]
    public static const SWAMP_CLASS:Class;
    public static const SWAMP_BMP:BitmapData = (new SWAMP_CLASS).bitmapData;

    [Embed(source="../res/cells/25-arrow-left.png")]
    public static const ARROW_LEFT_CLASS:Class;
    public static const ARROW_LEFT_BMP:BitmapData = (new ARROW_LEFT_CLASS).bitmapData;

    [Embed(source="../res/cells/25-arrow-right.png")]
    public static const ARROW_RIGHT_CLASS:Class;
    public static const ARROW_RIGHT_BMP:BitmapData = (new ARROW_RIGHT_CLASS).bitmapData;

    [Embed(source="../res/cells/25-arrow-top.png")]
    public static const ARROW_TOP_CLASS:Class;
    public static const ARROW_TOP_BMP:BitmapData = (new ARROW_TOP_CLASS).bitmapData;
}
}
