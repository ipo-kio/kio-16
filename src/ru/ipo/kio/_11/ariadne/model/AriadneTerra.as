/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 25.02.11
 * Time: 17:08
 */
package ru.ipo.kio._11.ariadne.model {
import ru.ipo.kio._11.ariadne.AriadneProblem;
import ru.ipo.kio.api.KioApi;

public class AriadneTerra implements Terra {

    public static const s_old:String =
        /* */ "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM" +
        /* */ "M.................##########......................" +
        /* */ "M.................##########......................" +
        /* */ "M.................##########......................" +
        /* */ "M...~~~~~~~~~~~...##########...#####MMMMMMMMMM...." +
        /* */ "M...~~~~~~~~~~~...##########...#####MMMMMMMMMM...M" +
        /* */ "M...~~~~~~~~~~~........#####...#####MMMMMMMMMM...M" +
        /* */ "M...~~~~~~~~~~~........#####...#####MMMMMMMMMM...M" +
        /* */ "M...~~~~~~~~~~~........#####...#####.............M" +
        /* */ "M...~~~~~fffffffffff...#####...#####.............M" +
        /* */ "M...~~~~~fffffffffff...#####...#####.............M" +
        /* */ "M...~~~~~fffffffffff...#####...#####...ffffffffffM" +
        /* */ "M...~~~~~fffffffffff...#####...#####...ffffffffffM" +
        /* */ "M...#####fffffffffff...#####...#####...ffffffffffM" +
        /* */ "M...#####fffffffffff...#####...#####...ffffffffffM" +
        /* */ "M...#####fffffffffff...#####...#####.............M" +
        /* */ "M...#####fffffffffff...#####...#####.............M" +
        /* */ "M...#####..............#####...#####.............M" +
        /* */ "M...#####..............#####...#####MMMMMMMMMM...M" +
        /* */ "M...#####..............#####...#####MMMMMMMMMM...M" +
        /* */ "M...#####MMMM...~~~~~~~~~~~~...#####MMMMMMMMMM...M" +
        /* */ "M...#####MMMM...~~~~~~~~~~~~...#####MMMMMMMMMM...M" +
        /* */ "M...#####MMMM...~~~~~~~~~~~~...#####.............M" +
        /* */ "M...#####MMMM...~~~~~~~~~~~~...#####.............M" +
        /* */ "M...#####MMMM...~~~~~~~~~~~~...#####.............M" +
        /* */ "M...#####MMMM..................#####...ffffffffffM" +
        /* */ "M........MMMM..................#####...ffffffffffM" +
        /* */ "M........MMMM..................#####...ffffffffffM" +
        /* */ "M........MMMMMMMMMMMMMMMMMMMMMM#####...ffffffffffM" +
        /* */ "Mfffff...MMMMMMMMMMMMMMMMMMMMMM#####.............M" +
        /* */ "Mfffff...MMMMMMMMMMMMMMMMMMMMMM#####.............M" +
        /* */ "Mfffff...MMMMMMMMMMMMMMMMMMMMMM#####.............M" +
        /* */ "Mfffff...MMMM..............MMMM~~~~~~~~~~~~~~~...M" +
        /* */ "Mfffff...MMMM..............MMMM~~~~~~~~~~~~~~~...M" +
        /* */ "M........MMMM..............MMMM~~~~~~~~~~~~~~~...M" +
        /* */ "M........MMMM......#####...MMMM~~~~~~~~~~~~~~~...M" +
        /* */ "M........MMMM......#####...MMMM~~~~~~~~~~~~~~~...M" +
        /* */ "M...ffffffffffff...#####...MMMM~~~~~~~~..........M" +
        /* */ "M...ffffffffffff...#####...MMMM~~~~~~~~..........M" +
        /* */ "M...ffffffffffff...#####...MMMM~~~~~~~~..........M" +
        /* */ "M...ffffffffffff...#####...MMMM~~~~~~~~..........M" +
        /* */ "M..................#####.........................M" +
        /* */ "...................#####.........................M" +
        /* */ "...................#####.........................M" +
        /* */ "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM";

    public static const s:String =
        /* */ "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM" +
        /* */ "M.................##########......................" +
        /* */ "M.................##########......................" +
        /* */ "M.................##########......................" +
        /* */ "M...~~~~~~~~~~~...##########...#####MMMMMMMMMM...." +
        /* */ "M...~~~~~~~~~~~...##########...#####MMMMMMMMMM...M" +
        /* */ "M...~~~~~~~~~~~........#####...#####MMMMMMMMMM...M" +
        /* */ "M...~~~~~~~~~~~........#####...#####MMMMMMMMMM...M" +
        /* */ "M...~~~~~~~~~~~........#####...#####.............M" +
        /* */ "M...~~~~~fffffffffff...#####...#####.............M" +
        /* */ "M...~~~~~fffffffffff...#####...#####.............M" +
        /* */ "M...~~~~~fffffffffff...#####...#####ffff#########M" +
        /* */ "M...~~~~~fffffffffff...#####...#####ffff#########M" +
        /* */ "M...#####fffffffffff...#####...#####ffff#########M" +
        /* */ "M...#####fffffffffff...#####...#####ffff#########M" +
        /* */ "M...#####fffffffffff...#####...#####.............M" +
        /* */ "M...#####fffffffffff...#####...#####.............M" +
        /* */ "M...#####..............#####...#####.............M" +
        /* */ "M...#####..............#####...#####MMMMMMMMMffffM" +
        /* */ "M...#####..............#####...#####MMMMMMMMMffffM" +
        /* */ "M...#####MMMM...~~~~~~~~~~~~...#####MMMMMMMMMffffM" +
        /* */ "M...#####MMMM...~~~~~~~~~~~~...#####MMMMMMMMMffffM" +
        /* */ "M...#####MMMM...~~~~~~~~~~~~...#####.............M" +
        /* */ "M...#####MMMM...~~~~~~~~~~~~...#####.............M" +
        /* */ "M...#####MMMM...~~~~~~~~~~~~...#####.............M" +
        /* */ "M...#####MMMM..................#####ffffffff#####M" +
        /* */ "M........MMMM..................#####ffffffff#####M" +
        /* */ "M........MMMM..................#####ffffffff#####M" +
        /* */ "M........MMMMMMMMMMMMMMMMMMMMMM#####ffffffff#####M" +
        /* */ "Mfffff...MMMMMMMMMMMMMMMMMMMMMM#####.............M" +
        /* */ "Mfffff...MMMMMMMMMMMMMMMMMMMMMM#####.............M" +
        /* */ "Mfffff...MMMMMMMMMMMMMMMMMMMMMM#####.............M" +
        /* */ "Mfffff...MMMM..............MMMM~~~~~~~~~~~~~~~...M" +
        /* */ "Mfffff...MMMM..............MMMM~~~~~~~~~~~~~~~...M" +
        /* */ "M........MMMM..............MMMM~~~~~~~~~~~~~~~...M" +
        /* */ "M........MMMM......#####...MMMM~~~~~~~~~~~~~~~...M" +
        /* */ "M........MMMM......#####...MMMM~~~~~~~~~~~~~~~...M" +
        /* */ "M...ffffffffffff...#####...MMMM~~~~~~~~..........M" +
        /* */ "M...ffffffffffff...#####...MMMM~~~~~~~~..........M" +
        /* */ "M...ffffffffffff...#####...MMMM~~~~~~~~..........M" +
        /* */ "M...ffffffffffff...#####...MMMM~~~~~~~~..........M" +
        /* */ "M..................#####.........................M" +
        /* */ "...................#####.........................M" +
        /* */ "...................#####.........................M" +
        /* */ "MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM";

    private static var loc:Object = KioApi.getLocalization(AriadneProblem.ID);

    public function get width():int {
        return 50;
    }

    public function get height():int {
        return 45;
    }

    public function squareType(x:int, y:int):int {
        var ind:int = width * y + x;
        switch (s.charAt(ind)) {
            case '.' : return 0;
            case '~' : return 1;
            case 'f' : return 2;
            case '#' : return 3;
            case 'M' : return 4;
        }
        return -1;
    }

    public function description(type:int):String {
        switch (type) {
            case 0: return loc.hover.sand;
            case 1: return loc.hover.lake;
            case 2: return loc.hover.forest;
            case 3: return loc.hover.wall;
            case 4: return loc.hover.mountains;
        }
        return "error land";
    }

    public function velocity(type:int):Number {
        var velocity_info:Array = AriadneData.instance.velocity_info;
        if (velocity_info == null)
//            velocity_info = [90, 70, 50, 10, 1];
              velocity_info = [80, 65, 55, 20, 1];

        if (type < 0 || type >= velocity_info.length)
            return -1;
        return velocity_info[type];
    }
}
}
