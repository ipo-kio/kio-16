/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 02.03.11
 * Time: 0:30
 */
package ru.ipo.kio._11.ariadne.hero {
import flash.display.BitmapData;

public class Snake extends Hero {
    [Embed(source="../resources/hero/Snake_01.png")]
    private static const SPRITE_1:Class;
    private static const SPRITE_1_BMP:BitmapData = new SPRITE_1().bitmapData;

    [Embed(source="../resources/hero/Snake_02.png")]
    private static const SPRITE_2:Class;
    private static const SPRITE_2_BMP:BitmapData = new SPRITE_2().bitmapData;

    [Embed(source="../resources/hero/Snake_03.png")]
    private static const SPRITE_3:Class;
    private static const SPRITE_3_BMP:BitmapData = new SPRITE_3().bitmapData;

    [Embed(source="../resources/hero/Snake_04.png")]
    private static const SPRITE_4:Class;
    private static const SPRITE_4_BMP:BitmapData = new SPRITE_4().bitmapData;

    public function Snake() {
        phi0 = Math.PI / 2;
        sprites = [SPRITE_1_BMP, SPRITE_2_BMP, SPRITE_3_BMP, SPRITE_4_BMP];
        ms = 200;
        terra_type = 2;
    }
}
}
