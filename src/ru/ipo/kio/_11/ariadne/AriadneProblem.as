package ru.ipo.kio._11.ariadne {
import flash.display.DisplayObject;

import ru.ipo.kio._11.ariadne.model.AriadneData;
import ru.ipo.kio._11.ariadne.view.Workspace;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;
import ru.ipo.kio.api.controls.RecordBlinkEffect;

/**
 * Пример задачи
 */
public class AriadneProblem implements KioProblem {

    public static const ID:String = "ariadne";

    private var sp:Workspace;
    private var _recordCheck:Object = null;

    [Embed(source="loc/Ariadne.ru.json-settings",mimeType="application/octet-stream")]
    public static var ARIADNE_RU:Class;
    [Embed(source="loc/Ariadne.es.json-settings",mimeType="application/octet-stream")]
    public static var ARIADNE_ES:Class;
    [Embed(source="loc/Ariadne.bg.json-settings",mimeType="application/octet-stream")]
    public static var ARIADNE_BG:Class;

    public function AriadneProblem() {
        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(ARIADNE_RU).data);
        KioApi.registerLocalization(ID, KioApi.L_ES, new Settings(ARIADNE_ES).data);
        KioApi.registerLocalization(ID, KioApi.L_BG, new Settings(ARIADNE_BG).data);

        KioApi.initialize(this);

        sp = new Workspace;
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 2011;
    }

    public function get level():int {
        return 1;
    }

    public function get display():DisplayObject {
        return sp;
    }

    public function get solution():Object {
        return AriadneData.instance.serializedPath;
    }

    public function loadSolution(solution:Object):Boolean {
        if (!solution)
            return false;
        AriadneData.instance.serializedPath = solution;
        return true;
    }

    public function submitSolution(time:Number, length:Number):void {
        var api:KioApi = KioApi.instance(ID);
        var currentCheck:Object = {time:time, length:length};
        if (compare(currentCheck, _recordCheck) > 0) {
            _recordCheck = currentCheck;
            sp.updateResults(true, time, length);
            api.saveBestSolution();
            RecordBlinkEffect.blink(sp, 636, 111, 768 - 636, 202 - 111 - 10);
        }

        api.autoSaveSolution();
        sp.updateResults(false, time, length);
    }

    public function check(solution:Object):Object {
        //TODO implement
        return {};
    }

    public function compare(solution1:Object, solution2:Object):int {
        if (!solution1)
            return solution2 ? -1 : 0;
        if (!solution2)
            return 1;

        if (solution1.time < solution2.time)
            return 1;
        else if (solution1.time > solution2.time)
            return -1;
        else
            return 0;
    }

    [Embed(source="resources/icon.jpg")]
    public static const ICON:Class;

    public function get icon():Class {
        return ICON;
    }

    [Embed(source='resources/help_icon.jpg')]
    private const ICON_HELP:Class;

    public function get icon_help():Class {
        return ICON_HELP;
    }

    public function get best():Object {
        return _recordCheck;
    }
}

}