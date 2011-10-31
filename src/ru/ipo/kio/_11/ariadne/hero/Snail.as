/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 01.03.11
 * Time: 23:19
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.ariadne.hero {
import flash.display.BitmapData;

public class Snail extends Hero {

    [Embed(source="../resources/hero/Snail_01.png")]
    private static const SPRITE_1:Class;
    private static const SPRITE_1_BMP:BitmapData = new SPRITE_1().bitmapData;

    [Embed(source="../resources/hero/Snail_02.png")]
    private static const SPRITE_2:Class;
    private static const SPRITE_2_BMP:BitmapData = new SPRITE_2().bitmapData;

    [Embed(source="../resources/hero/Snail_03.png")]
    private static const SPRITE_3:Class;
    private static const SPRITE_3_BMP:BitmapData = new SPRITE_3().bitmapData;

    public function Snail() {
        sprites = [SPRITE_1_BMP, SPRITE_2_BMP, SPRITE_3_BMP];
        ms = 300;
        terra_type = 4;
    }
}
}
