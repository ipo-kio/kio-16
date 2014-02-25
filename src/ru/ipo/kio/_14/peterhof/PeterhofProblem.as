/**
 * Created by ilya on 11.01.14.
 */
package ru.ipo.kio._14.peterhof {
import com.adobe.serialization.json.JSON_k;

import flash.display.DisplayObject;

import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class PeterhofProblem implements KioProblem {

    public static const ID:String = 'peterhof';

    [Embed(source="loc/peterhof.ru.json-settings",mimeType="application/octet-stream")]
    public static var LOCALIZATION_RU:Class;

    private var _level:int;
    private var workspace:PeterhofWorkspace;

    public function PeterhofProblem(level:int) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(LOCALIZATION_RU).data);

        workspace = new PeterhofWorkspace(this);
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 2014;
    }

    public function get level():int {
        return _level;
    }

    public function get display():DisplayObject {
        return workspace;
    }

    public function get solution():Object {
        return workspace.currentSolution;
    }

    public function get best():Object {
        return null;
    }

    public function loadSolution(solution:Object):Boolean {
        return workspace.load(solution);
    }

    public function check(solution:Object):Object {
        return null;
    }

    public function compare(solution1:Object, solution2:Object):int {
        return solution1.total_length - solution2.total_length;
    }

    public function get icon():Class {
        return null;
    }

    public function get icon_help():Class {
        return null;
    }

    public function get icon_statement():Class {
        return null;
    }

    public function clear():void {
        workspace.clear();
    }
}
}
