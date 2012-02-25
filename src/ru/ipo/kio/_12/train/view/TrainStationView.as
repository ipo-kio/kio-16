/**
 *
 * @author: Vasily Akimushkin
 * @since: 30.01.12
 */
package ru.ipo.kio._12.train.view {
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._12.train.model.Passenger;

import ru.ipo.kio._12.train.model.Rail;
import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.TrainStation;
import ru.ipo.kio._12.train.model.types.StationType;
import ru.ipo.kio._12.train.model.types.RailType;

public class TrainStationView extends RailView {

    [Embed(source='../_resources/Circle_blue.png')]
    private static const LEVEL_1_BLUE:Class;

    [Embed(source='../_resources/Circle_green.png')]
    private static const LEVEL_1_GREEN:Class;

    [Embed(source='../_resources/Circle_red.png')]
    private static const LEVEL_1_RED:Class;

    [Embed(source='../_resources/Circle_yellow.png')]
    private static const LEVEL_1_YELLOW:Class;

    public function TrainStationView(station:TrainStation) {
        super(station);
        if(TrafficNetwork.instance.level==1){
            placeFirstLevel(station);
        }

        addEventListener(Event.ADDED, function(e:Event):void{placeFirstLevelCircle();});

        update();
    }

    private function placeFirstLevelCircle():void {
        var line;
        var station:TrainStation = (TrainStation (rail));
        if(station.stationType==StationType.FIRST){
            line = new LEVEL_1_BLUE;
        }
        else if(station.stationType==StationType.SECOND){
            line = new LEVEL_1_YELLOW;
        }
        else if(station.stationType==StationType.THIRD){
            line = new LEVEL_1_RED;
        }
        else if(station.stationType==StationType.FOURTH){
            line = new LEVEL_1_GREEN;
        }



        parent.addChild(line);

        if (rail.type == RailType.SEMI_ROUND_TOP) {
            line.x = (width-line.width)/2;
            line.y = -11;
        } else if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
            line.x = (width-line.width)/2;
            line.y = height-38+11;
        } else if (rail.type == RailType.SEMI_ROUND_RIGHT) {
            line.x = width-38+11
            line.y = (height-line.height)/2;
         } else if (rail.type == RailType.SEMI_ROUND_LEFT) {
            line.x = -11
            line.y = (height-line.height)/2;
        }
        line.x+=x;
        line.y+=y;

    }

     public override function update():void{
         super.update();

         var length:int = TrafficNetwork.instance.railLength;
         var space:int = TrafficNetwork.instance.railSpace;
         
         updateStationPassengers(length, space);
     }


    protected function updateStationPassengers(length:int, space:int):void {
        
        var passengers:Vector.<Passenger> = (TrainStation(rail)).passengers;
        
        for (var i:int = 0; i < passengers.length; i++) {
            if (rail.trafficNetwork.view.contains(passengers[i].view)) {
                rail.trafficNetwork.view.removeChild(passengers[i].view);
            }
        }

        var passengerSize:int = TrafficNetwork.instance.passengerSize;
        var passengerSpace:int = TrafficNetwork.instance.passengerSpace;

        for (var i:int = 0; i < passengers.length; i++) {
            rail.trafficNetwork.view.addChild(passengers[i].view);
            if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
                passengers[i].view.x = rail.view.x + rail.view.width/2 + (i % 2 == 1 ? + i* (passengerSize+passengerSpace) : - i*(passengerSize+passengerSpace));
                passengers[i].view.y = rail.view.y + rail.view.height + passengerSize * 3;
            }
            if (rail.type == RailType.SEMI_ROUND_TOP) {
                passengers[i].view.x = rail.view.x + rail.view.width/2 + (i % 2 == 1 ? + i* (passengerSize+passengerSpace) : - i*(passengerSize+passengerSpace));
                passengers[i].view.y = rail.view.y - passengerSize * 5;
            }
            if (rail.type == RailType.SEMI_ROUND_LEFT) {
                passengers[i].view.x = rail.view.x - passengerSize * 5;
                passengers[i].view.y = rail.view.y + rail.view.height/2 + (i % 2 == 1 ? + i* (passengerSize+passengerSpace) : - i*(passengerSize+passengerSpace));
            }
            if (rail.type == RailType.SEMI_ROUND_RIGHT) {
                passengers[i].view.x = rail.view.x + rail.view.width + passengerSize * 3;
                passengers[i].view.y = rail.view.y + rail.view.height/2 + (i % 2 == 1 ? + i* (passengerSize+passengerSpace) : - i*(passengerSize+passengerSpace));
            }

        }
    }
}
}
