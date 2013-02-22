/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 09.02.11
 * Time: 21:41
 */
package ru.ipo.kio._13 {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._13.blocks.BlocksProblem;
import ru.ipo.kio._13.clock.ClockProblem;
import ru.ipo.kio._13.cut.CutProblem;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.*;

public class KIOShell_1 extends Sprite {

    private var _level:int;

    public function KIOShell_0() {
        KioApi.language = KioApi.L_RU;
        _level = 1;

        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        KioApi.localizationSelfTest(KioApi.L_RU);

        KioBase.instance.init(this,
                [
                    new BlocksProblem(_level),
                    new CutProblem(_level),
                    new ClockProblem(_level)
                ],
                2013,
                _level
        );
    }

}
}
