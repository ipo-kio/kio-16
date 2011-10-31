/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 25.02.11
 * Time: 16:38
 */
package ru.ipo.kio._11.ariadne.model {
public class Rational {

    private var _n:int;
    private var _d:int;

    public function Rational(n:int, d:int) {
        _n = n;
        _d = d;
        normalize();
    }

    private function normalize():void {
        if (_d < 0) {
            _n = - _n;
            _d = - _d;
        }

        var a:int = Math.abs(_n);
        var b:int = _d;

        while (b != 0) {
            var t:int = b;
            b = a % b;
            a = t;
        }

        var gcd:int = a + b;

        _n /= gcd;
        _d /= gcd;
    }

    public function get n():int {
        return _n;
    }

    public function get d():int {
        return _d;
    }

    public function equals(r:Rational):Boolean {
        return _n == r._n && _d == r._d;
    }

    public function add(r:Rational):Rational {
        return new Rational(_n * r._d + r._n * _d, _d * r._d);
    }

    public function sub(r:Rational):Rational {
        return new Rational(_n * r._d - r._n * _d, _d * r._d);
    }

    //returns this
    public function add_(r:Rational):Rational {
        var d:int = _d * r._d;
        _n = _n * r._d + r._n * _d;
        _d = d;
        normalize();
        return this;
    }

    //returns this
    public function sub_(r:Rational):Rational {
        var d:int = _d * r._d;
        _n = _n * r._d - r._n * _d;
        _d = d;
        normalize();
        return this;
    }

    public function positive():Boolean {
        return _n > 0;
    }

    public function nonNegative():Boolean {
        return _n >= 0;
    }

    public function mul(r:Rational):Rational {
        return new Rational(r._n * _n, _d * r._d);
    }

    public function mul_(r:Rational):Rational {
        _n *= r._n;
        _d *= r._d;
        normalize();
        return this;
    }

    public function div(r:Rational):Rational {
        return new Rational(r._d * _n, _d * r._n);
    }

    public function div_(r:Rational):Rational {
        _n *= r._d;
        _d *= r._n;
        normalize();
        return this;
    }

    public function mul_int(a:int):Rational {
        return new Rational(a * _n, _d);
    }

    public function mul_int_(a:int):Rational {
        _n *= a;
        normalize();
        return this;
    }

    public function sub_int(a:int):Rational {
        return new Rational(_n - a * _d, _d);
    }

    public function toString():String {
        return "Rational{_n=" + String(_n) + ",_d=" + String(_d) + "}";
    }

    public function sqr_():Rational {
        _n *= _n;
        _d *= _d;
        return this;
    }

    public function get value():Number {
        return _n / _d;
    }

    /*public function get serialize():Object {
        return {n:_n, d:_d};
    }

    public static function unSerialize(value:Object):Rational {
        return new Rational(value.n, value.d);
    }*/
}
}
