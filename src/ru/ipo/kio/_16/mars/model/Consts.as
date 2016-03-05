package ru.ipo.kio._16.mars.model {
public class Consts {

    public static const _EPS:Number = 1e-10;

    public static const SUN_M:Number = 1.9885e30; //kg
    public static const G:Number = 6.67e-11; // м3·с−2·кг−1
    public static const MU:Number = SUN_M * G;

    public static const EARTH_M:Number = 5.9726e24; //kg
    public static const EARTH_R:Number = 149.6e9; //m
    public static const EARTH_Vt:Number = Math.sqrt(MU / EARTH_R); //https://en.wikipedia.org/wiki/Kepler_orbit , Determination of the Kepler orbit that corresponds to a given initial state

    public static const MARS_M:Number = 6.4185e23; //kg
    public static const MARS_R:Number = 227.9e9; //m
    public static const MARS_Vt:Number = Math.sqrt(MU / MARS_R); //https://en.wikipedia.org/wiki/Kepler_orbit , Determination of the Kepler orbit that corresponds to a given initial state

    public static const dt:Number = 60 * 60 * 24; //1 day
    public static const MAX_TIME:int = 2000; //5 * 365; //5 years in days

    public static const MAX_DIST:Number = 982000000; //Hill Sphere
    public static const MAX_SPEED:Number = 43610; //Max orbit
}
}
