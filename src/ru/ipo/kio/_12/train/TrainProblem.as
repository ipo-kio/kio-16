/**
 *
 * @author: Vasily Akimushkin
 * @since: 17.02.12
 */
package ru.ipo.kio._12.train {
import flash.display.DisplayObject;
import flash.events.Event;

import ru.ipo.kio._12.train.model.Automation;
import ru.ipo.kio._12.train.model.Passenger;

import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.Train;
import ru.ipo.kio._12.train.model.types.RegimeType;
import ru.ipo.kio._12.train.model.types.StationType;
import ru.ipo.kio._12.train.util.TrafficNetworkCreator;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class TrainProblem implements KioProblem {

    public static const ID:String = "TRAIN";

    private var sp:TrainSprite;

    private var _level:int;

    [Embed(source="loc/Train.ru.json-settings",mimeType="application/octet-stream")]
    public static var TRAIN_RU_0:Class;

    [Embed(source="loc/Train1.ru.json-settings",mimeType="application/octet-stream")]
    public static var TRAIN_RU_1:Class;

    [Embed(source="loc/Train2.ru.json-settings",mimeType="application/octet-stream")]
    public static var TRAIN_RU_2:Class;

    public function TrainProblem(level:int, readonly:Boolean = false) {
        _level = level;

        KioApi.initialize(this);

        if(level ==0)
            KioApi.registerLocalization(ID, KioApi.L_RU,  new Settings(TRAIN_RU_0).data);
        else if(level ==1)
            KioApi.registerLocalization(ID, KioApi.L_RU,  new Settings(TRAIN_RU_0).data);
        else if(level ==2)
            KioApi.registerLocalization(ID, KioApi.L_RU,  new Settings(TRAIN_RU_2).data);

        TrafficNetworkCreator.instance.createTrafficNetwork(level);
        sp = new TrainSprite(level, readonly);

        sp.addEventListener(Event.ENTER_FRAME, function(e:Event):void{
            if(TrafficNetwork.instance.regime==RegimeType.PLAY){
                TrafficNetwork.instance.innerTick();
            }
        });
    }

    public function get id():String {
        return ID;
    }

    public function get year():int {
        return 2012;
    }

    public function get level():int {
        return _level;
    }

    public function get display():DisplayObject {
        return sp;
    }

    public function get solution():Object {
        var result:Object = {};

        

        var trains:Vector.<Train> = TrafficNetwork.instance.trains;
        for(var i:int = 0; i<trains.length; i++){
            var train:Train = trains[i];
            result[i] = new Array();
            for(var j:int = 0; j<train.route.rails.length; j++){
                result[i].push(train.route.rails[j].id);
            }
        }

            result.passengers={};
            
            for(var i:int = 0; i<TrafficNetwork.instance.rails.length; i++){
                var pas:Vector.<Passenger> = TrafficNetwork.instance.rails[i].getPassengers();
                
                result.passengers[TrafficNetwork.instance.rails[i].id] = new Array();
                for(var j:int =0;j<pas.length; j++){
                    result.passengers[TrafficNetwork.instance.rails[i].id].push(pas[j].destination.number);
                }

            }



        return result;
    }

    public function loadSolution(solution:Object):Boolean {
        if (solution) {



            TrafficNetwork.instance.resetToEdit();
            var trains:Vector.<Train> = TrafficNetwork.instance.trains;
            for(var i:int = 0; i<trains.length; i++){
                var train:Train = trains[i];
                var arr:Array = solution[i];
                train.route.clear();
                if(arr!=null)
                for(var j:int = 0; j<arr.length; j++){
                    train.route.addRail(TrafficNetwork.instance.getRailById(arr[j]));
                }
            }
            TrafficNetwork.instance.moveTrainToLast();

            TrafficNetwork.instance.view.update();

            TrafficNetwork.instance.calc();
            return true;

        } else
            return false;

    }

    public function check(solution:Object):Object {
        //todo
        return new Object();
    }

    public function compare(solution1:Object, solution2:Object):int {
        //todo
        return 1;
    }

    [Embed(source='_resources/intro.png')]
    public static var INTRO:Class;

    public function get icon():Class {
        return INTRO;
    }

    [Embed(source='_resources/icon_statement.jpg')]
    private static var ICON_STATEMENT_01:Class;
    [Embed(source='_resources/icon_help.jpg')]
    private static var ICON_HELP_01:Class;

    [Embed(source='_resources/icon_statement_2.jpg')]
    private static var ICON_STATEMENT_02:Class;
    [Embed(source='_resources/icon_help_2.jpg')]
    private static var ICON_HELP_02:Class;

    public function get icon_help():Class {
        if (_level <= 1)
            return ICON_HELP_01;
        else
            return ICON_HELP_02;
    }

    public function get best():Object {
        return null;
    }

    public function get icon_statement():Class {
        if (_level <= 1)
            return ICON_STATEMENT_01;
        else
            return ICON_STATEMENT_02;
    }
}

}
