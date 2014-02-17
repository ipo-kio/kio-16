/**
 * Created by ilya on 18.01.14.
 */
package ru.ipo.kio._14.peterhof.model {
public class Consts {

    public static const HILL_LENGTH1:int = 50;
    public static const HILL_LENGTH2:int = 75;
    public static const HILL_LENGTH:int = HILL_LENGTH1 + HILL_LENGTH2;

    public static const HILL_WIDTH:int = 100;
    public static const HILL_HEIGHT:int = 50;
    public static const WATER_EXTRA_HEIGHT:int = 0;
    public static var MIN_DIST:int = 30;

    public static const HILL_LENGTH1_ANGLE:Number = Math.sqrt(HILL_LENGTH1 * HILL_LENGTH1 + HILL_HEIGHT * HILL_HEIGHT);

    public static const PIXELS_IN_METER:Number = 2;

    public static const DELTA_T:Number = 0.01;
    public static const SPRITES_IN_STREAM:int = 50;

    public static const FOUNTAIN_PRECISION:int = 5;

    //physical constants
    public static var D:Number = 0.1; //10 cm
    public static var S:Number = D * D / 4 * Math.PI; // m^2

    public static var RHO:Number = 0.99913 * 1000000 / 1000; //gram/cm^3 -> kg / m^3
    public static var ETA:Number = 1.140 / 1000; //mPascal * sec = kg / (m s) [Pascal = N/m^2 = kg * m / s^2 / m^2 = kg / (s^2 m)]
    public static var G:Number = 9.81908;
    public static var K:Number = 0.0001; // air

    //hill skin
    public static const SKIN_X0:int = 128;
    public static const SKIN_Z0:int = 128;
    public static const SKIN_WIDTH:int = 832; //1024 - 128 - 64
    public static const SKIN_HEIGHT:int = 768;

    public static const QUALITY:Boolean = true;
}
}