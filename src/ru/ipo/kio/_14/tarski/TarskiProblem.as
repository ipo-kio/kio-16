/**
 * @author: Vasily Akimushkin
 * @since: 31.01.14
 */
package ru.ipo.kio._14.tarski {
import flash.display.Sprite;

import ru.ipo.kio._13.clock.*;

import flash.display.DisplayObject;
import flash.events.Event;

import ru.ipo.kio._13.clock.model.SettingsHolder;

import ru.ipo.kio._13.clock.model.TransferGear;

import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.model.level.ITaskLevel;
import ru.ipo.kio._13.clock.model.level.LevelCreator;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class TarskiProblem implements KioProblem{

    public static const ID:String = "Tarski";

    public static const YEAR:int = 2014;

    [Embed(source='_resources/intro.png')]
    public static var INTRO:Class;

    [Embed(source='_resources/Level_1-Statement-1.jpg')]
    private static var ICON_STATEMENT:Class;

    [Embed(source='_resources/Level_1-Help-1.jpg')]
    private static var ICON_HELP:Class;

    [Embed(source="loc/Tarski.ru.json-settings",mimeType="application/octet-stream")]
    public static var TARSKI_RU:Class;
    [Embed(source="loc/Tarski.es.json-settings",mimeType="application/octet-stream")]
    public static var TARSKI_ES:Class;
    [Embed(source="loc/Tarski.en.json-settings",mimeType="application/octet-stream")]
    public static var TARSKI_EN:Class;
    [Embed(source="loc/Tarski.bg.json-settings",mimeType="application/octet-stream")]
    public static var TARSKI_BG:Class;
    [Embed(source="loc/Tarski.th.json-settings",mimeType="application/octet-stream")]
    public static var TARSKI_TH:Class;

    private var _level:int;

    private var _sprite:Sprite;


    public function TarskiProblem(level:int) {
        KioApi.initialize(this);
        _level=level;
        if(level ==0){
            _sprite = new TarskiSpriteLevel0();
        }else{
            _sprite=new TarskiSprite(level);
        }
        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(TARSKI_RU).data);
        KioApi.registerLocalization(ID, KioApi.L_ES, new Settings(TARSKI_ES).data);
        KioApi.registerLocalization(ID, KioApi.L_EN, new Settings(TARSKI_EN).data);
        KioApi.registerLocalization(ID, KioApi.L_BG, new Settings(TARSKI_BG).data);
        KioApi.registerLocalization(ID, KioApi.L_TH, new Settings(TARSKI_TH).data);
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return YEAR;
    }

    public function get level():int {
        return _level;
    }

    public function get display():DisplayObject {
        return _sprite;
    }

    public function get solution():Object {       
        var result:Object = {gears:[]};
        return result;
    }



    public function loadSolution(solution:Object):Boolean {
        return true;
    }

    public function check(solution:Object):Object {
        return null;
    }

    public function get best():Object {
        var result:Object = {gears:[]};
        return result;
    }

    public function compare(solution1:Object, solution2:Object):int {
       return 0;
    }


    public function get icon():Class {
        return INTRO;
    }

    public function get icon_help():Class {
       return ICON_HELP;
    }

    public function get icon_statement():Class {
        return ICON_STATEMENT;
    }
}
}
