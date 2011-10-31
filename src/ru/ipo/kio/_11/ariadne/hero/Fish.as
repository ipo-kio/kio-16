/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 02.03.11
 * Time: 0:27
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._11.ariadne.hero {
import flash.display.BitmapData;

public class Fish extends Hero {
    [Embed(source="../resources/hero/Fish_01.png")]
    private static const SPRITE_1:Class;
    private static const SPRITE_1_BMP:BitmapData = new SPRITE_1().bitmapData;

    [Embed(source="../resources/hero/Fish_02.png")]
    private static const SPRITE_2:Class;
    private static const SPRITE_2_BMP:BitmapData = new SPRITE_2().bitmapData;

    [Embed(source="../resources/hero/Fish_03.png")]
    private static const SPRITE_3:Class;
    private static const SPRITE_3_BMP:BitmapData = new SPRITE_3().bitmapData;

    [Embed(source="../resources/hero/Fish_04.png")]
    private static const SPRITE_4:Class;
    private static const SPRITE_4_BMP:BitmapData = new SPRITE_4().bitmapData;

    public function Fish() {
        phi0 = -Math.PI / 2;
        sprites = [SPRITE_1_BMP, SPRITE_2_BMP, SPRITE_3_BMP, SPRITE_4_BMP];
        ms = 200;
        terra_type = 1;
    }
}
}
