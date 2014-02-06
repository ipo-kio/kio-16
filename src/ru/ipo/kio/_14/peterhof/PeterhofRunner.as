/**
 * Created by ilya on 11.01.14.
 */
package ru.ipo.kio._14.peterhof {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

[SWF(width=900, height=625, frameRate=10)]
public class PeterhofRunner extends Sprite {
    public function PeterhofRunner() {
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        KioApi.language = KioApi.L_RU; //устанавливаем язык, используемый в программе

        KioBase.instance.initOneProblem(this, new PeterhofProblem(1));

//        var s:Sprite = new Sprite();
//        s.graphics.beginFill(0xFF0000);
//        s.graphics.drawRect(200, 200, 400, 400);
//        s.graphics.endFill();
//        addChild(s);

//        addChild(new PeterhofWorkspace());
    }
}
}
