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

    //hsv code is taken from https://gist.github.com/trystan/5021485
    public static function hsv(h:Number, s:Number, v:Number):uint
    {
        var r:Number, g:Number, b:Number, i:Number, f:Number, p:Number, q:Number, t:Number;
        h %= 360;
        if (v == 0)
            return rgb(0, 0, 0);
        s /= 100;
        v /= 100;
        h /= 60;
        i = Math.floor(h);
        f = h - i;
        p = v * (1 - s);
        q = v * (1 - (s * f));
        t = v * (1 - (s * (1 - f)));
        switch (i)
        {
            case 0: r = v; g = t; b = p; break;
            case 1: r = q; g = v; b = p; break;
            case 2: r = p; g = v; b = t; break;
            case 3: r = p; g = q; b = v; break;
            case 4: r = t; g = p; b = v; break;
            case 5: r = v; g = p; b = q; break;
        }
        return rgb(Math.floor(r*255), Math.floor(g*255), Math.floor(b*255));
    }

    public static function rgb (r:int, g:int, b:int):uint
    {
        return (255 << 24) | (r << 16) | (g << 8) | b;
    }

}
}
