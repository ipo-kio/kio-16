/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 09.02.11
 * Time: 21:41
 */
package ru.ipo.kio._11 {
import flash.events.Event;

import mx.core.UIComponent;

import ru.ipo.kio._11.VirtualPhysics.PhysicsProblem;
import ru.ipo.kio._11.ariadne.AriadneProblem;
import ru.ipo.kio._11.digit.DigitProblem;
import ru.ipo.kio._11.semiramida.SemiramidaProblem;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.*;

public class KioShell extends UIComponent {

    private var _level:int;

    public function KioShell(/*level:int*/) {
        _level = 0;//level;

        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        KioBase.instance.init(this,
                [
                    new SemiramidaProblem(_level),
                    new DigitProblem(_level),
                    _level == 1 ? new AriadneProblem : new PhysicsProblem
                ],
                2011,
                _level
        );

        KioApi.localizationSelfTest(KioApi.L_RU);
    }

}
}
