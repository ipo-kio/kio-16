/**
 * Created by IntelliJ IDEA.
 * User: iposov
 * Date: 23.12.10
 * Time: 15:48
 */
package ru.ipo.kio.api {
import flash.utils.Dictionary;

public class KioApi {

    private var _problem:KioProblem;

    private static var apis:Dictionary = new Dictionary();
    private static var locs:Dictionary = new Dictionary();

    private var lso : LsoProxy;

    private static var _language:String = null;

    public static const L_RU:String = 'ru';
    public static const L_ES:String = 'es';
    public static const L_BG:String = 'bg';
    public static const L_EN:String = 'en';
    public static const L_TH:String = 'th';

    private static var _isChecker:Boolean = false;

    /**
     * Конструктор, вызывать не следует
     * @param problem
     */
    public function KioApi(problem:KioProblem) {
        this._problem = problem;
        lso = LsoProxy.getInstance(problem.level, problem.year);
    }

    /**
     * Инициализация api для конкретной задачи,должна вызываться в конструкторе задачи
     * @param problem регистрируемая задача
     */
    public static function initialize(problem:KioProblem):void {
        apis[problem.id] = new KioApi(problem);
    }

    /**
     * Позволяет обратиться к api задачи по ее id
     * @param id
     * @return
     */
    public static function instance(id:String):KioApi {
        return apis[id];
    }

    /**
     * Регистрирует объект, содержащий набор данных, специфичных для текущей локали.
     * Этот объект будет выдаваться при вызове localization()
     * @param id
     * @param localization_object
     */
    public static function registerLocalization(id:String, lang:String, localization_object:Object):void {
        if (!locs[lang])
            locs[lang] = new Dictionary();
        locs[lang][id] = localization_object;
    }

    public static function getLocalization(id:String):Object {
        return locs[_language][id];
    }

    /**
     * Получить объект, содержащий специфичный для локали набор данных
     */
    public function get localization():Object {
        return locs[_language][_problem.id];
    }

    /**
     * Получить настройки для задачи. Настройки могут использоваться для хранения параметров задачи, которые
     * выбрал пользователь. Например, набор цветов, шрифт и т.п.
     */
    public function get settings():Object {
        if (! problemData.settings)
            problemData.settings = {};

        return problemData.settings;
    }

    public function flushSettings():void {
        lso.flush();
    }

    /**
     * Считается, что пользователь должен открывать задачу всегда в том же состоянии, в котором он ее закрыл.
     * Поэтому каждый раз когда пользователь значительно изменяет свое решение, следует вызывать
     * этот метод. Он сохранит текущее решение. При загрузке оно насильно будет загружено в программу.
     */
    public function autoSaveSolution():void {
        problemData.autoSave = _problem.solution;
        lso.flush();
    }

    /**
     * В тот момент, когда очередное решение пользователя оказалось лучше всех других, следует вызвать
     * этот метод, чтобы это решение сохранилось как наилучшее.
     */
    public function saveBestSolution():void {
        problemData.best = _problem.solution;
        lso.flush();
    }

    /**
     * Получить решение с рекордом. Следует вызвать в начале программы, чтобы указать пользователю
     * текущий рекорд.
     */
    public function get bestSolution():Object {
        return problemData.best;
    }

    /**
     * Возвращает задачу, соответствующую этому api
     */
    public function get problem():KioProblem {
        return _problem;
    }

    private function get problemData():Object {
        return lso.getProblemData(problem.id);
    }

    public static function get language():String {
        return _language;
    }

    public static function set language(value:String):void {
        _language = value;
    }

    public static function localizationSelfTest(coreLanguage:String):void {
        for (var language:String in locs)
            if (language != coreLanguage) {
                trace('comparing core ' + coreLanguage + ' with ' + language);
                compareLocalizations('', locs[coreLanguage], locs[language]);
            }
    }

    private static function compareLocalizations(path:String, coreLang:Object, lang:Object):void {
        for (var key:String in coreLang) {
            var coreVal:* = coreLang[key];
            var val:* = lang[key];
            if (!val) {
                trace("key '" + path + key + "' absent");
                continue;
            }
            var vt:String = getType(val);
            var cvt:String = getType(coreVal);
            if (vt != cvt) {
                trace("key '" + path + key + "' must have type " + cvt + ', not ' + vt);
                continue;
            }
            if (vt == 'array' && (val as Array).length != (coreVal as Array).length) {
                trace("key '" + path + key + "' must have arrays of the equal length");
                continue;
            }
            if (vt == 'object')
                compareLocalizations(path + key + '.', coreVal, val);
        }

        for (key in lang) {
            if (!coreLang[key])
                trace("extra key '" + path + key + "'");
        }
    }

    private static function getType(val:*):String {
        if (val is Array)
            return 'array';
        else if (val is String)
            return 'string';
        else if (val is Number)
            return 'number';
        else if (val is Object)
            return 'object';
        return 'unknown';
    }

    public static function get isChecker():Boolean {
        return _isChecker;
    }

    public static function set isChecker(isChecker:Boolean):void {
        _isChecker = isChecker;
    }
}
}
