package ru.ipo.kio._11.digit {
import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;
import ru.ipo.kio.api.controls.RecordBlinkEffect;

public class DigitProblem implements KioProblem {

    public static const ID:String = "digit";
    private var sp:Workspace;
    private var _recordCheck:Object = null;
    private var api:KioApi;
    private var _level:int;

    [Embed(source="loc/digit.ru.json-settings",mimeType="application/octet-stream")]
    public static var DIGIT_RU:Class;
    [Embed(source="loc/digit.es.json-settings",mimeType="application/octet-stream")]
    public static var DIGIT_ES:Class;
    [Embed(source="loc/digit.bg.json-settings",mimeType="application/octet-stream")]
    public static var DIGIT_BG:Class;

    //private var spitter:SpitMem = new SpitMem;

    public function DigitProblem(level:int) {
        _level = level;
        Globals.instance.level = level;

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(DIGIT_RU).data);
        KioApi.registerLocalization(ID, KioApi.L_ES, new Settings(DIGIT_ES).data);
        KioApi.registerLocalization(ID, KioApi.L_BG, new Settings(DIGIT_BG).data);

        KioApi.initialize(this);

        sp = new Workspace;

        api = KioApi.instance(ID);
        /*if (api.bestSolution)
            _recordCheck = api.bestSolution.record;
        else
            _recordCheck = {recognized:0, elements:0};

        sp.solutionState.updateData();
        sp.solutionState.updateView();

        sp.updateResultsInfo(true, _recordCheck.recognized, _recordCheck.elements);

        updateSolutionInfo();*/
    }

    private function updateSolutionInfo():void {
        sp.solutionState.updateData();
        sp.solutionState.updateView();
        sp.updateResultsInfo(false, sp.solutionState.recognized, sp.field.gates.length);
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
        var f:Field = Globals.instance.workspace.field;
        var gates:Array = f.gates;
        var exits:Array = f.exits;

        var sol:Object = {
            gates: new Array(gates.length),
            exits: new Array(exits.length)
        };

        for (var i:int = 0; i < gates.length; i++)
            sol.gates[i] = gates[i].serialization;

        for (i = 0; i < exits.length; i++)
            sol.exits[i] = exits[i].serialization;

        /*sol.record = {
            recognized:Globals.instance.workspace.solutionState.recognized,
            elements:Globals.instance.workspace.field.gates.length
        };*/

        return sol;
    }

    public function loadSolution(solution:Object):Boolean {
        return loadSolutionWithExplicitAutoSave(solution, true);
    }

    public function loadSolutionWithExplicitAutoSave(solution:Object, autoSave:Boolean):Boolean {
        if (!solution)
            return false;

        var f:Field = Globals.instance.workspace.field;

        //TODO optimize, don't evaluate while loading

        while (f.gates.length > 0)
            f.removeGate(f.gates[0]);

        for (var i:int = 0; i < solution.gates.length; i++)
            f.addGate(GatesFactory.createGate(solution.gates[i].type), 239, 42);

        for (i = 0; i < solution.gates.length; i++)
            f.gates[i].serialization = solution.gates[i];

        for (i = 0; i < solution.exits.length; i++)
            f.exits[i].serialization = solution.exits[i];

        //updateSolutionInfo();
        sp.field.evaluate();

        /*if (autoSave)
            KioApi.instance(ID).autoSaveSolution();*/
        if (autoSave)
            sp.submitSolution();

        return true;
    }

    public function check(solution:Object):Object {
        if (!loadSolutionWithExplicitAutoSave(solution, false))
            return null;
        return {
            //TODO put solution info here
        };
    }

    public function compare(solution1:Object, solution2:Object):int {
        if (!solution1)
            return solution2 ? -1 : 0;
        if (!solution2)
            return 1;

        var r:int = solution1.recognized - solution2.recognized;
        if (r == 0)
            r = solution2.elements - solution1.elements;
        return r;
    }

    //user has new solution, submits it
    public function submitSolution(recognized:int, elements:int):void {
        var currentCheck:Object = {recognized:recognized, elements:elements};
        if (compare(currentCheck, _recordCheck) > 0) {
            _recordCheck = currentCheck;
            sp.updateResultsInfo(true, recognized, elements);
            api.saveBestSolution();
            RecordBlinkEffect.blink(sp, 530, 404, 653 - 530, 496 - 404);
        }

        sp.updateResultsInfo(false, recognized, elements);
        api.autoSaveSolution();
    }

    public function get recordCheck():Object {
        return _recordCheck;
    }

    [Embed(source='resources/icon.jpg')]
    private const ICON:Class;

    public function get icon():Class {
        return ICON;
    }

    [Embed(source='resources/icon_help_1.png')]
    private const ICON_HELP_1:Class;

    [Embed(source='resources/icon_help_2.jpg')]
    private const ICON_HELP_2:Class;

    public function get icon_help():Class {
        return level == 1 ? ICON_HELP_1 : ICON_HELP_2;
    }

    public function get best():Object {
        return _recordCheck;
    }
}
}