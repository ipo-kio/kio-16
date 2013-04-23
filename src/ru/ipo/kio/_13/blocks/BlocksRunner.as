package ru.ipo.kio._13.blocks {

import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

public class BlocksRunner extends Sprite {

    public function BlocksRunner() {
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, init);

        KioApi.language = KioApi.L_EN;

        //Запускаем задачу. Метод initOneProblem() специально сделан для отладки одной задачи.
        //Первый параметр - текущий спрайт, второй параметр - задача
        KioBase.instance.initOneProblem(this, new BlocksProblem(2));
    }

}

}