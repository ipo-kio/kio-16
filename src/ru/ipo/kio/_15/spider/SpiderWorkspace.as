/**
 * Created by ilya on 15.02.15.
 */
package ru.ipo.kio._15.spider {
import flash.display.Sprite;

import ru.ipo.kio.base.GlobalMetrics;

public class SpiderWorkspace extends Sprite {
    public function SpiderWorkspace() {
        graphics.beginFill(0xFFFFFF);
        graphics.drawRect(0, 0, GlobalMetrics.WORKSPACE_WIDTH, GlobalMetrics.WORKSPACE_HEIGHT);
        graphics.endFill();

        var m:Mechanism = new Mechanism();
        addChild(m);
        m.x = 100;
        m.y = 500;
    }
}
}
