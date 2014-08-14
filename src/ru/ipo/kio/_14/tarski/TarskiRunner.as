
package ru.ipo.kio._14.tarski {

import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;
[SWF(width="900", height="625")]
public class TarskiRunner extends Sprite {
    public function TarskiRunner() {
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        KioApi.language = KioApi.L_TH;
        KioBase.instance.initOneProblem(this, new TarskiProblem(0, stage));
    }
}
}
