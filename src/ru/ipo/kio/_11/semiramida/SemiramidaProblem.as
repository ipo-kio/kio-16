package ru.ipo.kio._11.semiramida {
import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;
import ru.ipo.kio.api.controls.RecordBlinkEffect;

public class SemiramidaProblem implements KioProblem {

    public static const ID:String = "semiramida";
    private var sp:Workspace;
    private var _recordCheck:Object = null;
    private var api:KioApi;
    private var _level:int;

    [Embed(source="loc/Semiramida.ru.json-settings",mimeType="application/octet-stream")]
    public static var SEMIRAMIDA_RU:Class;
    [Embed(source="loc/Semiramida.es.json-settings",mimeType="application/octet-stream")]
    public static var SEMIRAMIDA_ES:Class;
    [Embed(source="loc/Semiramida.bg.json-settings",mimeType="application/octet-stream")]
    public static var SEMIRAMIDA_BG:Class;

    public function SemiramidaProblem(level:int) {
        _level = level;

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(SEMIRAMIDA_RU).data);
        KioApi.registerLocalization(ID, KioApi.L_ES, new Settings(SEMIRAMIDA_ES).data);
        KioApi.registerLocalization(ID, KioApi.L_BG, new Settings(SEMIRAMIDA_BG).data);

        KioApi.initialize(this);

        sp = new Workspace;

        api = KioApi.instance(ID);
        /*_recordCheck = check(api.bestSolution);*/
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 2011;
    }

    public function get level():int {
        return _level;
    }

    public function get display():DisplayObject {
        return sp;
    }

    public function get solution():Object {
        var sol:Object = {};
        sol.pipes = [];
        for each (var pipe:Pipe in sp.house.pipes)
            sol.pipes.push({pos:pipe.n, floors:pipe.floorsInt});
        return sol;
    }

    public function loadSolution(solution:Object):Boolean {
        return loadSolutionWithExplicitAutoSave(solution, true);
    }

    public function loadSolutionWithExplicitAutoSave(solution:Object, autoSave:Boolean):Boolean {
        if (!solution || !solution.pipes)
            return false;
        sp.house.removeAllPipes();
        for each (var pipe:* in solution.pipes)
            sp.house.createPipe(pipe.floors, pipe.pos);
        sp.house.refreshRooms(autoSave);

        sp.updateResults(false, sp.house.roomsCount, sp.house.pipesLength);

        return true;
    }

    public function check(solution:Object):Object {
        if (!loadSolutionWithExplicitAutoSave(solution, false))
            return null;
        return {
            rooms:sp.house.roomsCount,
            pipesLength:sp.house.pipesLength
        };
    }

    public function compare(solution1:Object, solution2:Object):int {
        if (!solution1)
            return solution2 ? -1 : 0;
        if (!solution2)
            return 1;
        var r:int = solution1.rooms - solution2.rooms;
        if (r == 0)
            r = solution2.pipesLength - solution1.pipesLength;
        return r;
    }

    public function submitSolution(rooms:int, pipesLength:int):void {
        var currentCheck:Object = {rooms:rooms, pipesLength:pipesLength};
        if (compare(currentCheck, _recordCheck) > 0) {
            _recordCheck = currentCheck;
            sp.updateResults(true, rooms, pipesLength);
            api.saveBestSolution();
            RecordBlinkEffect.blink(sp, 591, 468, 734 - 591, 571 - 468);
        }

        sp.updateResults(false, rooms, pipesLength);
    }

    public function get recordCheck():Object {
        return _recordCheck;
    }

    [Embed(source='resources/icon.jpg')]
    private const ICON:Class;

    public function get icon():Class {
        return ICON;
    }

    [Embed(source='resources/icon_help.jpg')]
    private const ICON_HELP:Class;

    public function get icon_help():Class {
        return ICON_HELP;
    }

    public function get best():Object {
        return _recordCheck;
    }
}
}