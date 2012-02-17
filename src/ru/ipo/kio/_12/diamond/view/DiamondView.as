/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 16.02.12
 * Time: 13:00
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.diamond.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.system.System;
import flash.utils.Dictionary;

import ru.ipo.kio._12.diamond.Vertex2D;

import ru.ipo.kio._12.diamond.model.Diamond;

public class DiamondView extends Sprite {
    
    private var _diamond:Diamond;
    private var x_min:int;
    private var y_min:int;
    private var x_max:int;
    private var y_max:int;

    private var vert2view:Dictionary/*Vertex2D -> VertexView*/ = new Dictionary();

    public function DiamondView(diamond:Diamond, x_min:int, y_min:int, x_max:int, y_max:int) {
        _diamond = diamond;
        
        this.x_min = x_min;
        this.y_min = y_min;
        this.x_max = x_max;
        this.y_max = y_max;

        _diamond.addEventListener(Diamond.UPDATE, diamond_update);
        addEventListener(MouseEvent.DOUBLE_CLICK, create_vertex)
        
        doubleClickEnabled = true;

        diamond_update();
    }

    private function create_vertex(event:MouseEvent):void {
        if (_diamond.vertexCount >= 20)
            return;
        
        //TODO add scale
        var vertex:Vertex2D = new Vertex2D(event.localX, event.localY);
        _diamond.addVertex(vertex);
    }

    private function diamond_update(event:Event = null):void {
        var v_count:int = _diamond.vertexCount;
        
        var usedVertices:Dictionary = new Dictionary();

        for (var i:int = 0; i < v_count; i++) {
            var vertex:Vertex2D = _diamond.getVertex(i);
            if (!vert2view[vertex]) {
                var view:VertexView = new VertexView(vertex, x_min, y_min, x_max, y_max);
                vert2view[vertex] = view;
                addChild(view);
            }
            usedVertices[vertex] = 1;
        }

        /*for (var vertex2:Vertex2D in vert2view)
            if (!usedVertices[vertex2]) {
                removeChild(vert2view[vertex2]);
                delete vert2view[vertex2];
            }*/

        //draw edges
        graphics.clear();
        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(x_min, y_min, x_max, y_max); //todo scale
        graphics.endFill();
        
        graphics.lineStyle(3, 0x0000AA);

        trace('UPDATING ' + new Date().time);
        var hullVerticesCount:int = _diamond.hullVertexCount;
        for (i = 0; i < hullVerticesCount; i++) {
            var j:int = i + 1;
            if (j == hullVerticesCount)
                j = 0;
            var v1:Point = vert2view[_diamond.getHullVertex(i)].screenPoint;
            var v2:Point = vert2view[_diamond.getHullVertex(j)].screenPoint;
            
            graphics.moveTo(v1.x, v1.y);
            graphics.lineTo(v2.x, v2.y);
        }
    }
}
}
