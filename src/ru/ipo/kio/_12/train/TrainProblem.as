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

public class TrainProblem implements KioProblem {

    public static const ID:String = "TRAIN";

    private var sp:TrainSprite;

    private var _level:int;

    public function TrainProblem(level:int, readonly:Boolean = false) {
        _level = level;

        KioApi.initialize(this);

        KioApi.registerLocalization(ID, KioApi.L_RU, {
            title: "Трамваи"
        });

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

            var trains:Vector.<Train> = TrafficNetwork.instance.trains;
            for(var i:int = 0; i<trains.length; i++){
                var train:Train = trains[i];
                var arr:Array = solution[i];
                train.route.clear();
                for(var j:int = 0; j<arr.length; j++){
                    train.route.addRail(TrafficNetwork.instance.getRailById(arr[j]));
                }
            }
             TrafficNetwork.instance.stopAnimate();
            TrafficNetwork.instance.view.update();
            return true;
        } else
            return false;
    }

    public function check(solution:Object):Object {
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
