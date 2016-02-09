package ru.ipo.kio._16.rockgarden.model {
public class SegmentsList {

    private var _maxValue:Number;
    private var _segments:Vector.<Segment>;
    private var _initialValue:*;

    public function SegmentsList(maxValue:Number, initialValue:* = null) {
        _maxValue = maxValue;
        _initialValue = initialValue;

        _segments = new <Segment>[];
    }

    public static function eq(a:*, b:*):Boolean {
        return a == b;
    }

    public function addSegment(s:Segment, union:Function, comparator:Function = null):void {
        if (comparator == null)
            comparator = eq;

        if (_segments.length == 0) {
            _segments.push(new Segment(s.start, s.end, union(_initialValue, s.value)));
            _segments.push(new Segment(s.end, s.start, _initialValue));

            return;
        }

        var new_segments:Vector.<Segment> = insert_general_case(s, union);

        _segments = normalize(new_segments, comparator);

        if (_segments.length == 1) {
            _initialValue = _segments[0].value;
            _segments = new <Segment>[];
        }
    }

    private function insert_general_case(s:Segment, union:Function):Vector.<Segment> {
        var points:Vector.<PointDescription> = new Vector.<PointDescription>(_segments.length + 2, true);
        points[0] = new PointDescription(s.start, true, s);
        points[1] = new PointDescription(s.end, true, null);
        for (var i:int = 0; i < _segments.length; i++) {
            var ss:Segment = _segments[i];
            points[i + 2] = new PointDescription(ss.start, false, ss);
        }

        points.sort(function (d1:PointDescription, d2:PointDescription):Number {
            return d1.pos - d2.pos;
        });

        //search for the new segment start
        for (var start_ind:int = 0; start_ind < points.length; start_ind++)
            if (points[start_ind].is_new && points[start_ind].start_of != null)
                break;

        var prev_start_ind:int = start_ind;
        while (true) {
            prev_start_ind = prev_start_ind - 1;
            if (prev_start_ind < 0)
                prev_start_ind += points.length;
            if (!points[prev_start_ind].is_new)
                break;
        }

        var new_segments:Vector.<Segment> = new <Segment>[];
        var inside:Boolean = true;
        var pd_prev:PointDescription = points[start_ind];
        var prev_value:* = points[prev_start_ind].start_of.value;
        var break_next_time:Boolean = false;
        for (i = start_ind + 1; !break_next_time; i++) {
            //normalize i
            if (i >= points.length)
                i = 0;

            if (i == start_ind)
                break_next_time = true;

            var pd_next:PointDescription = points[i];

            var new_value:* = inside ? union(prev_value, s.value) : prev_value;
            new_segments.push(new Segment(pd_prev.pos, pd_next.pos, new_value));

            if (pd_next.is_new && pd_next.start_of == null)
                inside = false;
            if (!pd_next.is_new)
                prev_value = pd_next.start_of.value;
            pd_prev = pd_next;
        }

        return new_segments;
    }

    /*
     private function insert_general_case(s:Segment, union:Function):Vector.<Segment> {
     var begin_ind:int;

     for (var i:int = 0; i < _segments.length; i++) {
     var ss:Segment = _segments[i];

     //searching for begin in ss
     if (s.start == ss.start || ss.pointInside(s.start)) {
     begin_ind = i;
     break;
     }
     }

     var new_segments:Vector.<Segment> = new <Segment>[];
     var inside:Boolean = true;
     i = begin_ind;

     var prev:Number = s.start;
     while (true) {
     ss = _segments[i];

     if (inside) {
     if (ss.pointInside(prev))
     new_segments.push(new Segment(ss.start, prev, ss.value));

     if (ss.pointInside(s.end) || ss.end == s.end) {
     new_segments.push(new Segment(prev, s.end, union(ss.value, s.value)));
     if (s.end != ss.end)
     new_segments.push(new Segment(s.end, ss.end, ss.value));
     inside = false;
     } else {
     new_segments.push(new Segment(prev, ss.end, union(ss.value, s.value)));
     prev = ss.end;
     }
     } else
     new_segments.push(ss);

     //increment i
     i++;
     if (i >= _segments.length)
     i = 0;
     if (i == begin_ind)
     break;
     }
     return new_segments;
     }
     */

    private function normalize(segments:Vector.<Segment>, comparator:Function):Vector.<Segment> {
        //1st, remove all zero segments
        var i:int = 0;
        while (i < segments.length && segments.length > 1) {

            var j:int = i + 1;
            if (j >= segments.length)
                j = 0;

            var si:Segment = segments[i];
            var sj:Segment = segments[j];

            //test si and sj collapse
            var collapse:int = -1; //0 means store i value, 1 means store j value, -1 means no collapse
            if (si.distance(_maxValue) < Garden.EPS)
                collapse = 1;
            if (sj.distance(_maxValue) < Garden.EPS)
                collapse = 0;
            if (comparator(si.value, sj.value))
                collapse = 0;

            if (collapse >= 0) {
                segments.splice(i, 2, new Segment(si.start, sj.end, collapse == 0 ? si.value : sj.value));
                if (j == 0)
                    segments.splice(0, 1);
            } else
                i++;
        }

        return segments;
    }

    public function get segments():Vector.<Segment> {
        if (_segments.length == 0)
            return new <Segment>[new Segment(0, _maxValue, _initialValue)];
        return _segments;
    }

    public function toString():String {
        var res:String = "";
        for each (var s:Segment in _segments) {
            res += s.toString();
        }
        return res;
    }

    public function modify(f:Function, _newMaxValue:Number = 0):void {
        if (_newMaxValue > 0)
                _maxValue = _newMaxValue;

        for each (var s:Segment in _segments) {
            s.start = f(s.start);
            s.end = f(s.end);

            while (s.start < 0)
                s.start += _maxValue;
            while (s.end < 0)
                s.end += _maxValue;

            while (s.start >= _maxValue)
                s.start -= _maxValue;
            while (s.end >= _maxValue)
                s.end -= _maxValue;
        }
    }

    public function get maxValue():Number {
        return _maxValue;
    }
}
}