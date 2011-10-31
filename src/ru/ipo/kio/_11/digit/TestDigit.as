package ru.ipo.kio._11.digit {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

public class TestDigit extends Sprite {

    public function TestDigit() {
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        KioApi.language = KioApi.L_RU;

        KioBase.instance.initOneProblem(this, new DigitProblem(2));
    }

}

}