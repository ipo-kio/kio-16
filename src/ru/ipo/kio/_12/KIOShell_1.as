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
import ru.ipo.kio._12.train.TrainProblem;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api_example.ExampleProblem;
import ru.ipo.kio.base.*;

public class KIOShell_1 extends Sprite {

    private var _level:int;

    public function KIOShell_1() {
        KioApi.language = KioApi.L_ES;
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
                    new FuturamaProblem(_level),
                    new DiamondProblem(_level),
                    new TrainProblem(_level)
                ],
                2012,
                _level
        );
    }

}
}
