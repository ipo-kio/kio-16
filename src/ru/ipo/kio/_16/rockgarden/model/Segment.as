package ru.ipo.kio._16.rockgarden.model {

public class Segment {

    private var _start:Number;
    private var _end:Number;
    private var _value:*;

    public function Segment(start:Number, end:Number, value:* = null) {
        _start = start;
        _end = end;
        _value = value;
    }

    public function get start():Number {
        return _start;
    }

    public function get end():Number {
        return _end;
    }

    public function get value():* {
        return _value;
    }

    public function set start(value:Number):void {
        _start = value;
    }

    public function set end(value:Number):void {
        _end = value;
    }

    public function set value(value:*):void {
        _value = value;
    }

    public function pointInside(p:Number):Boolean {
        if (_start < _end)
            return _start < p && p < _end;
        else
            return p < _end || p > _start;
    }

    public function center(maxValue:Number):Number {
        return line_center(_start, _end, maxValue)
    }

    public static function line_center(l:Number, r:Number, maxValue:Number):Number {
        if (l < r)
            return (l + r) / 2;
        else {
            var p:Number = (l + r + maxValue) / 2;
            if (p >= maxValue)
                p -= maxValue;
            return p;
        }
    }

    public function distance(maxValue:Number):Number {
        if (Math.abs(_start - _end) < Garden.EPS)
            return 0;
        if (_start < _end)
            return _end - _start;
        else
            return maxValue - _start + _end;
    }

    public function toString():String {
        return "[" + _start.toFixed(2) + " - " + _value + " - " + _end.toFixed(2) + "]";
    }
}
}
