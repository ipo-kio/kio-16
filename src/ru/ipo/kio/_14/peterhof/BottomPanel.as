package ru.ipo.kio._14.peterhof {
import flash.display.Sprite;

import ru.ipo.kio.base.GlobalMetrics;

public class BottomPanel extends Sprite {

    public function BottomPanel() {
        graphics.beginFill(0x222222);
        graphics.drawRect(0, 0, GlobalMetrics.WORKSPACE_WIDTH, GlobalMetrics.WORKSPACE_HEIGHT - PeterhofWorkspace._3D_HEIGHT);
        graphics.endFill();
    }
}
}
