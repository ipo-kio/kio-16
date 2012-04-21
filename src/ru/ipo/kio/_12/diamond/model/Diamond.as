/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 13.02.12
 * Time: 23:41
 */
package ru.ipo.kio._12.diamond.model {
import avmplus.implementsXml;

import flash.events.Event;
import flash.events.EventDispatcher;

import ru.ipo.kio._12.diamond.GeometryUtils;

import ru.ipo.kio._12.diamond.Vertex2D;
import ru.ipo.kio._12.diamond.view.Eye;

public class Diamond extends EventDispatcher {

    public static const ETA:Number = 2.417; //2.

    private var _vertices:Array/*Vertex2D*/ = [];
    private var _hull:Array/*Vertex2D*/ = [];

    private var _spectrum:Spectrum = null;

    public static const UPDATE:String = 'vertices update';
    private static const UPDATE_EVENT:Event = new Event(UPDATE);
    private var _level:int;

    public function Diamond(level:int) {
        _level = level;
    }

    private function update_convex_hull():void {
        _hull = GeometryUtils.convex_hull(_vertices);

        if (_level == 2)
            _spectrum = new Spectrum(this, Eye.MIN_ANGLE, Eye.MAX_ANGLE);
    }

    public function addVertex(v:Vertex2D):void {
        v.addEventListener(Vertex2D.MOVE, vertex_moved);
        _vertices.push(v);
        update_convex_hull();
        dispatchEvent(UPDATE_EVENT);
    }

    public function removeVertex(v:Vertex2D):void {
        removeVertexByIndex(_vertices.indexOf(v));
        update_convex_hull();
        dispatchEvent(UPDATE_EVENT);
    }

    private function removeVertexByIndex(ind:int):void {
        if (ind < 0 || ind >= _vertices.length)
            return;
        
        _vertices[ind].removeEventListener(Vertex2D.MOVE, vertex_moved);
        
        _vertices.splice(ind, 1);

        update_convex_hull();
        dispatchEvent(UPDATE_EVENT);
    }
    
    public function getVertex(ind:int):Vertex2D {
        return _vertices[ind];
    }
    
    public function getHullVertex(ind:int):Vertex2D {
        return _hull[ind];
    }
    
    public function get vertexCount():int {
        return _vertices.length;
    }

    public function get hullVertexCount():int {
        return _hull.length;
    }
    
    public function setVertex(ind:int, v:Vertex2D):void {
        _vertices[ind].removeEventListener(Vertex2D.MOVE, vertex_moved);
        _vertices[ind] = v;
        v.addEventListener(Vertex2D.MOVE, vertex_moved);

        update_convex_hull();
        dispatchEvent(UPDATE_EVENT);
    }

    private function vertex_moved(event:Event):void {
        update_convex_hull();
        dispatchEvent(UPDATE_EVENT);
    }

    public function get hull():Array {
        return _hull;
    }

    public function get spectrum():Spectrum {
        return _spectrum;
    }

    public function serialize():Array {
        var res:Array = [];
        for (var i:int = 0; i < _vertices.length; i++)
            res.push([_vertices[i].x, _vertices[i].y]);
        return res;
    }

    public function unserialize(value:Array, real_points:Boolean = false):void {
        if (value == null)
            return;

        _vertices = [];
        for (var i:int = 0; i < value.length; i++)
            {
                var v:Vertex2D = real_points ?
                        new Vertex2D(value[i].x, value[i].y) :
                        new Vertex2D(value[i][0], value[i][1]);
                v.addEventListener(Vertex2D.MOVE, vertex_moved);
                _vertices.push(v);
            }
        
        update_convex_hull();
        dispatchEvent(UPDATE_EVENT);
    }
    
    public function only_hullize():void {
        unserialize(_hull, true);
        update_convex_hull();
        dispatchEvent(UPDATE_EVENT);
    }

    public function get area():Number {
        if (_hull == null || _hull.length == 0)
            return 0;

        var sum:Number = 0;
        for (var i:int = 0; i < _hull.length; i++) {
            var j:int = i - 1;
            if (j < 0)
                j = _hull.length - 1;

            sum += (_hull[i].x - _hull[j].x) * (_hull[i].y + _hull[j].y) / 2;
        }
        return Math.abs(sum);
    }
}
}
