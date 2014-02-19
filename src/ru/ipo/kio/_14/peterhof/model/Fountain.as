/**
 * Created by ilya on 14.01.14.
 */
package ru.ipo.kio._14.peterhof.model {
import flash.events.Event;
import flash.events.EventDispatcher;

public class Fountain extends EventDispatcher {

    private var _x:Number;
    private var _z:Number;
    private var _l:Number;
    private var _d:Number;
    private var _alphaGr:Number;
    private var _phiGr:Number;

    private var _hill:Hill;
    private var _stream:Stream = null;
    //lazy evaluated

    public function Fountain(hill:Hill) {
        _hill = hill;
        _x = 0;
        _z = 0;
    }

    private function change():void {
        _stream = null;
        dispatchEvent(new Event(Event.CHANGE));
    }

    public function get x():Number {
        return _x;
    }

    public function set x(value:Number):void {
        if (_x == value)
            return;
        _x = value;
        change();
    }

    public function get y():Number {
        return Hill.xz2y(_x, _z);
    }

    public function get z():Number {
        return _z;
    }

    public function set z(value:Number):void {
        if (_z == value)
            return;
        _z = value;
        change();
    }

    public function get l():Number {
        return _l;
    }

    public function set l(value:Number):void {
        if (_l == value)
            return;
        _l = value;
        change();
    }

    public function get d():Number {
        return _d;
    }

    public function set d(value:Number):void {
        if (_d == value)
            return;
        _d = value;
        change();
    }

    public function get alphaGr():Number {
        return _alphaGr;
    }

    public function set alphaGr(value:Number):void {
        if (_alphaGr == value)
            return;
        _alphaGr = value;
        change();
    }

    public function get phiGr():Number {
        return _phiGr;
    }

    public function set phiGr(value:Number):void {
        if (_phiGr == value)
            return;
        _phiGr = value;
        change();
    }

    public function get stream():Stream {
        if (_stream == null) {
            var L:Number = Hill.pipeLengthTo(_x, _z);
            var s:Number = _d * _d / 4 * Math.PI;
            _stream = new Stream(_x, Hill.xz2y(_x, _z), _z, L, _alphaGr * Math.PI / 180, _phiGr * Math.PI / 180, _l, s);
        }
        return _stream;
    }

    public function get hill():Hill {
        return _hill;
    }

    public function invalidate_stream():void {
        _stream = null;
        change();
    }

    public function serialize():Object {
        return {
            x: _x,
            z: _z,
            l: _l,
            d: _d,
            alphaGr: _alphaGr,
            phiGr: _phiGr
        };
    }

    public function deserialize(o:Object):void {
        _x = o.x;
        _z = o.z;
        _l = o.l;
        _d = o.d;
        _alphaGr = o.alphaGr;
        _phiGr = o.phiGr;

        change();
    }
}
}
