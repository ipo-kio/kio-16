/**
 * Created by ilya on 03.02.14.
 */
package ru.ipo.kio._14.peterhof.view {
import away3d.core.base.Geometry;
import away3d.core.base.SubGeometry;

import flash.geom.Vector3D;

public class SegmentGeometry extends Geometry {

   private static const D:Number = 0.5;

    public function SegmentGeometry(l:Number) {
        var vertexes:Vector.<Number> = new Vector.<Number>;
        var l2:Number = l / 2;

        vertexes.push(-l2, 0, D);
        vertexes.push(-l2, D, 0);
        vertexes.push(-l2, 0, -D);
        vertexes.push(-l2, -D, 0);

        vertexes.push(l2, 0, D);
        vertexes.push(l2, D, 0);
        vertexes.push(l2, 0, -D);
        vertexes.push(l2, -D, 0);

        var uvs:Vector.<Number> = new Vector.<Number>;
        uvs.push(0, 0);
        uvs.push(0, 1);
        uvs.push(1, 1);
        uvs.push(1, 0);

        uvs.push(0, 0);
        uvs.push(0, 1);
        uvs.push(1, 1);
        uvs.push(1, 0);

        var indices:Vector.<uint> = new Vector.<uint>;
        indices.push(0, 1, 2);
        indices.push(0, 2, 3);

        indices.push(5, 4, 6);
        indices.push(6, 4, 7);

        indices.push(2, 1, 6);
        indices.push(6, 1, 5);
        indices.push(1, 0, 4);
        indices.push(1, 4, 5);
        indices.push(4, 0, 7);
        indices.push(7, 0, 3);
        indices.push(2, 6, 7);
        indices.push(2, 7, 3);

        var subGeometry:SubGeometry = new SubGeometry();
        subGeometry.updateVertexData(vertexes);
        subGeometry.updateUVData(uvs);
        subGeometry.updateIndexData(indices);
        subGeometry.autoDeriveVertexTangents = true;
        subGeometry.autoDeriveVertexNormals = true;

        addSubGeometry(subGeometry);
    }
}
}
