/**
 * Created by ilya on 19.01.14.
 */
package ru.ipo.kio._14.peterhof.model {
public class Point3D {

    private var _x:Number;
    private var _y:Number;
    private var _z:Number;

    public function Point3D(x:Number, y:Number, z:Number) {
        _x = x;
        _y = y;
        _z = z;
    }

    public function get x():Number {
        return _x;
    }

    public function get y():Number {
        return _y;
    }

    public function get z():Number {
        return _z;
    }
}
}
