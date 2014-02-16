/**
 * Created by ilya on 14.02.14.
 */
package ru.ipo.kio._14.stars.graphs {

import flash.utils.Dictionary;

import ru.ipo.kio._14.stars.Star;

public class IsomorphismChecker {
    public function IsomorphismChecker() {
    }

    public static function areIsomorphic(g1:Graph, g2:Graph):Boolean {
        var n1:int = g1.numberOfStars;
        var n2:int = g2.numberOfStars;
        if (n1 != n2)
            return false;

        var e1:int = g1.numberOfEdges;
        var e2:int = g2.numberOfEdges;

        if (e1 != e2)
            return false;

        if (e1 == n1 - 1)
            return areTreesIsomorphic(g1, g2);

        if (e1 == n1)
            return areOneCycleIsomorphic(g1, g2);

        throw new Error("Trying to compare unsupported graphs");
    }

    private static function areOneCycleIsomorphic(g1:Graph, g2:Graph):Boolean {
        var cycle1:Vector.<Star> = findCycle(g1);
        var cycle2:Vector.<Star> = findCycle(g2);

        var n:uint = cycle1.length;
        if (n != cycle2.length)
            return false;

        var sc1:Vector.<String> = semicanonizeCycle(g1, cycle1);
        var sc2:Vector.<String> = semicanonizeCycle(g2, cycle2);

        for (var skip:int = 0; skip < n; skip++)
            if (sc1.every(function(item:String, ind:int, vector:*):Boolean {
                //noinspection JSReferencingMutableVariableFromClosure
                var j:int = ind + skip; //should work, even if skip is mutable
                if (j >= n)
                    j -= n;
                return item == sc2[j];
            }))
                return true;

        for (skip = 0; skip < n; skip++)
            if (sc1.every(function(item:String, ind:int, vector:*):Boolean {
                //noinspection JSReferencingMutableVariableFromClosure
                var j:int = - ind + skip; //should work, even if skip is mutable
                if (j < 0)
                    j += n;
                return item == sc2[j];
            }))
                return true;

        return false;
    }

    public static function findCycle(g:Graph):Vector.<Star> {
        var s0:Star = g.stars[0];
        var visitedFrom:Dictionary = new Dictionary(); //Star -> Star

        return searchCycle(s0, s0);

        //returns a cycle
        function searchCycle(sFrom:Star, sTo:Star):Vector.<Star> {
            visitedFrom[sTo] = sFrom;
            for each (var star:Star in g.graph[sTo])
                if (star != sFrom) {
                    if (star in visitedFrom) {
                        var result:Vector.<Star> = new <Star>[];
                        result.push(star);
                        while (sTo != star) {
                            result.push(sTo);
                            sTo = visitedFrom[sTo];
                        }
                        return result;
                    } else {
                        var cycle:Vector.<Star> = searchCycle(sTo, star);
                        if (cycle != null)
                            return cycle;
                    }
                }

            return null;
        }
    }

    private static function areTreesIsomorphic(g1:Graph, g2:Graph):Boolean {
        var centers1:Vector.<Star> = findTreeCenter(g1);
        var centers2:Vector.<Star> = findTreeCenter(g2);

        if (centers1.length != centers2.length)
            return false;

        var canon1:String = canonizeTree(g1, centers1[0]);
        var canon2:String = canonizeTree(g2, centers2[0]);

        if (canon1 == canon2)
            return true;

        if (centers2.length == 2) {
            canon2 = canonizeTree(g2, centers2[1]);
            if (canon1 == canon2)
                return true;
        }

        return false;
    }

    public static function findTreeCenter(g:Graph):Vector.<Star> {
        var dists:Dictionary = new Dictionary();
        var bestStar:Star = null;
        var bestDist:int = -1;

        function find_dists(s:Star, dist:int = 0, from:Star = null):void {
            if (dist > bestDist) {
                bestStar = s;
                bestDist = dist;
            }
            dists[s] = dist;
            for each (var next:Star in g.graph[s])
                if (next != from)
                    find_dists(next, dist + 1, s);
        }

        find_dists(g.stars[0]); //find all distances from some vertex

        var u:Star = bestStar;

        bestDist = -1;
        find_dists(bestStar);
        var v:Star = bestStar;

        var n:int = bestDist;

        //now we have a diameter from u to v of length n
        //end of diameters are centers for small n
        if (n == 0)
            return new <Star>[u];
        if (n == 1)
            return new <Star>[u, v];

        //now we are sure that centers are not at the ends of the diameter

        var k:int; //center distances
        var l:int;
        if (n % 2 == 0) {
            k = n / 2;
            l = -1;
        } else {
            k = int(n / 2);
            l = k + 1;
        }

        var v_dist:int = n;
        var result:Vector.<Star> = new <Star>[];
        diameter_cycle: while (v != u) {
            if (v_dist == l)
                result.push(v);
            if (v_dist == k) {
                result.push(v);
                break;
            }

            for each (var t:Star in g.graph[v])
                if (dists[t] == v_dist - 1) {
                    v_dist --;
                    v = t;
                    continue diameter_cycle;
                }

            throw new Error('Illegal state: we should have found a previous vertex in the diameter');
        }

        return result;
    }

    public static function semicanonizeCycle(g:Graph, cycle:Vector.<Star>):Vector.<String> {
        var n:int = cycle.length;

        var result:Vector.<String> = new <String>[];

        result.push(canonizeTree(g, cycle[n - 1], cycle[0], cycle[n - 2]));
        result.push(canonizeTree(g, cycle[0], cycle[n - 1], cycle[1]));

        for (var i:int = 1; i <= n - 2; i++)
            result.push(canonizeTree(g, cycle[i], cycle[i - 1], cycle[i + 1]));

        return result;
    }

    public static function canonizeTree(g:Graph, v:Star, forbidden_vertex_1:Star = null, forbidden_vertex_2:Star = null):String {
        var list:Vector.<String> = new <String>[];
        for each (var star:Star in g.graph[v])
            if (star != forbidden_vertex_1 && star != forbidden_vertex_2)
                list.push("(" + canonizeTree(g, star, v) + ")");

        return list.sort(0).join("");
    }

}
}
