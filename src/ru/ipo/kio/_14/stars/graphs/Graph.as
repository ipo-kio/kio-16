/**
 * Created by user on 12.02.14.
 */
package ru.ipo.kio._14.stars.graphs {
import flash.utils.Dictionary;

import ru.ipo.kio._14.stars.Star;

public class Graph {

    private var _graph:Dictionary; //<Star -> starsList <Vector.<Star>>>
    private var stars:Vector.<Star>;

    public function Graph(graph:Dictionary) {
        _graph = graph;
        stars = new Vector.<Star>();
        for (var s:Object in _graph)
            stars.push(s);
    }

    public function get graph():Dictionary {
        return _graph;
    }

    public function findConnectedComponents():Vector.<Graph> {
        var graphs:Vector.<Graph> = new Vector.<Graph>();

        // #1
        var visited:Dictionary = new Dictionary(); // Star// -> int (number of a connected component)

        // #2
        for each (var star:Star in stars)
            visited[star] = 0;

        // #3
        var cc:int = 1;
        searchCC: while (true) {
            for each (star in stars) {
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
            return new Graph(d);
        }

        return graphs;
    }
}
}
