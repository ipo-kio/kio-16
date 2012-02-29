/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 24.02.11
 * Time: 8:52
 */
package ru.ipo.kio.base.displays {
import flash.display.BitmapData;

import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.api.controls.GraphicsButton;

public class ShellButton extends GraphicsButton {

    //small button

    [Embed(source="../resources/buttons/button01a.png")]
    private static const BUTTON_NORMAL:Class;
    private static const BUTTON_NORMAL_BMP:BitmapData = new BUTTON_NORMAL().bitmapData;

    [Embed(source="../resources/buttons/button01b.png")]
    private static const BUTTON_OVER:Class;
    private static const BUTTON_OVER_BMP:BitmapData = new BUTTON_OVER().bitmapData;

    [Embed(source="../resources/buttons/button01c.png")]
    private static const BUTTON_DOWN:Class;
    private static const BUTTON_DOWN_BMP:BitmapData = new BUTTON_DOWN().bitmapData;

    //big button

    [Embed(source="../resources/buttons/button_big_01.png")]
    private static const BIG_BUTTON_NORMAL:Class;
    private static const BIG_BUTTON_NORMAL_BMP:BitmapData = new BIG_BUTTON_NORMAL().bitmapData;

    [Embed(source="../resources/buttons/button_big_02.png")]
    private static const BIG_BUTTON_OVER:Class;
    private static const BIG_BUTTON_OVER_BMP:BitmapData = new BIG_BUTTON_OVER().bitmapData;

    [Embed(source="../resources/buttons/button_big_03.png")]
    private static const BIG_BUTTON_DOWN:Class;
    private static const BIG_BUTTON_DOWN_BMP:BitmapData = new BIG_BUTTON_DOWN().bitmapData;


    [Embed(source="../resources/buttons/button_high_01.png")]
    private static const HIGH_BUTTON_NORMAL:Class;
    private static const HIGH_BUTTON_NORMAL_BMP:BitmapData = new HIGH_BUTTON_NORMAL().bitmapData;

    [Embed(source="../resources/buttons/button_high_02.png")]
    private static const HIGH_BUTTON_OVER:Class;
    private static const HIGH_BUTTON_OVER_BMP:BitmapData = new HIGH_BUTTON_OVER().bitmapData;

    [Embed(source="../resources/buttons/button_high_03.png")]
    private static const HIGH_BUTTON_DOWN:Class;
    private static const HIGH_BUTTON_DOWN_BMP:BitmapData = new HIGH_BUTTON_DOWN().bitmapData;

    public function ShellButton(caption:String, is_big:Boolean = false, is_high:Boolean = false) {
        super(
                caption,
                is_big ? BIG_BUTTON_NORMAL_BMP : is_high ? HIGH_BUTTON_NORMAL_BMP : BUTTON_NORMAL_BMP,
                is_big ? BIG_BUTTON_OVER_BMP : is_high ? HIGH_BUTTON_OVER_BMP :BUTTON_OVER_BMP,
                is_big ? BIG_BUTTON_DOWN_BMP : is_high ? HIGH_BUTTON_DOWN_BMP :BUTTON_DOWN_BMP,
                TextUtils.FONT_MESSAGES,
                12,
                12,
                -1, -1
                );
    }
}
}
