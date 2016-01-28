package ru.ipo.kio._16.rockgarden.model {
public class SegmentInfo {

    private var _shortText:String;
    private var _longText:String;

    public function SegmentInfo(shortText:String, longText:String) {
        _shortText = shortText;
        _longText = longText;
    }

    public function get shortText():String {
        return _shortText;
    }

    public function get longText():String {
        return _longText;
    }
}
}
