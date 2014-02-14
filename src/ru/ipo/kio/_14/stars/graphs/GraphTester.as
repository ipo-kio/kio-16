/**
 * Created by ilya on 14.02.14.
 */
package ru.ipo.kio._14.stars.graphs {
import flash.display.Sprite;
import flash.utils.Dictionary;

import ru.ipo.kio._14.stars.Star;

public class GraphTester extends Sprite {
    public function GraphTester() {

        var v0:Star = new Star(0, 0, 1); v0.index = 0;
        var v1:Star = new Star(0, 0, 1); v1.index = 1;
        var v2:Star = new Star(0, 0, 1); v2.index = 2;
        var v3:Star = new Star(0, 0, 1); v3.index = 3;
        var v4:Star = new Star(0, 0, 1); v4.index = 4;
        var v5:Star = new Star(0, 0, 1); v5.index = 5;
        var v6:Star = new Star(0, 0, 1); v6.index = 6;

        var d:Dictionary = new Dictionary();

        d[v0] = new <Star>[v4];
        d[v1] = new <Star>[v2, v4];
        d[v2] = new <Star>[v1, v3];
        d[v3] = new <Star>[v2, v4, v5, v6];
        d[v4] = new <Star>[v0, v1, v3];
        d[v5] = new <Star>[v3];
        d[v6] = new <Star>[v3];

        var g:Graph = new Graph(d);

        var cycle:Vector.<Star> = IsomorphismChecker.findCycle(g);
        for each (var star:Star in cycle)
            trace('cycle', star.index);

        var semicanon:Vector.<String> = IsomorphismChecker.semicanonizeCycle(g, cycle);

        for each (var string:String in semicanon) {
            trace('semican', string);
        }

        /*d[v1] = new <Star>[v4];
        d[v2] = new <Star>[v3];

        for each (var c:Star in IsomorphismChecker.findTreeCenter(g)) {
            trace('center', c.index);
        }*/

        var u0:Star = new Star(0, 0, 1); u0.index = 0;
        var u1:Star = new Star(0, 0, 1); u1.index = 1;
        var u2:Star = new Star(0, 0, 1); u2.index = 2;
        var u3:Star = new Star(0, 0, 1); u3.index = 3;
        var u4:Star = new Star(0, 0, 1); u4.index = 4;
        var u5:Star = new Star(0, 0, 1); u5.index = 5;
        var u6:Star = new Star(0, 0, 1); u6.index = 6;

        var e:Dictionary = new Dictionary();

        e[u0] = new <Star>[u2, u6];
        e[u1] = new <Star>[u6];
        e[u2] = new <Star>[u0, u3];
        e[u3] = new <Star>[u2, u4, u5, u6];
        e[u4] = new <Star>[u3];
        e[u5] = new <Star>[u3];
        e[u6] = new <Star>[u1, u0, u3];

        var h:Graph = new Graph(e);

        trace(IsomorphismChecker.areIsomorphic(g, h));

        //make both graphs trees

        d[v1] = new <Star>[v4];
        d[v2] = new <Star>[v3];

        e[u0] = new <Star>[u6];
        e[u2] = new <Star>[u3];

        trace(IsomorphismChecker.areIsomorphic(g, h));
    }
}
}
