/**
 *
 * @author: Vasiliy
 * @date: 30.12.12
 */
package ru.ipo.kio._13.clock {
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

public class ClockProblem implements KioProblem{

    [Embed(source='_resources/intro.png')]
    public static var INTRO:Class;

    public static const ID:String = "CLOCK";

    private var clockSprite:ClockSprite;

    private var levelImpl:ITaskLevel;

    [Embed(source="loc/Clock.ru.json-settings",mimeType="application/octet-stream")]
    public static var CLOCK_RU:Class;
    [Embed(source="loc/Clock.es.json-settings",mimeType="application/octet-stream")]
    public static var CLOCK_ES:Class;
    [Embed(source="loc/Clock.en.json-settings",mimeType="application/octet-stream")]
    public static var CLOCK_EN:Class;
    [Embed(source="loc/Clock.bg.json-settings",mimeType="application/octet-stream")]
    public static var CLOCK_BG:Class;
    [Embed(source="loc/Clock.th.json-settings",mimeType="application/octet-stream")]
    public static var CLOCK_TH:Class;

    public function ClockProblem(level:int) {
        levelImpl = LevelCreator.createLevelImpl(level);
        SettingsHolder.instance.registerLevelImpl(levelImpl);
        KioApi.initialize(this);
        KioApi.registerLocalization(ID, KioApi.L_RU, new Settings(CLOCK_RU).data);
        KioApi.registerLocalization(ID, KioApi.L_ES, new Settings(CLOCK_ES).data);
        KioApi.registerLocalization(ID, KioApi.L_EN, new Settings(CLOCK_EN).data);
        KioApi.registerLocalization(ID, KioApi.L_BG, new Settings(CLOCK_BG).data);
        KioApi.registerLocalization(ID, KioApi.L_TH, new Settings(CLOCK_TH).data);
        clockSprite = new ClockSprite(this);
        clockSprite.addEventListener(Event.ENTER_FRAME, function(e:Event):void{
                TransmissionMechanism.instance.innerTick();
        });
        clockSprite.update();
        TransmissionMechanism.instance.view.update();
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 2013;
    }

    public function get level():int {
        return levelImpl.level;
    }

    public function get display():DisplayObject {
        return clockSprite;
    }

    public function get solution():Object {       
        var result:Object = {gears:[]};
        var gears:Vector.<TransferGear> = TransmissionMechanism.instance.transferGearList;
        for(var i:int = 0; i<gears.length; i++){
            var gear:TransferGear = gears[i];
            result.gears.push(gear.toJson());
        }
        return result;
    }



    public function loadSolution(solution:Object):Boolean {
        var gears:Array = solution.gears;
        TransmissionMechanism.instance.clear();
        for(var i:int=0; i<gears.length; i++){
            var gear:Object = gears[i];
            TransmissionMechanism.instance.addTransferGear(new TransferGear(TransmissionMechanism.instance, gear.x, gear.y, gear.lowerAmountOfCogs, gear.upperAmountOfCogs, gear.hue));
        }
        TransmissionMechanism.instance.view.update();
        TransmissionMechanism.instance.viewSide.rebuild();
        return true;
    }

    public function check(solution:Object):Object {
        return null;
    }

    public function get best():Object {
        //просто возвращаем оценку текущего решения
        //ожидается, что был сделан load
        return {
            absTransmissionError: SettingsHolder.instance.levelImpl.truncate(TransmissionMechanism.instance.relTransmissionError),
            square: TransmissionMechanism.instance.square,
            conflict:TransmissionMechanism.instance.isConflict(),
            rightDirection:TransmissionMechanism.instance.isCorrectDirection(),
            finished:TransmissionMechanism.instance.isFinished()&&
                    !TransmissionMechanism.instance.isConflict()
        };
    }

    public function compare(solution1:Object, solution2:Object):int {
        if (!solution1){
            return solution2 ? -1 : 0;
        } else if (!solution2){
            return 1;
        }
        if(solution1.conflict!=solution2.conflict){
            return solution2.conflict?1:-1;
        }else if(Math.abs(solution2.absTransmissionError-solution1.absTransmissionError)>0.0000000001){
            return getSign(solution2.absTransmissionError-solution1.absTransmissionError);
        }else if (solution1.rightDirection!=solution2.rightDirection){
            return solution1.rightDirection?1:-1;
        }else if (solution1.finished!=solution2.finished){
            return solution1.finished?1:-1;
        }else{
            return getSign(solution2.square-solution1.square);
        }
    }

    private function getSign(i:Number):int {
        return i>0?1:i<0?-1:0;
    }

    public function get icon():Class {
        return INTRO;
    }

    public function get icon_help():Class {
       return levelImpl.icon_help;
    }

    public function get icon_statement():Class {
        return levelImpl.icon_statement;
    }

    public function clear():void {
        //do nothing
    }
}
}
