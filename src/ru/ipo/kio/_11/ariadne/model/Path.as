/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 26.02.11
 * Time: 18:10
 */
package ru.ipo.kio._11.ariadne.model {

/**
 * Path with two glued points
 */
public class Path {

    private var _points:Array; //array of IntegerPoint (usual)

    public function Path(start:IntegerPoint, finish:IntegerPoint) {
        _points = [start, finish];
    }

    public function insert(p:IntegerPoint, segment_index:int):void {
        //(0) --0-- (1) --1-- (2) --2-- (3) ...
        _points.splice(segment_index + 1, 0, p);
    }

    public function remove(point_index:int):void {
        _points.splice(point_index, 1);
    }

    public function get pointsCount():int {
        return _points.length;
    }

    /**
     * including start and finish
     * @param ind 0 based index
     */
    public function getPoint(ind:int):IntegerPoint {
        return _points[ind];
    }

    public function setPoint(ind:int, point:IntegerPoint):void {
        _points[ind] = point;
    }

    public function serialize():Object {
        //noinspection JSMismatchedCollectionQueryUpdateInspection
        var p:Array = new Array(_points.length);

        for (var i:int = 0; i < _points.length; i++)
            p[i] = {x:_points[i].x, y:_points[i].y};

        return {points: p};
    }

    public static function unSerialize(value:Object):Path {
        if (!value.points)
            return null;

        var path:Path = new Path(null, null); //we will substitute this with a normal array

        var p:Array = value.points;

        path._points = new Array(p.length);
        for (var i:int = 0; i < p.length; i++)
            path._points[i] = new IntegerPoint(p[i].x, p[i].y);

        return path;
    }
}
}