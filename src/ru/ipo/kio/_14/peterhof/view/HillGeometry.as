/**
 * Created by ilya on 13.01.14.
 */
package ru.ipo.kio._14.peterhof.view {
import away3d.core.base.Geometry;
import away3d.core.base.SubGeometry;

import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;

import ru.ipo.kio._14.peterhof.model.Consts;

public class HillGeometry extends Geometry {
    public function HillGeometry(a:uint, b:uint, c:uint, d:uint, h:uint, h2:uint) {
        a = a * Consts.PIXELS_IN_METER;
        b = b * Consts.PIXELS_IN_METER;
        c = c * Consts.PIXELS_IN_METER;
        d = d * Consts.PIXELS_IN_METER;
        h = h * Consts.PIXELS_IN_METER;
        h2 = h2 * Consts.PIXELS_IN_METER;

        var vertexes:Vector.<Number> = new Vector.<Number>;

        vertexes.push(0, h, 0);
        vertexes.push(0, h, d);
        vertexes.push(a, h, 0);
        vertexes.push(a, h, d);
        vertexes.push(a + b, 0, 0);  // 4
        vertexes.push(a + b, 0, d);
        vertexes.push(a + b + c, 0, 0); // 6
        vertexes.push(a + b + c, 0, d);

        //bottom
        vertexes.push(0, -h2, 0); // 8
        vertexes.push(0, -h2, d);
        vertexes.push(a + b + c, -h2, 0); // 10
        vertexes.push(a + b + c, -h2, 0); // 10'
        vertexes.push(a + b + c, -h2, d);

        moveVertexesBack(vertexes, a);

        var uvs:Vector.<Number> = new Vector.<Number>;
        var v1:Number = 1 / 8;  //128 of 1024
        var v2:Number = 7 / 8;
        var u1:Number = 2 / 16;
        var u2:Number = 2 / 16 + Consts.HILL_LENGTH1 / Consts.HILL_LENGTH * (1 - 3 / 16);
        var u3:Number = 15 / 16;
        uvs.push(0, v1);
        uvs.push(0, v2);
        uvs.push(u1, v1);
        uvs.push(u1, v2);
        uvs.push(u2, v1); // 4
        uvs.push(u2, v2);
        uvs.push(u3, v1); // 6
        uvs.push(u3, v2);

        //bottom
        uvs.push(0, 0);
        uvs.push(0, 1);
        uvs.push(u3, 0); // 10
        uvs.push(1, v1); // 10'
        uvs.push(1, v2);

        var indices:Vector.<uint> = new Vector.<uint>;
        indices.push(0, 1, 2);
        indices.push(1, 3, 2);
        indices.push(2, 3, 4);
        indices.push(3, 5, 4);
        indices.push(4, 5, 6);
        indices.push(5, 7, 6);
        //close side
        indices.push(8, 0, 2);
        indices.push(8, 2, 4);
        indices.push(8, 4, 10);
        indices.push(4, 6, 10);
        //right side
        indices.push(11, 6, 7);
        indices.push(11, 7, 12);

        var subGeometry:SubGeometry = new SubGeometry();
        subGeometry.updateVertexData(vertexes);
        subGeometry.updateUVData(uvs);
        subGeometry.updateIndexData(indices);
        subGeometry.autoDeriveVertexTangents = true;
        subGeometry.autoDeriveVertexNormals = true;

        addSubGeometry(subGeometry);
    }

    private static function moveVertexesBack(vertexes:Vector.<Number>, a:Number):void {
        for (var i:int = 0; i < vertexes.length; i++)
            if (i % 3 == 0)
                vertexes[i] -= a;
    }

    private static function drawLine(g:Graphics, x1:Number, y1:Number, x2:Number, y2:Number, is_hor:Boolean, color_from:uint, color_to:uint):void {
        var rf:int = (color_from & 0xFF0000) >> 16;
        var gf:int = (color_from & 0x00FF00) >> 8;
        var bf:int = color_from & 0x0000FF;

        var rt:int = (color_to & 0xFF0000) >> 16;
        var gt:int = (color_to & 0x00FF00) >> 8;
        var bt:int = color_to & 0x0000FF;

        var rd:int = rf - rt;
        var gd:int = gf - gt;
        var bd:int = bf - bt;

        var c0:uint = color_from;
        var c1:uint = color_from - (int(rd / 4) << 16) - (int(gd / 4) << 8) - int(bd / 4);
        var c2:uint = color_from - (int(2 * rd / 4) << 16) - (int(2 * gd / 4) << 8) - int(2 * bd / 4);
        var c3:uint = color_from - (int(3 * rd / 4) << 16) - (int(3 * gd / 4) << 8) - int(3 * bd / 4);

        g.lineStyle(1, c0);
        g.moveTo(x1, y1);
        g.lineTo(x2, y2);

        g.lineStyle(1, c1);
        if (is_hor) {
            g.moveTo(x1, y1 - 1);
            g.lineTo(x2, y2 - 1);
            g.moveTo(x1, y1 + 1);
            g.lineTo(x2, y2 + 1);
        } else {
            g.moveTo(x1 - 1, y1);
            g.lineTo(x2 - 1, y2);
            g.moveTo(x1 + 1, y1);
            g.lineTo(x2 + 1, y2);
        }

        g.lineStyle(1, c2);
        if (is_hor) {
            g.moveTo(x1, y1 - 2);
            g.lineTo(x2, y2 - 2);
            g.moveTo(x1, y1 + 2);
            g.lineTo(x2, y2 + 2);
        } else {
            g.moveTo(x1 - 2, y1);
            g.lineTo(x2 - 2, y2);
            g.moveTo(x1 + 2, y1);
            g.lineTo(x2 + 2, y2);
        }

        g.lineStyle(1, c3);
        if (is_hor) {
            g.moveTo(x1, y1 - 3);
            g.lineTo(x2, y2 - 3);
            g.moveTo(x1, y1 + 3);
            g.lineTo(x2, y2 + 3);
        } else {
            g.moveTo(x1 - 3, y1);
            g.lineTo(x2 - 3, y2);
            g.moveTo(x1 + 3, y1);
            g.lineTo(x2 + 3, y2);
        }
    }

    public static function drawGrid(bmp:BitmapData):void {
        var grid:Shape = new Shape();

        var g:Graphics = grid.graphics;

        const c_from_2:uint = 0x004400;
        const c_from:uint = 0x448844;
        const c_to:uint = 0x77de11;

        horizontalLines(g, c_from, c_to, Consts.FOUNTAIN_PRECISION);
        verticalLines(g, c_from, c_to, Consts.FOUNTAIN_PRECISION);

        horizontalLines(g, c_from_2, c_to, 5 * Consts.FOUNTAIN_PRECISION);
        verticalLines(g, c_from_2, c_to, 5 * Consts.FOUNTAIN_PRECISION);

        bmp.draw(grid);
    }

    private static function verticalLines(g:Graphics, c_from:uint, c_to:uint, step:Number):void {
        const xScale:Number = Consts.SKIN_WIDTH / Consts.HILL_LENGTH;

        for (var x0:Number = 0; x0 <= Consts.HILL_LENGTH; x0 += step)
            drawLine(g, Consts.SKIN_X0 + x0 * xScale, Consts.SKIN_Z0, Consts.SKIN_X0 + x0 * xScale, Consts.SKIN_Z0 + Consts.SKIN_WIDTH, false, c_from, c_to);
    }

    private static function horizontalLines(g:Graphics, c_from:uint, c_to:uint, step:Number):void {

        const zScale:Number = Consts.SKIN_HEIGHT / Consts.HILL_WIDTH;
        for (var z0:Number = 0; z0 <= Consts.HILL_WIDTH; z0 += step)
            drawLine(g, Consts.SKIN_X0, Consts.SKIN_Z0 + z0 * zScale, Consts.SKIN_X0 + Consts.SKIN_WIDTH, Consts.SKIN_Z0 + z0 * zScale, true, c_from, c_to);
    }
}
}
