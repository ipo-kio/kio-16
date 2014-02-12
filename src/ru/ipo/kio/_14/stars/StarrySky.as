/**
 * Created by user on 22.01.14.
 */
package ru.ipo.kio._14.stars {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;

import ru.ipo.kio._14.stars.graphs.Graph;

public class StarrySky extends EventDispatcher {

    private var _stars:Array/*<Star>*/;
    private var _starsLines:Array/*<Line>*/;

    private var _sumOfLines:Number = 0;

    private var intersectedLines:Dictionary; // Line -> true/nothing
    private var _graph:Graph;
    private var _connectedComponents:Vector.<Graph>;

    public function StarrySky(stars:Array) {
        _stars = stars;
        _starsLines = [];

        for (var i:int = 0; i < stars.length; i++)
            stars[i].index = i;
    }

    //returns index of added line
    public function addLine(a:Star, b:Star):int {
        var line:Line = new Line(a, b);
        if (!contains(line)) {
            _starsLines.push(line);

            skyChanged();

            return _starsLines.length - 1;
        }

        return -1;
    }

    public function get sumOfLines():Number {
        return _sumOfLines;
    }

    private function findLine(line:Line):int {
        for (var i:int = 0; i < _starsLines.length; i++)
            if (_starsLines[i].s1 == line.s1 && _starsLines[i].s2 == line.s2 ||
                    _starsLines[i].s1 == line.s2 && _starsLines[i].s2 == line.s1)
                return i;
        return -1;
    }

    private function contains(line:Line):Boolean {
        return findLine(line) >= 0;
    }

    public function get stars():Array {
        return _stars;
    }

    public function get starsLines():Array {
        return _starsLines;
    }

    public function removeLineWithIndex(ind:int):void {
        _starsLines.splice(ind, 1);
        skyChanged();
    }

    private function skyChanged():void {
        //evaluate, count, compute
        //compute total length
        _sumOfLines = 0;
        for each (var line:Line in starsLines)
            _sumOfLines += line.distance;
        //for output.     var n:Number = 1.123123123;    n.toFixed(3) -> converts to String with 3 digits after a point

        findIntersections();

        if (!hasIntersectedLines())
            createGraph();
        else {
            _graph = null;
            _connectedComponents = null;
        }

        dispatchEvent(new Event(Event.CHANGE));
    }

    public function hasIntersectedLines():Boolean {
        return intersectedLines.length > 0;
    }

    public function isLineIntersected(line:Line):Boolean {
        return intersectedLines[line];
//        return line in intersectedLines;
    }

    private function findIntersections():void {
        intersectedLines = new Dictionary(); // Line -> true/false
        for each (var l1:Line in starsLines) {
            if (intersectedLines[l1])
                continue;

            for each (var l2:Line in starsLines) {
                if (doesSegmentIntersectLine(l1, l2) && doesSegmentIntersectLine(l2, l1)) {
                    intersectedLines[l1] = true;
                    intersectedLines[l2] = true;
                    break;
                }
            }
        }
    }

    private static function doesSegmentIntersectLine(line:Line, l1:Line):Boolean {
        var a:Number = line.s2.y - line.s1.y;
        var b:Number = line.s1.x - line.s2.x;
        var c:Number = - line.s1.x * line.s2.y + line.s2.x * line.s1.y;

        var pos1:Number = l1.s1.x * a + l1.s1.y * b + c;
        var pos2:Number = l1.s2.x * a + l1.s2.y * b + c;

        return pos1 > 0 && pos2 < 0 || pos2 > 0 && pos1 < 0;
    }



    private function createGraph():void {
        var neighbours:Dictionary = new Dictionary();
        for each (var star:Star in stars)
            neighbours[star] = new Vector.<Star>();

        for each (var line:Line in starsLines) {
            neighbours[line.s1].push(line.s2);
            neighbours[line.s2].push(line.s1);
        }

        _graph = new Graph(neighbours);
        _connectedComponents = _graph.findConnectedComponents();
    }

    public function serialize():Array {
        var serializeArray:Array = [];
        for each (var line:Line in starsLines)
            serializeArray.push(line.serialize());
        return serializeArray;
    }

    public function getStarByIndex(ind:int):Star {
        return stars[ind];
    }
}
}
