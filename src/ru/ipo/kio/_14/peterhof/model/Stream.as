/**
 * Created by ilya on 18.01.14.
 */
package ru.ipo.kio._14.peterhof.model {
public class Stream {

    private var _points:Vector.<Point3D> = new Vector.<Point3D>();
    private var _length:Number;
    private var _goes_out:Boolean = false;

    public function Stream(x0:Number, y0:Number, z0:Number, L:Number, alpha:Number, phi:Number, l:Number, s:Number) {
        if (L < 0) {
            _length = 0;
            _goes_out = false;
            return;
        }

        var v0:Number = getV0(Consts.WATER_EXTRA_HEIGHT + Consts.HILL_HEIGHT - y0, L, l, s);

        buildStream(x0, y0, z0, v0, alpha, phi);
    }

    public function get points():Vector.<Point3D> {
        return _points;
    }

    public function get length():Number {
        return _length;
    }

    public function get goes_out():Boolean {
        return _goes_out;
    }

    private static function getV0(h:Number, L:Number, l:Number, s:Number):Number {
        //(7) formula C0 = A0 * v^2 + B0 * v
        var c0:Number = Consts.G * Consts.RHO * h; // m/s^2 * kg/m^3 * m = kg / (m s^2)
        var a0:Number = Consts.RHO / 2; // kg / m^3 * (m / s)^2 = kg / (m s^2)
        var b0:Number = 8 * Math.PI * Consts.ETA * L * s / (Consts.S * Consts.S); //kg / (m s) / m * (m/s)
        b0 += 8 * Math.PI * Consts.ETA * l / s;

        var d:Number = b0 * b0 + 4 * a0 * c0;
        return (-b0 + Math.sqrt(d)) / (2 * a0);
    }

    private function buildStream(x0:Number, y0:Number, z0:Number, v0:Number, alpha:Number, phi:Number):void {
        var t:Number = 0;
        _length = 0;

        var cosAlpha:Number = Math.cos(alpha);
        var sinAlpha:Number = Math.sin(alpha);

        var cosPhi:Number = Math.cos(phi);
        var sinPhi:Number = Math.sin(phi);

        var xPrev:Number = 0;
        var yPrev:Number = 0;

        var iteration:int = 0;
        while (iteration++ < 1000) {
            var exp:Number = (1 - Math.exp(-Consts.K * t));

            var xt:Number = v0 * cosAlpha * exp / Consts.K; // (11)
            var yt:Number = ((v0 * sinAlpha + Consts.G / Consts.K) * exp - Consts.G * t) / Consts.K;

            //convert to 3d space xx, yy, zz
            var xx:Number = x0 + xt * cosPhi;
            var yy:Number = y0 + yt;
            var zz:Number = z0 + xt * sinPhi;

            //stop if lower than ground
            if (yy < Hill.xz2y(xx, zz))
                break;

            //test to go out of field
            if (xx < 0 || xx > Consts.HILL_LENGTH1 + Consts.HILL_LENGTH2 || zz < 0 || zz > Consts.HILL_WIDTH) {
                _goes_out = true;
                break;
            }

            var dx:Number = xt - xPrev;
            var dy:Number = yt - yPrev;
            _length += Math.sqrt(dx * dx + dy * dy);
            xPrev = xt;
            yPrev = yt;

            _points.push(new Point3D(xx - x0, yy - y0, zz - z0));

            t += Consts.DELTA_T;
        }
    }
}
}
