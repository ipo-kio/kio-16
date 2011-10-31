/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 26.02.11
 * Time: 17:05
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.ariadne.test {
import ru.ipo.kio._11.ariadne.model.Terra;

public class TestTerra implements Terra {

    public static const s:String =
        /* */ ".....MMMMMM........." +
        /* */ ".....MMMMMM........." +
        /* */ "...#######.........." +
        /* */ "..########.........." +
        /* */ "..####.............." +
        /* */ "...................." +
        /* */ "...................." +
        /* */ "....................";

    public function get width():int {
        return 20;
    }

    public function get height():int {
        return s.length / width;
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

        return "error land";
    }

    public function velocity(type:int):Number {
        switch (type) {
            case 0: return 90;
            case 1: return 70;
            case 2: return 50;
            case 3: return 10;
            case 4: return 1;
        }
        return -1;
    }
}
}
