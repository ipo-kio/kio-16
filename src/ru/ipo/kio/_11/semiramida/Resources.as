/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 16.02.11
 * Time: 16:41
 */
package ru.ipo.kio._11.semiramida {
import mx.core.BitmapAsset;

public class Resources {

    [Embed(source="resources/flowers_old.jpg")]
    private static const FLOWERS:Class;
    public static const Flowers:BitmapAsset = new FLOWERS;

    [Embed(source="resources/flowers2.jpg")]
    private static const FLOWERS2:Class;
    public static const Flowers2:BitmapAsset = new FLOWERS2;

    [Embed(source="resources/bg.png")]
    private static const BG:Class;
    public static const Bg:BitmapAsset = new BG;
}
}
