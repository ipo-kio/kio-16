/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 10.02.11
 * Time: 20:25
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio.base.resources {
public class Resources {

    [Embed(source="bg.png")]
    public static const BG_IMAGE:Class;

    [Embed(source="Problem_BG_top.png")]
    public static const BG_PR_IMAGE_TOP:Class;

    [Embed(source="Problem_BG_right.png")]
    public static const BG_PR_IMAGE_RIGHT:Class;

    [Embed(source="imgs/up_arrow.png")]
    public static const UP_ARROW_IMAGE:Class;

    [Embed(source='imgs/no_img.png')]
    public static var NO_PROBLEM_IMG:Class;

    [Embed(source="imgs/input_bg.jpg")]
    public static const INPUT_BG:Class;

    [Embed(source="imgs/settings_ru.png")]
    public static const SETTINGS_HELPER_RU:Class;
}
}
