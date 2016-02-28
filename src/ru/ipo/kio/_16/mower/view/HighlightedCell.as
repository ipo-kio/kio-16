package ru.ipo.kio._16.mower.view {
public class HighlightedCell {

    private var _i:int;
    private var _j:int;
    private var _c:uint;
    private var _small:Boolean;
    private var _alpha:Number;

    public function HighlightedCell(i:int, j:int, c:uint, small:Boolean, alpha:Number = 1) {
        _i = i;
        _j = j;
        _c = c;
        _small = small;
        _alpha = alpha;
    }

    public function get i():int {
        return _i;
    }

    public function get j():int {
        return _j;
    }

    public function get c():uint {
        return _c;
    }

    public function get small():Boolean {
        return _small;
    }

    public function get alpha():Number {
        return _alpha;
    }

    public function equals(hc:HighlightedCell):Boolean {
        if (hc == null)
            return false;
        return hc._i == _i && hc._j == _j && hc._c == _c && hc._small == _small;
    }
}
}
