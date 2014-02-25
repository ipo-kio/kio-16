/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 09.02.11
 * Time: 21:41
 */
package ru.ipo.kio._14 {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._13.blocks.BlocksProblem;
import ru.ipo.kio._13.clock.ClockProblem;
import ru.ipo.kio._13.cut.CutProblem;
import ru.ipo.kio._13.cut.view.CutPoint;
import ru.ipo.kio._14.peterhof.PeterhofProblem;
import ru.ipo.kio._14.stars.StarsProblem;
import ru.ipo.kio._14.tarski.TarskiProblem;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.Settings;
import ru.ipo.kio.base.*;

[SWF(width=900, height=625, frameRate=10)]
public class KIOShell extends Sprite {

    [Embed(source="../level-language.json-settings", mimeType="application/octet-stream")]
    public static var RUNNER_CONFIG:Class;

    private static var level:int = KIO::level;
    private static var language:String = KIO::language;

    public function KIOShell() {
        if (level < 0 || !language) {
            var data:Object = new Settings(RUNNER_CONFIG).data;
            level = data.level;
            language = data.language;
        }

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
                    new StarsProblem(level),
                    new PeterhofProblem(level),
//                    new TarskiProblem(level, stage)
                        new CutProblem(level)
                ],
                2014,
                level
        );
    }

}
}
