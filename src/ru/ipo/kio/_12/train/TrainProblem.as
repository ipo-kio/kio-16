/**
 *
 * @author: Vasily Akimushkin
 * @since: 17.02.12
 */
package ru.ipo.kio._12.train {
import flash.display.DisplayObject;

import ru.ipo.kio._12.train.model.Rail;

import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.Train;
import ru.ipo.kio._12.train.util.TrafficNetworkCreator;

import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.KioProblem;
import ru.ipo.kio.api.Settings;

public class TrainProblem implements KioProblem {

    public static const ID:String = "TRAIN";

    private var sp:TrainSprite;

    private var _level:int;

    [Embed(source="loc/Train.ru.json-settings",mimeType="application/octet-stream")]
    public static var TRAIN_RU:Class;

    public function TrainProblem(level:int, readonly:Boolean = false) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU,  new Settings(TRAIN_RU).data);

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

        var trains:Vector.<Train> = TrafficNetwork.instance.trains;
        for(var i:int = 0; i<trains.length; i++){
            var train:Train = trains[i];
            result[i] = new Array();
            for(var j:int = 0; j<train.route.rails.length; j++){
                result[i].push(train.route.rails[j].id);
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
                for(var j:int = 0; j<arr.length; j++){
                    train.route.addRail(TrafficNetwork.instance.getRailById(arr[j]));
                }
            }
            TrafficNetwork.instance.moveTrainToLast();
            TrafficNetwork.instance.view.update();
            return true;
        } else
            return false;
    }

    public function check(solution:Object):Object {
        TrafficNetwork.instance.calc();
        var result:Object = new Object();
        result.passengers = TrafficNetwork.instance.amountOfHappyPassengers;
        result.time = TrafficNetwork.instance.timeOfTrip;
        result.fault = TrafficNetwork.instance.fault;
        return new Object();
    }

    public function compare(solution1:Object, solution2:Object):int {
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
}

}
