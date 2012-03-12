/**
 *
 * @author: Vasily Akimushkin
 * @since: 30.01.12
 */
package ru.ipo.kio._12.train.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._12.train.model.Passenger;

import ru.ipo.kio._12.train.model.Rail;
import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.TrainStation;
import ru.ipo.kio._12.train.model.types.StationType;
import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.view.gui.BlueCircle;
import ru.ipo.kio._12.train.view.gui.GreenCircle;
import ru.ipo.kio._12.train.view.gui.RedCircle;
import ru.ipo.kio._12.train.view.gui.YellowCircle;

public class TrainStationView extends RailView {

    [Embed(source='../_resources/one/Circle_blue.png')]
    private static const LEVEL_1_BLUE:Class;

    [Embed(source='../_resources/one/Circle_green.png')]
    private static const LEVEL_1_GREEN:Class;

    [Embed(source='../_resources/one/Circle_red.png')]
    private static const LEVEL_1_RED:Class;

    [Embed(source='../_resources/one/Circle_yellow.png')]
    private static const LEVEL_1_YELLOW:Class;

    public function TrainStationView(station:TrainStation) {
        super(station);

        if(TrafficNetwork.instance.level==1 || TrafficNetwork.instance.level==2){
           addEventListener(Event.ADDED, function(e:Event):void{placeFirstLevelCircle();});
        }

       // update();
    }

    var line;
    
    var sp:Sprite;

    private function placeFirstLevelCircle():void {
        var station:TrainStation = (TrainStation (rail));
        if(station.stationType==StationType.FIRST){
            line = new LEVEL_1_BLUE;
            sp = new BlueCircle();
        }
        else if(station.stationType==StationType.SECOND){
            line = new LEVEL_1_YELLOW;
            sp = new YellowCircle();
        }
        else if(station.stationType==StationType.THIRD){
            line = new LEVEL_1_RED;
            sp = new RedCircle();
        }
        else if(station.stationType==StationType.FOURTH){
            line = new LEVEL_1_GREEN;
            sp = new GreenCircle();
        }



        if (rail.type == RailType.SEMI_ROUND_TOP) {
            sp.x = (width-line.width)/2;
            sp.y = -11;

        } else if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
            sp.x = (width-line.width)/2;
            sp.y = height-38+11;
        } else if (rail.type == RailType.SEMI_ROUND_RIGHT) {
            sp.x = width-38+11
            sp.y = (height-line.height)/2;
         } else if (rail.type == RailType.SEMI_ROUND_LEFT) {
            sp.x = -11
            sp.y = (height-line.height)/2;
        }
        sp.x+=x;
        sp.y+=y;

        parent.addChild(sp);
    }

     public override function update():void{
         super.update();

//         if(sp!=null && parent.contains(sp)){
//           parent.removeChild(sp);
//           parent.addChild(sp);
//         }
         
         var length:int = TrafficNetwork.instance.railLength;
         var space:int = TrafficNetwork.instance.railSpace;
         
         updateStationPassengers(length, space);
     }


    public function updateStationPassengers(length:int, space:int):void {
        
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
            if (rail.type == RailType.HORIZONTAL && rail.id == 11) {
                if(i<=20){
                    passengers[i].view.x = 50+ rail.view.x + rail.view.width/2 + (i % 2 == 1 ? + i* (passengerSize+passengerSpace) : - i*(passengerSize+passengerSpace));
                    passengers[i].view.y = 50+ rail.view.y + rail.view.height + passengerSize * 3+35;
                }else if ( i>20){
                    passengers[i].view.x = 50+ rail.view.x + rail.view.width/2 + (i % 2 == 1 ? + (i-20)* (passengerSize+passengerSpace) : - (i-20)*(passengerSize+passengerSpace));
                    passengers[i].view.y = 50+ rail.view.y + rail.view.height + passengerSize * 3 + 35-8;
                }
            }
            if (rail.type == RailType.HORIZONTAL && rail.id == 0) {
                if(i<=20){
                    passengers[i].view.x = -80+ rail.view.x + rail.view.width/2 + (i % 2 == 1 ? + i* (passengerSize+passengerSpace) : - i*(passengerSize+passengerSpace));
                    passengers[i].view.y = rail.view.y - passengerSize * 3;
                }else if ( i>20){
                    passengers[i].view.x = -80+rail.view.x + rail.view.width/2 + (i % 2 == 1 ? + (i-20)* (passengerSize+passengerSpace) : - (i-20)*(passengerSize+passengerSpace));
                    passengers[i].view.y = rail.view.y - passengerSize * 3-8;
                }
            }

        }
    }
}
}
