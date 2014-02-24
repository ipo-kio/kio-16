package ru.ipo.kio._14.peterhof {
import flash.display.BitmapData;
import flash.display.Sprite;

import ru.ipo.kio.base.GlobalMetrics;

public class BottomPanel extends Sprite {
    [Embed(source="resources/bottom.png")]
    public static const BOTTOM_BG:Class;
    public static const BOTTOM_BG_IMG:BitmapData = (new BOTTOM_BG).bitmapData;

    [Embed(
            source='resources/Ekaterina Velikaya One.ttf',
            embedAsCFF = "false",
            fontName="KioEkaterina",
            mimeType="application/x-font-truetype",
            unicodeRange = "U+0000-U+FFFF"
            )]
    private static var EKATERINA_FONT:Class;

    public function BottomPanel() {
        graphics.beginBitmapFill(BOTTOM_BG_IMG);
        graphics.drawRect(0, 0, GlobalMetrics.WORKSPACE_WIDTH, GlobalMetrics.WORKSPACE_HEIGHT - PeterhofWorkspace._3D_HEIGHT);
        graphics.endFill();
    }
}
}
