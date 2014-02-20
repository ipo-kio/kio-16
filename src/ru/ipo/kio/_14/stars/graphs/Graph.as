/**
 * Created by user on 12.02.14.
 */
package ru.ipo.kio._14.stars.graphs {
import flash.utils.Dictionary;

import ru.ipo.kio._14.stars.Line;
import ru.ipo.kio._14.stars.Star;

public class Graph {

    private var _graph:Dictionary; //<Star -> starsList <Vector.<Star>>>
    private var _stars:Vector.<Star>;

    private var _level:int;

//    public var isCorrect:Boolean;

    public function Graph(graph:Dictionary, level:int) {

        _level = level;

        _graph = graph;
        _stars = new Vector.<Star>();
        for (var s:Object in _graph)
            _stars.push(s);
    }

    public function get graph():Dictionary {
        return _graph;
    }

    public function get numberOfStars():int {
        return _stars.length;
    }

    public function get numberOfEdges():int {
        var totalEdges:int = 0;
        for each (var neighbours:Object in _graph)
            totalEdges += neighbours.length;
        totalEdges = totalEdges / 2;
        return totalEdges;
    }

    public function findConnectedComponents():Vector.<Graph> {
        var graphs:Vector.<Graph> = new Vector.<Graph>();

        // #1
        var visited:Dictionary = new Dictionary(); // Star// -> int (number of a connected component)

        // #2
        for each (var star:Star in _stars)
            visited[star] = 0;

        // #3
        var cc:int = 1;
        searchCC: while (true) {
            for each (star in _stars) {
                if (visited[star] == 0) {
                    visitVertex(star);
                    graphs.push(extractCC());
                    cc++;
                    continue searchCC;
                }
            }
            break;
        }

        function visitVertex(star:Star):void {
            visited[star] = cc;
            var neighbours:Vector.<Star> = _graph[star];
            for each (var n:Star in neighbours)
                if (visited[n] == 0)
                    visitVertex(n);
        }

        function extractCC():Graph {
            var d:Dictionary = new Dictionary();
            for (var star:Object in visited)
                if (visited[star] == cc)
                    d[star] = _graph[star];
            return new Graph(d, _level);
        }

        return graphs;
    }

    public function get stars():Vector.<Star> {
        return _stars;
    }

    public function sumOfEdges():Number {
        var sum:Number = 0;
        for (var s:Object in graph) {
            for each (var neighbour:Star in graph[s])
                sum += new Line(s as Star, neighbour).distance;
        }
        return sum / 2;
    }

    public function isCorrect(level:int):Boolean {
        if (numberOfStars == numberOfEdges + 1) {
            switch (level) {
                case 0:
                    if (numberOfStars >= 2)
                        return true;
                    break;
                case 1:
                    if(numberOfStars >= 4)
                        return true;
                    break;
                case 2:
                    if (numberOfStars >= 5)
                        return true;
                    break;
            }
        } else if(numberOfStars == numberOfEdges) {
            switch (level) {
                case 0:
                    if (numberOfStars >= 2)
                        return true;
                    break;
                case 1:
                    if(numberOfStars >= 4)
                        return true;
                    break;
                case 2:
                    if (numberOfStars >= 5)
                        return true;
                    break;
            }
        }

        return false;
    }
}
}
