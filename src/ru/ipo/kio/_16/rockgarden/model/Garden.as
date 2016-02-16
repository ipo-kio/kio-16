package ru.ipo.kio._16.rockgarden.model {

import flash.errors.IllegalOperationError;
import flash.geom.Point;

public class Garden {

    public static const EPS:Number = 1e-10;
    public static const SIDE_LEFT:int = 0;
    public static const SIDE_TOP:int = 1;
    public static const SIDE_RIGHT:int = 2;
    public static const SIDE_BOTTOM:int = 3;

    private var _W:Number;
    private var _H:Number;
    private var _circles:Vector.<Circle> = new Vector.<Circle>();

    private var _MAX_SEGMENTS_LIST_VALUE:Number;

    private var _segments:SegmentsList;
    private var _tangent_lines:Vector.<Point> = new <Point>[];

    public function Garden(W:Number, H:Number, circles:Vector.<Circle>) {
        _W = W;
        _H = H;
        _circles = circles;

        _MAX_SEGMENTS_LIST_VALUE = _H + _W + _H + _W;

        evalSegments();
    }

    public function evalSegments():void {
        var _start:Date = new Date();
//        refreshCirclesStatus();

        _segments = new SegmentsList(_MAX_SEGMENTS_LIST_VALUE, new <int>[]);

        _tangent_lines.splice(0, _tangent_lines.length);

        //first get all tangent lines and intersect them with area

        var all_points:Vector.<Number> = new <Number>[];
        for (var i:int = 0; i < _circles.length; i++) {
            var c1:Circle = _circles[i];

            if (!c1.enabled)
                continue;

            for (var j:int = 0; j < i; j++) {
                var c2:Circle = _circles[j];

                if (!c2.enabled)
                    continue;

                var points:Vector.<Number> = all_tangent_lines(c1, c2);
                for each (var p:Number in points)
                    all_points.push(p);
            }
        }

        //now we have all points, sort them and remove similar
        all_points.sort(Array.NUMERIC);
        // ... remove similar
        for (i = 0; i < all_points.length - 1;) {
            if (Math.abs(all_points[i] - all_points[i + 1]) < Garden.EPS)
                all_points.splice(i + 1, 1);
            else
                i++;
        }

        // ... remove similar in the beginning and end
        if (all_points.length >= 2)
            if (Math.abs(all_points[0] + _MAX_SEGMENTS_LIST_VALUE - all_points[all_points.length - 1]) < Garden.EPS)
                all_points.pop();

        // add all segments
        _segments = new SegmentsList(_MAX_SEGMENTS_LIST_VALUE, null);
        for (i = 0; i < all_points.length; i++) {
            if (i == 0) {
                var pLeft:Number = all_points[all_points.length - 1];
                var pRight:Number = all_points[0];
            } else {
                pLeft = all_points[i - 1];
                pRight = all_points[i];
            }

            var c:Number = Segment.line_center(pLeft, pRight, _MAX_SEGMENTS_LIST_VALUE);

            var visible_circles:Vector.<int> = anglesCircle2visibleCircles(visible_circles_for_point(location2point(c)));
            _segments.addSegment(new Segment(pLeft, pRight, visible_circles), just_add_segment, compare_int_vectors);
        }

        function just_add_segment(s1:Vector.<int>, s2:Vector.<int>):Vector.<int> {
            if (s1 == null)
                return s2;
            else
                return s1;
        }

        var _finish:Date = new Date();
        trace('evaled segments in ', _finish.time - _start.time);
    }

    public function visible_circles_for_point(point:Point):SegmentsList {
        var anglesCircle:SegmentsList = new SegmentsList(2 * Math.PI, -1);

        var all_circles:Vector.<Circle> = new <Circle>[];
        for each (var c:Circle in circles)
            if (c.enabled)
                all_circles.push(c);

        //sort circles by distance
        all_circles.sort(function (c1:Circle, c2:Circle):Number {
            function dist(c:Circle):Number {
                var dx:Number = c.x - point.x;
                var dy:Number = c.y - point.y;
                return dx * dx + dy * dy;
            }

            return dist(c2) - dist(c1);
        });

        for each (c in all_circles) {
            var lines:Vector.<Line> = tangent_line(c.x, c.y, c.r, point.x, point.y, 0);
            var angles:Vector.<Number> = new <Number>[
                Math.atan2(lines[0].b, lines[0].a) - Math.PI / 2,
                Math.atan2(lines[0].b, lines[0].a) + Math.PI / 2,
                Math.atan2(lines[1].b, lines[1].a) - Math.PI / 2,
                Math.atan2(lines[1].b, lines[1].a) + Math.PI / 2
            ];

            //normalize angles
            for (var i:int = 0; i < angles.length; i++)
                angles[i] = normalize_angle(angles[i]);

            angles.sort(Array.NUMERIC);

            var a:Number = Math.atan2(c.y - point.y, c.x - point.x);

            a = normalize_angle(a);

            var s:Segment = null;
            for (i = 1; i < angles.length; i++)
                if (angles[i - 1] <= a && a < angles[i]) {
                    s = new Segment(angles[i - 1], angles[i], c.index);
                    break;
                }
            if (s == null)
                s = new Segment(angles[3], angles[0], c.index);

            anglesCircle.addSegment(s, function (was:int, now:int):int {
                return now;
            })
        }

        return anglesCircle;

        function normalize_angle(a:Number):Number {
            while (a < 0) a += 2 * Math.PI;
            while (a >= 2 * Math.PI) a -= 2 * Math.PI;
            return a;
        }
    }

    public static function anglesCircle2visibleCircles(anglesCircle:SegmentsList):Vector.<int> {
        var max_index:int = 20; //we have definitely less than 20 circles
        var has_circle:Vector.<Boolean> = new Vector.<Boolean>(max_index);
        for (var i:int = 0; i < max_index; i++)
            has_circle[i] = false;

        for each (var ss:Segment in anglesCircle.segments)
            if (ss.value >= 0)
                has_circle[ss.value] = true;

        var result:Vector.<int> = new <int>[];
        for (i = 0; i < max_index; i++)
            if (has_circle[i])
                result.push(i);
        return result;
    }

    private static function tangent_line(c1x:Number, c1y:Number, c1r:Number, c2x:Number, c2y:Number, c2r:Number):Vector.<Line> {
        var dx:Number = c2x - c1x;
        var dy:Number = c2y - c1y;
        var dr:Number = c2r - c1r;

        var d:Number = Math.sqrt(dx * dx + dy * dy);
        var X:Number = dx / d;
        var Y:Number = dy / d;
        var R:Number = dr / d;

        var RR:Number = Math.sqrt(1 - R * R);

        var a:Number = R * X - Y * RR;
        var b:Number = R * Y + X * RR;
        var c:Number = c1r - (a * c1x + b * c1y);

        var l1:Line = new Line(a, b, c);

        a = R * X + Y * RR;
        b = R * Y - X * RR;
        c = c1r - (a * c1x + b * c1y);

        var l2:Line = new Line(a, b, c);

        return new <Line>[l1, l2];
    }

    private function all_tangent_lines(c1:Circle, c2:Circle):Vector.<Number> {
        var outer:Vector.<Line> = tangent_line(c1.x, c1.y, c1.r, c2.x, c2.y, c2.r);
        var inner:Vector.<Line> = tangent_line(c1.x, c1.y, c1.r, c2.x, c2.y, -c2.r);
        var all_tangent:Vector.<Line> = new <Line>[outer[0], outer[1], inner[0], inner[1]];

        var all_points:Vector.<Number> = new <Number>[];
        for each (var l:Line in all_tangent) {
            var two_intersection_points:Vector.<Point> = intersect_with_line(l);

            _tangent_lines.push(two_intersection_points[0], two_intersection_points[1]);

            for each (var p:Point in two_intersection_points)
                all_points.push(point2location(p));
        }

        return all_points;
    }

    //circles and their indexes
    /*
     private function intersection_segments(c1:Circle, c2:Circle, i1:int, i2:int):Vector.<Segment> {
     var dx:Number = c2.x - c1.x;
     var dy:Number = c2.y - c1.y;
     var dr:Number = c2.r - c1.r;

     var d:Number = Math.sqrt(dx * dx + dy * dy);
     var X:Number = dx / d;
     var Y:Number = dy / d;
     var R:Number = dr / d;

     var RR:Number = Math.sqrt(1 - R * R);

     var a:Number = R * X - Y * RR;
     var b:Number = R * Y + X * RR;
     var c:Number = c1.r - (a * c1.x + b * c1.y);

     var l1:Line = new Line(a, b, c);

     a = R * X + Y * RR;
     b = R * Y - X * RR;
     c = c1.r - (a * c1.x + b * c1.y);

     var l2:Line = new Line(a, b, c);

     //wow, now we have two lines

     function putSegments(l:Line, sl:SegmentsList):void {
     var pnts:Vector.<Point> = intersect_with_line(l);

     if (pnts.length != 2)
     throw new IllegalOperationError("lines intersect in less than two points " + l.toString());

     _tangent_lines.push(pnts[0], pnts[1]);

     var p1:Number = point2location(pnts[0]);
     var p2:Number = point2location(pnts[1]);
     var s:Segment = new Segment(p1, p2, 1);

     var pp:Number = s.center(_MAX_SEGMENTS_LIST_VALUE);

     function add(a:int, b:int):int {
     return a + b;
     }

     //is pp on the other side of l compared to circles?
     if (l.apply(c1.center) * l.apply(location2point(pp)) < 0)
     sl.addSegment(s, add);
     else
     sl.addSegment(new Segment(p2, p1, 1), add);
     }

     var sl:SegmentsList = new SegmentsList(_MAX_SEGMENTS_LIST_VALUE, 0);

     putSegments(l1, sl);
     putSegments(l2, sl);

     var res:Vector.<Segment> = new <Segment>[];

     for each (var s:Segment in sl.segments) {
     if (s.value != 0) //if both are visible
     continue;

     //which one is visible
     var p:Point = location2point(s.center(_MAX_SEGMENTS_LIST_VALUE));
     var lenToC1:Number = p.subtract(c1.center).length;
     var lenToC2:Number = p.subtract(c2.center).length;

     if (lenToC1 < lenToC2) //c2 is not visible
     res.push(new Segment(s.start, s.end, new <int>[i2]));
     else //c1 is not visible
     res.push(new Segment(s.start, s.end, new <int>[i1]))
     }

     return res;
     }
     */

    // 5230

    public function get tangent_lines():Vector.<Point> {
        return _tangent_lines;
    }

    /**
     * intersect line with garden, return at most two intersection points
     * @param l
     * @return
     */
    private function intersect_with_line(l:Line):Vector.<Point> {
        var res:Vector.<Point> = new <Point>[];

        // 1) intersect with left line x = 0: b * y + c = 0
        if (Math.abs(l.b) >= EPS) {
            var y:Number = -l.c / l.b;
            if (y > -EPS && y < _H + EPS) {
                if (y < 0) y = 0;
                if (y > _H) y = _H;
                res.push(new Point(0, y));
            }
        }

        // 2) intersect with top line y = _H: a * x + b * _H + c = 0
        if (Math.abs(l.a) >= EPS) {
            var x:Number = (-l.c - l.b * _H) / l.a;
            if (x > -EPS && x < _W + EPS) {
                if (x < 0) x = 0;
                if (x > _W) x = _W;
                res.push(new Point(x, _H));
            }
        }

        // 3) intersect with right line x = _W: a * _W + b * y + c = 0
        if (Math.abs(l.b) >= EPS) {
            y = (-l.c - l.a * _W) / l.b;
            if (y > -EPS && y < _H + EPS) {
                if (y < 0) y = 0;
                if (y > _H) y = _H;
                res.push(new Point(_W, y));
            }
        }

        // 4) intersect with bottom line y = 0: a * x + c = 0
        if (Math.abs(l.a) >= EPS) {
            x = -l.c / l.a;
            if (x > -EPS && x < _W + EPS) {
                if (x < 0) x = 0;
                if (x > _W) x = _W;
                res.push(new Point(x, 0));
            }
        }

        if (res.length > 2)
            for (var ii:int = 0; ii < res.length; ii++)
                for (var jj:int = ii + 1; jj < res.length; jj++)
                    if (res[ii].x == res[jj].x && res[ii].y == res[jj].y)
                        res.splice(jj, 1);

        return res;
    }

    private static function compare_int_vectors(a:Vector.<int>, b:Vector.<int>):Boolean {
        if (a == null || b == null)
            return a == b;
        if (a.length != b.length)
            return false;
        for (var i:int = 0; i < a.length; i++)
            if (a[i] != b[i])
                return false;
        return true;
    }

    private static function union_int_vectors(a:Vector.<int>, b:Vector.<int>):Vector.<int> {
        var res:Vector.<int> = new <int>[];

        var i:int = 0;
        var j:int = 0;
        while (i < a.length && j < b.length) {
            if (a[i] < b[j])
                res.push(a[i++]);
            else if (a[i] > b[j])
                res.push(b[j++]);
            else {
                res.push(a[i]);
                i++;
                j++;
            }
        }

        while (i < a.length)
            res.push(a[i++]);
        while (j < b.length)
            res.push(b[j++]);

        return res;
    }

    public function location2side(n:Number):int {
        if (n < _H)
            return SIDE_LEFT;
        else if (n < _H + _W)
            return SIDE_TOP;
        else if (n < _H + _W + _H)
            return SIDE_RIGHT;
        else
            return SIDE_BOTTOM;
    }

    public function location2point(n:Number):Point {
        if (n < _H)
            return new Point(0, n);
        else if (n < _H + _W)
            return new Point(n - _H, _H);
        else if (n < _H + _W + _H)
            return new Point(_W, _H - (n - _H - _W));
        else
            return new Point(_W - (n - _H - _W - _H), 0);
    }

    public function point2location(p:Point):Number {
        if (p.x == 0)
            return p.y;
        if (p.y == _H)
            return _H + p.x;
        if (p.x == _W)
            return _H + _W + (_H - p.y);
        if (p.y == 0)
            return _H + _W + _H + (_W - p.x);
        throw new IllegalOperationError("point " + p + " is not on a garden perimeter");
    }

    public function get W():Number {
        return _W;
    }

    public function get H():Number {
        return _H;
    }

    public function get circles():Vector.<Circle> {
        return _circles;
    }

    public function get segments():SegmentsList {
        return _segments;
    }

    public function sideEnd(side:int):Point {
        switch (side) {
            case SIDE_LEFT:
                return new Point(0, _H);
            case SIDE_TOP:
                return new Point(_W, _H);
            case SIDE_RIGHT:
                return new Point(_W, 0);
            case SIDE_BOTTOM:
                return new Point(0, 0);
        }
        throw new IllegalOperationError("Unknown side " + side);
    }

    public function refreshCirclesStatus():void {
        for each (var c:Circle in _circles)
            c.enabled = true;

        for (var i:int = 0; i < _circles.length; i++) {
            var c1:Circle = _circles[i];

            for (var j:int = 0; j < i; j++) {
                var c2:Circle = _circles[j];

                if (c1.intersects(c2)) {
                    c1.enabled = false;
                    c2.enabled = false;
                }
            }

            if (c1.x + c1.r > _W || c1.x - c1.r < 0 || c1.y - c1.r < 0 || c1.y + c1.r > _H)
                c1.enabled = false;
        }
    }

    public function get MAX_SEGMENTS_LIST_VALUE():Number {
        return _MAX_SEGMENTS_LIST_VALUE;
    }

    public function getCircleByIndex(ind:int):Circle {
        for each (var c:Circle in _circles)
            if (c.index == ind)
                return c;
        return null;
    }
}
}