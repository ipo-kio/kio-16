package ru.ipo.kio._13.cut {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.system.System;
import flash.utils.Timer;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

public class CutRunner extends Sprite {

    public function CutRunner() {
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    //В этом методе инициализируется программа, создаются и настраиваеются основные необходимые объекты
    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        KioApi.language = KioApi.L_RU; //устанавливаем язык, используемый в программе

        KioBase.instance.initOneProblem(this, new CutProblem(1));
    }

}
}