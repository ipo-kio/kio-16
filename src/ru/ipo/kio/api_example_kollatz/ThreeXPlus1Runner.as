package ru.ipo.kio.api_example_kollatz {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio._3x_pl_1.X3Plus1Problem;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

/**
 * Этот класс используется для запуска примера. При создании своей задачи для отладки необходимо создать такой же файл.
 * @author Ilya
 */
[SWF(width=900, height=625)]
public class ThreeXPlus1Runner extends Sprite {

    //С этого конструктора начинается программа
    public function ThreeXPlus1Runner() {
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

    //В этом методе инициализируется программа, создаются и настраиваеются основные необходимые объекты
    private function init(e:Event = null):void {
        //теперь можно убрать слушателя события "добавлено на сцену", эту строку тоже рекомендуется писать всегда
        removeEventListener(Event.ADDED_TO_STAGE, init);

        KioApi.language = KioApi.L_RU; //устанавливаем язык, используемый в программе

        //Запускаем задачу. Метод initOneProblem() специально сделан для отладки одной задачи.
        //Первый параметр - текущий спрайт, второй параметр - задача
        KioBase.instance.initOneProblem(this, new X3Plus1Problem(1));
    }

}

}