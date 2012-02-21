package ru.ipo.kio._12.stagelights {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

/**
 * Этот класс основной, с него начинается программа. Чтобы указать это FlashDevelop,
 * надо найти этот файл в списке файлов проекта, нажать на нем правой кнопкой, выбрать Always Compile.
 * @author Ilya
 */
public class StagelightsRunner extends Sprite {

    //С этого конструктора начинается программа
    public function StagelightsRunner() {
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

        //Запускаем задачу. Метод initOneProblem() рекомендуется использовать программистам для отладки одной задачи.
        //Первый параметр - текущий спрайт, второй параметр - задача
        KioBase.instance.initOneProblem(this, new StagelightsProblem(0));
    }

}

}