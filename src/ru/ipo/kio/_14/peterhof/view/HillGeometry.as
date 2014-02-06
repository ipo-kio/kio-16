/**
 * Created by ilya on 13.01.14.
 */
package ru.ipo.kio._14.peterhof.view {
import away3d.core.base.Geometry;
import away3d.core.base.SubGeometry;

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
        vertexes.push(a + b, 0, 0);
        vertexes.push(a + b, 0, d);
        vertexes.push(a + b + c, 0, 0);
        vertexes.push(a + b + c, 0, d);

        //bottom
        vertexes.push(0, -h2, 0); //8
        vertexes.push(0, -h2, d);
        vertexes.push(a + b + c, -h2, 0);
        vertexes.push(a + b + c, -h2, d);

        moveVertexesBack(vertexes, a);

        var uvs:Vector.<Number> = new Vector.<Number>;
        var v1:Number = 1 / 8;  //128 of 1024
        var v2:Number = 7 / 8;
        var u1:Number = 2 / 16;
        var u2:Number = 9 / 16;
        var u3:Number = 15 / 16;
        uvs.push(0, v1);
        uvs.push(0, v2);
        uvs.push(u1, v1);
        uvs.push(u1, v2);
        uvs.push(u2, v1);
        uvs.push(u2, v2);
        uvs.push(u3, v1);
        uvs.push(u3, v2);

        //bottom
        uvs.push(0, 0);
        uvs.push(0, 1);
        uvs.push(1, 0);
        uvs.push(1, 1);

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
        indices.push(10, 6, 7);
        indices.push(10, 7, 11);

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
}
}
