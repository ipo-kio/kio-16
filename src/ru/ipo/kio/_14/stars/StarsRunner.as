/**
 * Created by user on 07.02.14.
 */
package ru.ipo.kio._14.stars {
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.Dictionary;

import ru.ipo.kio._14.stars.StarsProblem;
import ru.ipo.kio._14.stars.graphs.Graph;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.KioBase;

[SWF(width=900, height=625)]
public class StarsRunner extends Sprite {
    public function StarsRunner() {
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

        KioApi.language = KioApi.L_TH; //устанавливаем язык, используемый в программе

        //Запускаем задачу. Метод initOneProblem() специально сделан для отладки одной задачи.
        //Первый параметр - текущий спрайт, второй параметр - задача
        KioBase.instance.initOneProblem(this, new StarsProblem(2));

        /*var s:Array = [new Star(43, 45, 1), new Star(63, 55, 3), new Star(64, 105, 2),
            new Star(70, 145, 2), new Star(243, 65, 1), new Star(163, 60, 3), new Star(103, 98, 1),
            new Star(203, 98, 3), new Star(211, 160, 2), new Star(277, 66, 1), new Star(274, 95, 2), new Star(274, 95, 2)
        ];
        var d:Dictionary = new Dictionary();
        s[0].index = 0;   d[s[0]] = new Vector.<Star>(); d[s[0]].push();
        s[1].index = 1;   d[s[1]] = new Vector.<Star>(); d[s[1]].push(s[2], s[5]);
        s[2].index = 2;   d[s[2]] = new Vector.<Star>(); d[s[2]].push(s[1]);
        s[3].index = 3;   d[s[3]] = new Vector.<Star>(); d[s[3]].push(s[11]);
        s[4].index = 4;   d[s[4]] = new Vector.<Star>(); d[s[4]].push(s[11]);
        s[5].index = 5;   d[s[5]] = new Vector.<Star>(); d[s[5]].push(s[1]);
        s[6].index = 6;   d[s[6]] = new Vector.<Star>(); d[s[6]].push(s[7], s[9]);
        s[7].index = 7;   d[s[7]] = new Vector.<Star>(); d[s[7]].push(s[6], s[10]);
        s[8].index = 8;   d[s[8]] = new Vector.<Star>(); d[s[8]].push(s[11]);
        s[9].index = 9;   d[s[9]] = new Vector.<Star>(); d[s[9]].push(s[6], s[10]);
        s[10].index = 10; d[s[10]] = new Vector.<Star>(); d[s[10]].push(s[9], s[7]);
        s[11].index = 11; d[s[11]] = new Vector.<Star>(); d[s[11]].push(s[3], s[4], s[8]);
        var graph:Graph = new Graph(d);
        var g:Vector.<Graph> = graph.findConnectedComponents();
//        trace(g);
        trace(g[0].numberOfStars, g[0].numberOfEdges);*/
    }
}
}
