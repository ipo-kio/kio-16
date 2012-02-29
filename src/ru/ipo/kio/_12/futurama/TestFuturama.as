/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 22.02.12
 * Time: 22:35
 * To change this template use File | Settings | File Templates.
 */
package ru.ipo.kio._12.futurama {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._12.diamond.*;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

public class TestFuturama extends Sprite {
    public function TestFuturama() {
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        KioApi.language = KioApi.L_RU;

        KioBase.instance.initOneProblem(this, new FuturamaProblem(0));
    }
}
}
