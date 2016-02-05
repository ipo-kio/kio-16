package ru.ipo.kio._16.mars.model {

public class Orbit {
    private var _theta0:Number;
    private var _p:Number;
    private var _eps:Number;
    private var _a:Number;
    private var _b:Number;
    private var _c:Number;
    private var _n:Number;

    public function Orbit(theta0:Number, p:Number, eps:Number) {
        _theta0 = theta0;
        _p = p;
        _eps = eps;

        //https://fr.wikipedia.org/wiki/%C3%89quation_de_Kepler#Cas_de_l.27orbite_elliptique
        _a = _p / (1 - _eps * _eps);

        //eps = sqrt(1 - b^2 / a^2)
        //eps^2 = 1 - b^2 / a^2
        //b^2 / a^2 = 1 - eps^2
        //b = sqrt(1 - eps^2) * a
        _b = Math.sqrt(1 - sq(_eps)) * a;
        _c = _eps * _a;
        _n = Math.sqrt(Consts.MU / (_a * _a * _a));
    }

    public function position(t:Number):Vector2D {
        //https://en.wikipedia.org/wiki/Kepler%27s_laws_of_planetary_motion#Position_as_a_function_of_time

        var M:Number = _n * t;

        var E:Number = solveKeplerEquation(M, _eps);

        //(1-\varepsilon)\cdot\tan^2\frac \theta 2 = (1+\varepsilon)\cdot\tan^2\frac E 2
        var tan2theta2:Number = (1 + _eps) * sq(Math.tan(E / 2)) / (1 - _eps);

        var tan_theta2:Number = Math.sqrt(tan2theta2);
        var theta:Number = 2 * Math.atan(tan_theta2);
        if (E < 0)
            theta = -theta;

        var r:Number = _a * (1 - _eps * Math.cos(E));

        return Vector2D.createPolar(r, theta + _theta0);
    }

    public static function solveInitial(r0x:Number, r0y:Number, v0x:Number, v0y:Number):Orbit {
        var r:Number = Math.sqrt(sq(r0x) + sq(r0y));

        var r_x:Number = r0x / r;
        var r_y:Number = r0y / r;

        var t_x:Number = -r_y;
        //noinspection JSSuspiciousNameCombination
        var t_y:Number = r_x;

        var Vr:Number = v0x * r_x + v0y * r_y; //v0 . r_
        var Vt:Number = v0x * t_x + v0y * t_y; //v0 . t_

        var p:Number = sq(r * Vt) / Consts.MU;

        var V0:Number = Consts.MU / (r * Vt); //Math.sqrt(MU / p);

        var epsCosTheta:Number = Vt / V0 - 1;
        var epsSinTheta:Number = Vr / V0;

        var eps:Number = Math.sqrt(sq(epsCosTheta) + sq(epsSinTheta));

        //eps = 0 means circular orbit, so theta is meaningless
        if (eps < Consts._EPS)
            return new Orbit(0, p, eps);
        if (eps > 1 - Consts._EPS)
            return null;

        var theta:Number = Math.atan2(epsSinTheta, epsCosTheta);

        var thetaInitial:Number = Math.atan2(r0y, r0x);
        var theta0:Number = thetaInitial - theta;

        return new Orbit(theta0, p, eps);
    }

    public function theta2time(theta:Number):Number {
        theta -= theta0;

        var tan2E2:Number = (1 - _eps) * sq(Math.tan(theta / 2)) / (1 + _eps);

        var E:Number = 2 * Math.sqrt(tan2E2);
        if (theta < 0)
            E = -E;

        var M:Number = E - _eps * Math.sin(E);

        return M / _n; //M = nt
    }

    private static function sq(a:Number):Number {
        return a * a;
    }

    private static function solveKeplerEquation(M:Number, eps:Number):Number {
        //M = E - eps * sin(E)

        //http://mathworld.wolfram.com/KeplersEquation.html
        //E(i+1)=M + e sin E_i, E_0 = 0
        //E(i+1)=E(i) + [M + e sin E_i - E_i] / [1 - e cos E_i]

        var E_i:Number = 0;
        for (var i:int = 0; i < 20; i++)
//            E_i = M + eps * Math.sin(E_i);
            E_i = E_i + (M + eps * Math.sin(E_i) - E_i) / (1 - eps * Math.cos(E_i));

        return E_i;
    }

    public function get theta0():Number {
        return _theta0;
    }

    public function get p():Number {
        return _p;
    }

    public function get eps():Number {
        return _eps;
    }

    public function get a():Number {
        return _a;
    }

    public function get b():Number {
        return _b;
    }

    public function get c():Number {
        return _c;
    }
}
}
