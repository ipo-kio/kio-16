/**
 * Created by ilya on 07.02.14.
 */
package ru.ipo.kio.api {
import flash.utils.ByteArray;

public class DataUtils {

    public static function hash(s:String):uint {
        var result:uint = 17;

        for (var i:int = 0; i < s.length; i++) {
            result += s.charCodeAt(i);
            result *= 239;
        }

        return result;
    }

    public static function convertByteArrayToString(ba:ByteArray):String {
        var result:String = "";

        for (var i:int = 0; i < ba.length; i++)
            result += ba[i].toString(16);

        return result;
    }

}
}
