/**
 *
 * @author: Vasily Akimushkin
 * @since: 17.02.12
 */
package ru.ipo.kio._12.train {
import flash.display.DisplayObject;

import ru.ipo.kio._12.train.model.Automation;
import ru.ipo.kio._12.train.model.Passenger;

import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.Train;
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

        
        if(level ==2){
            Automation.instance.states;

        }else{
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

        }

        return result;
    }

    public function loadSolution(solution:Object):Boolean {
        if (solution) {

            if(level ==2){
                Automation.instance.states;
                return true;
            }else{

            TrafficNetwork.instance.resetToEdit();
            var trains:Vector.<Train> = TrafficNetwork.instance.trains;
            for(var i:int = 0; i<trains.length; i++){
                var train:Train = trains[i];
                var arr:Array = solution[i];
                train.route.clear();
                for(var j:int = 0; j<arr.length; j++){
                    train.route.addRail(TrafficNetwork.instance.getRailById(arr[j]));
                }
            }
            TrafficNetwork.instance.moveTrainToLast();

            TrafficNetwork.instance.view.update();

            TrafficNetwork.instance.calc();
            return true;
            }
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

    public function get icon():Class {
        return null;
    }

    public function get icon_help():Class {
        return null;
    }

    public function get best():Object {
        return null;
    }

    public function get icon_statement():Class {
        return null;
    }
}

}
