/**
 *
 * @author: Vasily Akimushkin
 * @since: 30.01.12
 */
package ru.ipo.kio._12.train.view {
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._12.train.model.Rail;
import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.TrainStation;
import ru.ipo.kio._12.train.model.types.RailStationType;
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
        if(station.stationType==RailStationType.FIRST){
            line = new LEVEL_1_BLUE;
        }
        else if(station.stationType==RailStationType.SECOND){
            line = new LEVEL_1_YELLOW;
        }
        else if(station.stationType==RailStationType.THIRD){
            line = new LEVEL_1_RED;
        }
        else if(station.stationType==RailStationType.FOURTH){
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






     }
}
}
