package ru.ipo.kio._16.rockgarden.model {
import flash.display.Graphics;

import mx.core.BitmapAsset;

import mx.utils.HSBColor;

public class RockPalette {

    public static const instance:RockPalette = new RockPalette();

    private var palette:Vector.<Object>;

    public function RockPalette() {
        palette = new <Object>[];
        for (var i:int = 0; i < 7; i++)
            palette.push(HSBColor.convertHSBtoRGB(i * 360 / 7, 1, 0.6));
    }

    public function getColor(ind:int):Object {
        return palette[ind];
    }

    public function beginFill(g:Graphics, ind:int, alpha:Number = 1):void {
        var c:* = palette[ind];
        if (c is uint)
            g.beginFill(c, alpha);
        else if (c is BitmapAsset)
            g.beginBitmapFill(c.bitmapData);
    }
}
}
