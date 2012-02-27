/**
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model {
import flash.geom.Point;

import ru.ipo.kio._12.train.model.types.StationType;

import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.view.TrainStationView;

public class TrainStation extends Rail {

    private var _passengers:Vector.<Passenger> = new Vector.<Passenger>();
    
    private var _stationType:StationType;

    public function TrainStation(stationType:StationType, trafficNetword:TrafficNetwork, railType:RailType, firstPoint:Point, secondPoint:Point) {
        super(trafficNetword, railType, firstPoint, secondPoint);
        _stationType=stationType;
        view = new TrainStationView(this);
    }

    public function get stationType():StationType {
        return _stationType;
    }

    public function reset():void{
        _passengers = new Vector.<Passenger>();
    }

    public override function processPassengers(train:Train){
       for(var i:int=train.passengers.length-1; i>=0; i--){
           if(train.passengers[i].destination==stationType){
               _passengers.push(train.passengers[i]);
               TrafficNetwork.instance.amountOfHappyPassengers++;
               TrafficNetwork.instance.timeOfTrip+=train.passengers[i].time;
               train.passengers.splice(i, 1);

           }
       }
    }

    public function get passengers():Vector.<Passenger> {
        return _passengers;
    }
}
}
