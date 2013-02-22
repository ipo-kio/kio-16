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

public class KIOShell_cond extends Sprite {

    private static const level:int = KIO::level;
    private static const language:String = KIO::language;

    public function KIOShell_cond() {
        KioApi.language = language;

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
                    new BlocksProblem(level),
                    new CutProblem(level),
                    new ClockProblem(level)
                ],
                2013,
                level
        );
    }

}
}
