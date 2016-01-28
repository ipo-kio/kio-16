/**
 * Created by IntelliJ IDEA.
 * User: ilya
 * Date: 09.02.11
 * Time: 21:41
 */
package ru.ipo.kio._16 {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._15.markov.MarkovProblem;
import ru.ipo.kio._15.spider.SpiderProblem;
import ru.ipo.kio._15.traincars.TrainCarsProblem;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.Settings;
import ru.ipo.kio.base.*;

[SWF(width=900, height=625, frameRate=30)]
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

        KioBase.instance.init(this,
                [
                    new TrainCarsProblem(level),
                    new MarkovProblem(stage, level == 1 ? 2 : level),
                    new SpiderProblem(level)
                ],
                2015,
                level
        );

        KioApi.localizationSelfTest(KioApi.L_RU);
    }

}
}
