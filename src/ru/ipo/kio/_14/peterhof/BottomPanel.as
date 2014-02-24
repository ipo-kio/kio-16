package ru.ipo.kio._14.peterhof {
import flash.display.BitmapData;
import flash.display.Sprite;

import ru.ipo.kio.base.GlobalMetrics;

public class BottomPanel extends Sprite {
    [Embed(source="resources/bottom.png")]
    public static const BOTTOM_BG:Class;
    public static const BOTTOM_BG_IMG:BitmapData = (new BOTTOM_BG).bitmapData;

    public function BottomPanel() {
        graphics.beginBitmapFill(BOTTOM_BG_IMG);
        graphics.drawRect(0, 0, GlobalMetrics.WORKSPACE_WIDTH, GlobalMetrics.WORKSPACE_HEIGHT - PeterhofWorkspace._3D_HEIGHT);
        graphics.endFill();
    }
}
}
