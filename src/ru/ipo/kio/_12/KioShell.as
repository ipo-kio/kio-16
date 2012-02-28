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

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.*;

public class KioShell extends Sprite {

    private var _level:int;

    public function KioShell() {
        KioApi.language = KioApi.L_RU;
        _level = 0;

        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        KioBase.instance.init(this,
                [
//                    new ExampleProblem(_level),
                    new FuturamaProblem(_level),
                    new DiamondProblem(_level),
                    new FuturamaProblem(_level)
//                    new ExampleProblem(_level)
//                    new SemiramidaProblem(_level),
//                    new DigitProblem(_level),
//                    _level == 1 ? new AriadneProblem : new PhysicsProblem
                ],
                2012,
                _level
        );

        KioApi.localizationSelfTest(KioApi.L_RU);
    }

}
}
