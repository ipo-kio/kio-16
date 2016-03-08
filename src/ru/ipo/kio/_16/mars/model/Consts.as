package ru.ipo.kio._16.mars.model {
import flash.display.BitmapData;

import ru.ipo.kio._16.mars.view.BodyView;

public class Consts {

    public static const _EPS:Number = 1e-10;

    public static const SUN_M:Number = 1.9885e30; //kg
    public static const G:Number = 6.67e-11; // м3·с−2·кг−1
    public static const MU:Number = SUN_M * G;

    public static const EARTH_M:Number = 5.9726e24; //kg
    public static const EARTH_R:Number = 149.6e9; //m
    public static const EARTH_Vt:Number = Math.sqrt(MU / EARTH_R); //https://en.wikipedia.org/wiki/Kepler_orbit , Determination of the Kepler orbit that corresponds to a given initial state
    public static const EARTH_ORBIT_R:Number = 6600000; //8000000; //6371000;
    public static const EARTH_V1:Number = Math.sqrt(G * EARTH_M / EARTH_ORBIT_R);
    public static const EARTH_V2:Number = EARTH_V1 * Math.sqrt(2);

    public static const MARS_M:Number = 6.4185e23; //kg
    public static const MARS_R:Number = 227.9e9; //m
    public static const MARS_Vt:Number = Math.sqrt(MU / MARS_R); //https://en.wikipedia.org/wiki/Kepler_orbit , Determination of the Kepler orbit that corresponds to a given initial state

    public static const dt:Number = 60 * 60 * 24; //1 day
    public static const MAX_TIME:int = 2000; //5 * 365; //5 years in days

    public static const MAX_DIST:Number = 982000000; //Hill Sphere
    public static const MAX_SPEED:Number = 3450; //43610; //Max orbit

    public static const AU:Number = 149597870700;
    public static const planets_orbits:Vector.<Number> = new <Number>[ //http://lnfm1.sai.msu.ru/neb/rw/natsat/plaorbw.htm
        0.3870983098,
        0.7233298200,
        1.0000010178,
        1.5236793419,
        5.2026032092,
        9.5549091915,
        19.2184460618,
        30.1103868694
    ];
    public static const planets_names:Vector.<String> = new <String>[
        "Меркурий",
        "Венера",
        "Земля",
        "Марс",
        "Юпитер",
        "Сатурн",
        "Уран",
        "Нептун"
    ];
    public static const planet_view:Vector.<BitmapData> = new <BitmapData>[
        BodyView.MERCURY_BMP,
        BodyView.VENERA_BMP,
        BodyView.EARTH_BMP,
        BodyView.MARS_BMP,
        BodyView.JUPITER_BMP,
        BodyView.SATURN_BMP,
        BodyView.URAN_BMP,
        BodyView.NEPTUN_BMP
    ];
    public static const orbits_between:Vector.<int> = new <int>[
            3,
            2,
            3,
            4,
            6,
            7,
            8,
            9
    ];
}
}
