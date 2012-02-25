/**
 *
 * @author: Vasily Akimushkin
 * @since: 17.02.12
 */
package ru.ipo.kio._12.train {
import flash.display.Sprite;
import flash.events.Event;
import flash.system.System;

import ru.ipo.kio._12.train.util.MathUtils;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

public class TrainRunner  extends Sprite {

    public function TrainRunner() {

        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);
        KioApi.language = KioApi.L_RU;
        KioBase.instance.initOneProblem(this, new TrainProblem(0));
    }

}

}