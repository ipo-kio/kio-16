/**
 * Created by ilya on 15.02.15.
 */
package ru.ipo.kio._15.spider {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;

import ru.ipo.kio.base.GlobalMetrics;

public class SpiderWorkspace extends Sprite {

    private var s:Spider;
    private var f:Floor;
    private var m:SpiderMotion;

    public function SpiderWorkspace() {
        graphics.beginFill(0xF0F4C3);
        graphics.drawRect(0, 0, GlobalMetrics.WORKSPACE_WIDTH, GlobalMetrics.WORKSPACE_HEIGHT);
        graphics.endFill();

        s = new Spider();
        f = new Floor();
        m = new SpiderMotion(s, f);

        addChild(m);
        m.y = 550;
        m.x = 5;

//        addEventListener(Event.ENTER_FRAME, enterFrameHandler);

        addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void {
            stage.addEventListener(KeyboardEvent.KEY_UP, enterFrameHandler);
        });

        addEventListener(Event.ENTER_FRAME, enterFrameHandler);

        var tuned_mechanism:Mechanism = new Mechanism();
        tuned_mechanism.angle = 0;
        var mt:MechanismTuner = new MechanismTuner(tuned_mechanism);
        addChild(mt);
    }

    private function enterFrameHandler(event:Event):void {
        m.add_delta();
    }
}
}
