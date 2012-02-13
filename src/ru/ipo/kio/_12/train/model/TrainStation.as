/**
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model {
import flash.geom.Point;

import ru.ipo.kio._12.train.model.types.RailStationType;

import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.view.TrainStationView;

public class TrainStation extends Rail {

    private var _stationType:RailStationType;

    public function TrainStation(stationType:RailStationType, trafficNetword:TrafficNetwork, railType:RailType, firstPoint:Point, secondPoint:Point) {
        super(trafficNetword, railType, firstPoint, secondPoint);
        _stationType=stationType;
        view = new TrainStationView(this);
    }


    public function get stationType():RailStationType {
        return _stationType;
    }

    public function set stationType(value:RailStationType):void {
        _stationType = value;
    }

    public override function action(train:Train){
       for(var i:int=train.passengers.length-1; i>=0; i--){
           if(train.passengers[i].destination==stationType){
               train.passengers.splice(i, 1);
               TrafficNetwork.instance.amountOfHappyPassengers++;
           }
       }
    }
}
}
