package ru.ipo.kio._16.rockgarden.model {
import flash.display.BitmapData;
import flash.display.Graphics;

import mx.core.BitmapAsset;

public class RockPalette {

    [Embed(source="../res/rocks/kamen-1.png")]
    public static const R_1:Class;
    [Embed(source="../res/rocks/kamen-2.png")]
    public static const R_2:Class;
    [Embed(source="../res/rocks/kamen-4.png")]
    public static const R_3:Class;
    [Embed(source="../res/rocks/kamen-6.png")]
    public static const R_4:Class;
    [Embed(source="../res/rocks/kamen-7.png")]
    public static const R_5:Class;
    [Embed(source="../res/rocks/kamen-9.png")]
    public static const R_6:Class;
    [Embed(source="../res/rocks/kamen-11.png")]
    public static const R_7:Class;

    public static const R_IMG:Vector.<BitmapData> = new <BitmapData>[
        (new R_1).bitmapData,
        (new R_2).bitmapData,
        (new R_3).bitmapData,
        (new R_4).bitmapData,
        (new R_5).bitmapData,
        (new R_6).bitmapData,
        (new R_7).bitmapData
    ];

    public static const instance:RockPalette = new RockPalette();

//    private var palette:Vector.<Object>;

    public function RockPalette() {
//        palette = new <Object>[];
//        for (var i:int = 0; i < 7; i++)
//            palette.push(HSBColor.convertHSBtoRGB(i * 360 / 7, 1, 0.6));
    }

    public static function getColor(ind:int):BitmapData {
        return R_IMG[ind - 1];
    }

    public static function beginFill(g:Graphics, ind:int, alpha:Number = 1):void {
        var c:* = getColor(ind);
        if (c is BitmapData)
            g.beginBitmapFill(c);
        else if (c is uint)
            g.beginFill(c, alpha);
        else if (c is BitmapAsset)
            g.beginBitmapFill(c.bitmapData);
    }

    public static function textColor(ind:int):uint {
        if (ind == 4 /*|| ind == 5 || ind == 7*/)
            return 0xffffff;
        else
            return 0x000000;
    }
}
}
