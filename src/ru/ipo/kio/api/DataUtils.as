/**
 * Created by ilya on 07.02.14.
 */
package ru.ipo.kio.api {
public class DataUtils {

    public static function hash(s:String):uint {
        var result:uint = 17;

        for (var i:int = 0; i < s.length; i++) {
            result += s.charCodeAt(i);
            result *= 239;
        }

        return result;
    }

}
}
