package ru.ipo.kio._11.ariadne.test {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._11.ariadne.AriadneProblem;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

public class TestAriadne extends Sprite {

    public function TestAriadne() {
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        KioApi.language = KioApi.L_RU;

        KioBase.instance.initOneProblem(this, new AriadneProblem);
    }

}

}