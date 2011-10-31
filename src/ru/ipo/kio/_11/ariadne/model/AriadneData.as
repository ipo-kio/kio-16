/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 27.02.11
 * Time: 12:35
 */
package ru.ipo.kio._11.ariadne.model {
import flash.events.Event;
import flash.events.EventDispatcher;

public class AriadneData extends EventDispatcher {

    private static var _instance:AriadneData = new AriadneData;

    public static const POINT_MOVED:String = "point moved";
    public static const PATH_CHANGED:String = "path changed";
    public static const POINT_SELECTION_CHANGED:String = "point selection changed";
    public static const SEGMENT_SELECTION_CHANGED:String = "segment selection changed";

    public static function get instance():AriadneData {
        return _instance;
    }

    private var _terra:Terra;
    private var _path:Path;
    private var _selected_point_index:int = -1;
    private var _selected_segment_index:int = -1;

    public function AriadneData() {
        _terra = new AriadneTerra;
        initPath();
    }

    private function initPath():void {
        _path = new Path(new IntegerPoint(1, _terra.height - 1), new IntegerPoint(_terra.width - 1, 1));
    }

    public function get pointsCount():int {
        return _path.pointsCount;
    }

    public function getPoint(ind:int):IntegerPoint {
        return _path.getPoint(ind);
    }

    public function setPoint(ind:int, point:IntegerPoint):void {
        if (point.equals(_path.getPoint(ind)))
            return;

        _path.setPoint(ind, point);
        dispatchEvent(new PointMovedEvent(ind));
    }

    public function get terra():Terra {
        return _terra;
    }

    public function get selected_point_index():int {
        return _selected_point_index;
    }


    public function get selected_segment_index():int {
        return _selected_segment_index;
    }

    public function set selected_point_index(value:int):void {
        var old_value:int = _selected_point_index;

        if (value <= 0)
            value = -1;
        if (value >= _path.pointsCount - 1)
            value = -1;

        _selected_point_index = value;

        if (old_value != value)
            dispatchEvent(new SelectionChangedEvent(POINT_SELECTION_CHANGED, old_value, value));
    }

    public function set selected_segment_index(value:int):void {
        var old_value:int = _selected_segment_index;

        if (value < 0)
            value = -1;
        if (value >= _path.pointsCount - 1)
            value = -1;

        _selected_segment_index = value;

        if (old_value != value)
            dispatchEvent(new SelectionChangedEvent(SEGMENT_SELECTION_CHANGED, old_value, value));
    }

    public function removePoint():void {
        if (selected_point_index > 0 && selected_point_index < _path.pointsCount - 1) {
            _path.remove(selected_point_index);
            //_selected_point_index = -1;

            if (_selected_point_index >= pointsCount - 1)
                _selected_point_index = 1;
            if (_selected_point_index >= pointsCount - 1)
                _selected_point_index = -1;
            _selected_segment_index = -1;

            dispatchEvent(new Event(PATH_CHANGED));
        }
    }

    public function addPoint(ip:IntegerPoint):void {
        var segment_index:int = _selected_segment_index;
        if (segment_index < 0)
            segment_index = _path.pointsCount - 2;

        _path.insert(ip, segment_index);
        _selected_segment_index = segment_index + 1;
        _selected_point_index = segment_index + 1;

        dispatchEvent(new Event(PATH_CHANGED));
    }

    public function clearPath():void {
        initPath();

        _selected_point_index = -1;
        _selected_segment_index = -1;

        dispatchEvent(new Event(PATH_CHANGED));
    }

    public function get serializedPath():Object {
        return _path.serialize();
    }

    public function set serializedPath(value:Object):void {
        var newPath:Path = Path.unSerialize(value);
        if (!newPath)
            return;
        _path = newPath;
        _selected_point_index = -1;
        _selected_segment_index = -1;

        dispatchEvent(new Event(PATH_CHANGED));
    }

    //DEBUG

    private var _velocity_info:Array = null; //Array of ints with velocities

    public function get velocity_info():Array {
        return _velocity_info;
    }

    public function set velocity_info(value:Array):void {
        _velocity_info = value;
    }

}
}
