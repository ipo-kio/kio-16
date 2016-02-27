package ru.ipo.kio._16.mower.view {
import flash.display.Graphics;
import flash.geom.Point;

import ru.ipo.kio._16.mower.model.Field;

public class CellsDrawer {

    public static const SIZE_BIG:int = 0;
    public static const SIZE_SMALL:int = 1;
    
    public static const BIG_LENGTH:Number = 30;
    public static const SMALL_LENGTH:Number = 25;
    public static const SIGN_SELECTION_SIZE:Number = 10;

    public static const SIGN_SIZE:Number = 6;

    public static function size2length(size:int):Number {
        return size == SIZE_BIG ? BIG_LENGTH : SMALL_LENGTH;
    }
    
    public static function drawCell(g:Graphics, i:int, j:int, typ:int, size:int/*, highlight:Boolean = false*/):void {
        var length:Number = size2length(size);

        var x0:Number = j * length;
        var y0:Number = i * length;
        
//        if (highlight) {
//            g.beginFill(0xFFFF00);
//            g.drawRect(x0, y0, length, length);
//            g.endFill();
//        }
        
        switch (typ) {
            case Field.FIELD_GRASS:
            case Field.FIELD_PROGRAM_GRASS:
                g.lineStyle(1, 0x000000);
                g.beginFill(0x00FF00);
                g.drawRect(x0, y0, length, length);
                g.endFill();
                break;
            case Field.FIELD_GRASS_MOWED:
            case Field.FIELD_PROGRAM_MOWED_GRASS:
                g.lineStyle(1, 0x000000);
                g.beginFill(0x00AA00);
                g.drawRect(x0, y0, length, length);
                g.endFill();

//                g.drawCircle(x0 + length / 2, y0 + length / 2, length / 2 - 3);
                break;
            case Field.FIELD_TREE:
            case Field.FIELD_PROGRAM_TREE:
                g.lineStyle(1, 0x000000);
                g.moveTo(x0 + length / 2, y0 + 2);
                g.lineTo(x0 + length / 2, y0 + length - 2);
                g.moveTo(x0 + 2, y0 + length * 2 / 3);
                g.lineTo(x0 + length - 2, y0 + length * 2 / 3);
                break;
            case Field.FIELD_SWAMP:
            case Field.FIELD_PROGRAM_SWAMP:
                g.lineStyle(1, 0x000000);
                g.drawCircle(x0 + length / 3, y0 + length / 3, 3);
                g.drawCircle(x0 + length / 3, y0 + 2 * length / 3, 3);
                g.drawCircle(x0 + 2 * length / 3, y0 + length / 3, 3);
                g.drawCircle(x0 + 2 * length / 3, y0 + 2 * length / 3, 3);
                break;
            case Field.FIELD_PROGRAM_MOWER:
                g.lineStyle(1, 0x000000);
                g.drawCircle(x0 + length / 2, y0 + length / 2, 3);
                g.drawCircle(x0 + length / 2, y0 + length / 2, 5);
                break;
            case Field.FIELD_TURN_LEFT:
                g.lineStyle(1, 0x000000);
                g.moveTo(x0 + length / 2, y0 + length - 2);
                g.lineTo(x0 + length / 2, y0 + 2);
                g.lineTo(x0 + 2, y0 + 2);
                break;
            case Field.FIELD_TURN_RIGHT:
                g.lineStyle(1, 0x000000);
                g.moveTo(x0 + length / 2, y0 + length - 2);
                g.lineTo(x0 + length / 2, y0 + 2);
                g.lineTo(x0 + length - 2, y0 + 2);
                break;
            case Field.FIELD_FORWARD:
                g.lineStyle(1, 0x000000);
                g.moveTo(x0 + length / 2, y0 + length - 2);
                g.lineTo(x0 + length / 2, y0 + 2);
                break;
            case Field.FIELD_NOP:
                g.drawCircle(x0 + length / 2, y0 + length / 2, 4);
                break;
        }
    }

    public static function position2point(i:Number, j:Number, size:int = SIZE_SMALL):Point {
        var length:Number = size2length(size);

        var x0:Number = j * length;
        var y0:Number = i * length;

        return new Point(x0, y0);
    }

    /*public static function drawMower(g:Graphics, mower:Mower, size:int):void {
        var length:Number = size2length(size);

        var x0:Number = mower.j * length;
        var y0:Number = mower.i * length;

        g.lineStyle(1, 0x000000);
        g.drawCircle(x0 + length / 2, y0 + length / 2, 3);
        g.drawCircle(x0 + length / 2, y0 + length / 2, 5);

        g.moveTo(x0 + length / 2, y0 + length / 2);
        if (mower.di == 1) //down
            g.lineTo(x0 + length / 2, y0 + length - 2);
        else if (mower.di == -1) // up
            g.lineTo(x0 + length / 2, y0 + 2);
        else if (mower.dj == 1) // left
            g.lineTo(x0 + 2, y0 + length / 2);
        else //if (mower.dj == -1) // right
            g.lineTo(x0 + length - 2, y0 + length / 2);
    }*/

    public static function drawSymbol(g:Graphics, i:int, j:int, typ:int, size:int = SIZE_BIG):void {
        var p:Point = position2point(i, j, size);
        var x0:Number = p.x;
        var y0:Number = p.y;
        g.lineStyle(1, 0);
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
}
}
