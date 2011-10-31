package ru.ipo.kio._11_students.CrossedCountry {
import flash.display.Sprite;
import flash.events.Event;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

/**
 * Этот класс основной, с него начинается программа. Чтобы указать это FlashDevelop,
 * надо найти этот файл в списке файлов проекта, нажать на нем правой кнопкой, выбрать Always Compile.
 * @author Ilya
 */
public class Run extends Sprite {

    //С этого конструктора начинается программа
    public function Run() {
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

        //Регистрируем локализации. Все слова, фразы, которые используются в задаче и которые, естественно, изменяются
        //в других языках, не должны быть вписаны напрямую в задачу. Они должны браться из объекта локализации.
        //С помощью этого вызова registerLocalization() мы указываем, что задаче с идентификатором ID соответствует объект,
        //указанный как второй параметр.
        //
        //Синтаксис второго объекта может вызвать вопросы. В ActionScript имеется удобный способ создания объектов,
        //рассмотрим его на примере:
        // var o:Object = {a:"asdf", b:"pq", c:{p:42, q:239, r:[4,5,"sdf"]} };
        // trace(o.a); -> строка asdf
        // trace(o.b); -> строка pq
        // trace(o.c); -> это тоже объект, потому что он тоже задан фигурными скобками
        // trace(o.c.p); -> это число 42
        // trace(o.c.r); -> это массив, потому что он задан в []
        // trace(o.c.r[0]); -> это число 4
        //
        //Чтобы не вписывать сюда объект локализации, его можно создать отдельно, см. ru.ipo.kio.base.KioBase.init()
        /*KioApi.registerLocalization(
                CrossedCountry.ID, //идентификатор
                'ru',
        {                              //объект локализации
            text1 : "Hello World",
            text2 : "text 2",
            menu : {
                file : "Файл",
                exit : "Выйти"
            }
        }
                );*/
        KioApi.language = KioApi.L_RU;

        //Запускаем задачу. Метод initOneProblem() рекомендуется использовать программистам для отладки одной задачи.
        //Первый параметр - текущий спрайт, второй параметр - задача
        KioBase.instance.initOneProblem(this, new CrossedCountry);
    }

}

}