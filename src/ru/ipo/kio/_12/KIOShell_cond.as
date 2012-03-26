/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 09.02.11
 * Time: 21:41
 */
package ru.ipo.kio._12 {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._12.diamond.DiamondProblem;

import ru.ipo.kio._12.futurama.FuturamaProblem;
import ru.ipo.kio._12.stagelights.StagelightsProblem;
import ru.ipo.kio._12.train.TrainProblem;
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

        if (level == 0)
            KioBase.instance.init(this,
                    [
                        new FuturamaProblem(level),
                        new StagelightsProblem(level),
                        new TrainProblem(level)
                    ],
                    2012,
                    level
            );
        else
            KioBase.instance.init(this,
                    [
                        new FuturamaProblem(level),
                        new DiamondProblem(level),
                        new TrainProblem(level)
                    ],
                    2012,
                    level
            );
    }

}
}
