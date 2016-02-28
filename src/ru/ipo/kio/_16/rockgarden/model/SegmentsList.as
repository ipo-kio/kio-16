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

    private static var __timings:Vector.<Number>;
    private static var __counts:Vector.<int>;
    private static var __starts:Vector.<Number>;

    public static function __reset_timings():void {
        __timings = new Vector.<Number>(100);
        __counts = new Vector.<int>(100);
        __starts = new Vector.<Number>(100);

        function zero():int {
            return 0
        }

        __timings = __timings.map(zero);
        __counts = __counts.map(zero);
        __starts = __starts.map(zero);
    }

    private static function __start_block_timing(ind:int, _time:Number = 0):void {
        if (_time == 0)
            _time = new Date().time;
        __starts[ind] = _time;
    }
    private static function __stop_block_timing(ind:int, _time:Number = 0):void {
        if (_time == 0)
            _time = new Date().time;
        var elapsed:Number = _time - __starts[ind];
        __counts[ind]++;
        __timings[ind] += elapsed;
    }
    private static function __stop_start_block_timing(ind1:int, ind2:int):void {
        var _time:Number = new Date().time;
        __start_block_timing(ind2, _time);
        __stop_block_timing(ind1, _time);
    }
    public static function __trace_timings():void {
        for (var i:int = 0; i < __counts.length; i++) {
            var c:int = __counts[i];
            if (c == 0)
                continue;
//            trace("timing block " + i, __timings[i] / c, "*", c, "=", __timings[i]);
        }
    }

    private function insert_general_case(s:Segment, union:Function):Vector.<Segment> {
        __start_block_timing(1);

        var points:Vector.<PointDescription> = new Vector.<PointDescription>(_segments.length + 2, true);
        points[0] = new PointDescription(s.start, true, s);
        points[1] = new PointDescription(s.end, true, null);
        for (var i:int = 0; i < _segments.length; i++) {
            var ss:Segment = _segments[i];
            points[i + 2] = new PointDescription(ss.start, false, ss);
        }

        __stop_start_block_timing(1, 11);

        points.sort(function (d1:PointDescription, d2:PointDescription):Number {
            return d1.pos - d2.pos;
        });

        __stop_start_block_timing(11, 12);

        //search for the new segment start
        for (var start_ind:int = 0; start_ind < points.length; start_ind++)
            if (points[start_ind].is_new && points[start_ind].start_of != null)
                break;

        __stop_start_block_timing(12, 2);

        var prev_start_ind:int = start_ind;
        while (true) {
            prev_start_ind = prev_start_ind - 1;
            if (prev_start_ind < 0)
                prev_start_ind += points.length;
            if (!points[prev_start_ind].is_new)
                break;
        }

        __stop_start_block_timing(2, 3);

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

        __stop_block_timing(3);

        return new_segments;
    }

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

    public function modify(f:Function, swap:Boolean = false, newMaxValue:Number = 0):void {
        if (newMaxValue > 0)
            _maxValue = newMaxValue;

        for each (var s:Segment in _segments) {
            var newStart:Number = swap ? f(s.end) : f(s.start);
            var newEnd:Number = swap ? f(s.start) : f(s.end);

            s.start = newStart;
            s.end = newEnd;

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