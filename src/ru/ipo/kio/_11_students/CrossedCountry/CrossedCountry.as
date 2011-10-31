package ru.ipo.kio._11_students.CrossedCountry {
import flash.display.DisplayObject;
import flash.display.Sprite;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;
import ru.ipo.kio.api_example.ExampleProblemSprite;

/**
 * Пример задачи
 */
public class CrossedCountry implements KioProblem {

    public static const ID:String = "crossed_country";

    //Это спрайт, на котором рисуется задача
    private var sp:Sprite;
    private var _recordCheck:Object = null;

    [Embed(source="../ariadne/resources/Ariadne.ru.json-settings",mimeType="application/octet-stream")]
    public static var locTxt_ru:Class;
    [Embed(source="../ariadne/resources/Ariadne.es.json-settings",mimeType="application/octet-stream")]
    public static var locTxt_es:Class;

    //конструктор задачи
    public function CrossedCountry() {
        //в первой строке конструктора задачи требуется вызвать инициализацию api:
        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(locTxt_ru).data);
        KioApi.registerLocalization(ID, KioApi.L_ES, new Settings(locTxt_es).data);
        KioApi.initialize(this);

        //теперь можно писать код конструктора, в частности, создавать объекты, которые используют API:
//        В конструкторе MainSpirte есть вызов API (KioApi.instance(...).localization)
//        sp = new Main;
        sp = new ExampleProblemSprite(true, ID);
        // получить рекорд
    }

    /**
     * Произвольный идентификатор задачи, который необходимо выбрать и далее использовать при обращении к api:
     * KioApi.instance(ID). Хорошей практикой является создание статической константы с этим id
     */
    public function get id():String {
        return ID;
    }

    /**
     * Год задачи
     */
    public function get year():int {
        return 2011;
    }

    /**
     * Уровень, для которого предназначена задача
     */
    public function get level():int {
        return 1;
    }

    /**
     * Основной объект для отображения, чаще всего это спрайт (Sprite), на котором лежат все элементы
     * задачи
     */
    public function get display():DisplayObject {
        return sp;
    }

    /**
     * В каждый момент времени задача должна уметь вернуть текущее решение, над которым работает участник.
     * Запрос может быть дан в произвольный момент, программа всегда должна быть готова выдать текущее решение.
     */
    public function get solution():Object {
        //в качестве решения возвращаем текст внутри текстового поля задачи
        return {
//            points:sp.pointArray.concat(),
//            time: sp.getPathTime()
            //txt : sp.text
        };
        /*
         var o:Object = {
         points_count:10,
         point:[{x:1, y:2}, {x:3, y:-1}]
         };

         trace(o.points_count);
         trace(o.point[1].x); //3
         o.new_points = new Array();
         o.new_points.push(10);
         o.new_points.push( { x:10, y:5 } );
         o.new_points.clone();*/

        //Другой способ сделать тоже самое:
        // var o:Object = new Object();
        // o.txt = sp.text;
        // return o;
    }

    /**
     * Функция заставляет программу загрузить решение. На вход она получает одно из тех решений, которое
     * выдала в методе solution(). Другими словами, все выданное в методе solution() сохранятся и иногда отдается
     * обратно в метод loadSolution(). Запрос может быть дан в произвольный момент, программа всегда должна быть
     * готова загрузить новое решение.
     * @param    solution решение для загрузки
     * @return удалось ли загрузить решение
     */
    public function loadSolution(solution:Object):Boolean {
        //для загрузки решения нужно взять поле txt и записать его в текстовое поле
        if (solution.points) {
            // удаление всех точек, обнуление результата
//            sp.deleteAll();
            // добавление точек на сцену
//            sp.loadSol(solution.points);

            //sp.text = solution.txt;
            return true;
        } else
            return false;
    }

    /**
     * Проверка решения, понадобится позже, комментарий будет позже
     * @param    solution решение для проверки
     * @return результат проверки
     */
    public function check(solution:Object):Object {
        return {
//            time: sp.getPathTime()
        };
    }

    //otkluchilos

    /**
     * Сравнение двух решений, понадобится позже, комментарий будет позже
     * @param    solution1 результат проверки первого решения
     * @param    solution2 результат проверки второго решения
     * @return результат сравнения
     */
    public function compare(solution1:Object, solution2:Object):int {

        if (!solution1)
            return solution2 ? 0 : -1;
        if (!solution2)
            return 1;

        return solution1.time - solution2.time; //sm. semiramidaProblem, add null check
    }

    [Embed(source="resources/icon.jpg")]
    public static const ICON:Class;

    public function get icon():Class {
        return ICON;
    }

    public function get recordCheck():Object {
        return _recordCheck;
    }

    public function get icon_help():Class {
        return null;
    }
}

}