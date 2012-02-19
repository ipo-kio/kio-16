package ru.ipo.kio._12.stagelights {
import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;

/**
 * Пример задачи
 * @author Ilya
 */
public class StagelightsProblem implements KioProblem {

    public static const ID:String = "test";

    //Это спрайт, на котором рисуется задача
    private var sp:StagelightsProblemSprite;

    private var _level:int;

    //конструктор задачи. Будем указывать в конструкторе уровень, чтобы задачу можно было использовать и в
    //конкурсе первого уровня и второго. Если бы она была, например, только для первого уровня, параметр бы
    //был не нужен.
    //Параметр readonly = true означает, что текст нельзя изменять.
    public function StagelightsProblem(level:int, readonly:Boolean = false) {
        _level = level;

        //в первой строке конструктора задачи требуется вызвать инициализацию api:
        KioApi.initialize(this);

        //Регистрация локализации. Программа должна иметь локализацию для каждого из языков,
        //на котором ее предлагается использовать. Чтобы не вписывать данные в код, их можно
        //загружать с помощью класса Settings. См. задачи 2011 года. Класс Settings читает
        //данные из расширенного json-файла (допустимы комментарии и многострочные строки)
        KioApi.registerLocalization(ID, KioApi.L_RU, {
            title: "Задача Stageligths", //Этот заголовок отображается сверху в окне задачи
            message: "Hello World"
        });

        //теперь можно писать код конструктора, в частности, создавать объекты, которые используют API:
        //В конструкторе MainSpirte есть вызов API (KioApi.instance(...).localization)
        sp = new StagelightsProblemSprite(readonly);
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
        return _level;
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
		var first: Array = [];
		first[0] = sp.stagelights[0].spotlights[0].spotlight.intensity;
		first[1] = sp.stagelights[0].spotlights[1].spotlight.intensity;
		first[2] = sp.stagelights[0].spotlights[2].spotlight.intensity;
		first[3] = sp.stagelights[0].bodies[4].body.red;
		first[4] = sp.stagelights[0].bodies[5].body.blue;
		first[5] = sp.stagelights[0].bodies[6].body.green;
		var second: Array = [];
		second[0] = sp.stagelights[1].spotlights[0].spotlight.intensity;
		second[1] = sp.stagelights[1].spotlights[1].spotlight.intensity;
		second[2] = sp.stagelights[1].spotlights[2].spotlight.intensity;
		second[3] = sp.stagelights[1].bodies[0].body.red;
		second[4] = sp.stagelights[1].bodies[0].body.green;
		second[5] = sp.stagelights[1].bodies[0].body.blue;
        return {
            first : first,
			second : second
        };

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
        if (solution.first) {
            sp.stagelights[0].spotlights[0].spotlight.intensity = solution.first[0];
            sp.stagelights[0].spotlights[1].spotlight.intensity = solution.first[1];
            sp.stagelights[0].spotlights[2].spotlight.intensity = solution.first[2];
			sp.stagelights[0].bodies[4].body.red = solution.first[3];
			sp.stagelights[0].bodies[4].body.green = solution.first[4];
			sp.stagelights[0].bodies[4].body.blue = 0;
			sp.stagelights[0].bodies[5].body.red = solution.first[3];
			sp.stagelights[0].bodies[5].body.green = 0; 
			sp.stagelights[0].bodies[5].body.blue = solution.first[5];
			sp.stagelights[0].bodies[6].body.red = 0;
			sp.stagelights[0].bodies[6].body.green = solution.first[4];
			sp.stagelights[0].bodies[6].body.blue = solution.first[5];
			
            sp.stagelights[1].spotlights[0].spotlight.intensity = solution.second[0];
            sp.stagelights[1].spotlights[1].spotlight.intensity = solution.second[1];
            sp.stagelights[1].spotlights[2].spotlight.intensity = solution.second[2];
			sp.stagelights[1].bodies[0].body.red = solution.second[3];
			sp.stagelights[1].bodies[0].body.green = solution.second[4];
			sp.stagelights[1].bodies[0].body.blue = solution.second[5];
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
        return new Object();
    }

    /**
     * Сравнение двух решений, понадобится позже, комментарий будет позже
     * @param    solution1 результат проверки первого решения
     * @param    solution2 результат проверки второго решения
     * @return результат сравнения
     */
    public function compare(solution1:Object, solution2:Object):int {
        return 1;
    }

    /**
     * Возвращает класс изображения с иконкой. Отображается для выбора задачи
     * Пример в задаче semiramida
     */
    public function get icon():Class {
        return null;
    }

    public function get icon_help():Class {
        return null;
    }

    /**
     * Возвращаем оценку для лучшего решения
     */
    public function get best():Object {
        return null;
    }
}

}