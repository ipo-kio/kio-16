/**
 * Created by user on 07.02.14.
 */
package ru.ipo.kio._15.spider {
import ru.ipo.kio._15.traincars.*;
import ru.ipo.kio._14.stars.*;

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.Dictionary;

import ru.ipo.kio._14.stars.StarsProblem;
import ru.ipo.kio._14.stars.graphs.Graph;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

[SWF(width=900, height=625, frameRate=10)]
public class SpiderRunner extends Sprite {
    public function SpiderRunner() {
        //Код в конструкторе рекомендуется всегда писать таким же, как здесь.
        //
        //Пояснение: мы определяем, доступен ли нам объект сцены. На сцене расположены все видимые объекты,
        //в частности текущий создаваемый объект ExampleRunner. Если создаваемый ExampleRunner уже добавлен на сцену, то
        //сцена доступна, и мы можем вызвать инициализацию. Если объект еще не добавлен, то инициализацию
        //надо отложить, и вызвать только по событию ADDED_TO_STAGE (добавлено на сцену)
        if (stage)
            init();
        else
            addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(e:Event = null):void {
        //теперь можно убрать слушателя события "добавлено на сцену", эту строку тоже рекомендуется писать всегда
        removeEventListener(Event.ADDED_TO_STAGE, init);

        KioApi.language = KioApi.L_RU; //устанавливаем язык, используемый в программе

        //Запускаем задачу. Метод initOneProblem() специально сделан для отладки одной задачи.
        //Первый параметр - текущий спрайт, второй параметр - задача
        KioBase.instance.initOneProblem(this, new SpiderProblem(2));
    }
}
}
