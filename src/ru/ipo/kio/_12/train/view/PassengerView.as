/**
 *
 * @author: Vasily Akimushkin
 * @since: 30.01.12
 */
package ru.ipo.kio._12.train.view {
import flash.events.MouseEvent;

import ru.ipo.kio._12.train.model.Passenger;

import ru.ipo.kio._12.train.model.Rail;
import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.types.StationType;
import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio.base.displays.AboutDisplay;

public class PassengerView extends BasicView {

    [Embed(source='../_resources/Dot_red.png')]
    private static const LEVEL_1_RED:Class;

    [Embed(source='../_resources/Dot_green.png')]
    private static const LEVEL_1_GREEN:Class;

    [Embed(source='../_resources/Dot_blue.png')]
    private static const LEVEL_1_BLUE:Class;

    [Embed(source='../_resources/Dot_yellow.png')]
    private static const LEVEL_1_YELLOW:Class;

    private var passenger:Passenger;
    
    public function PassengerView(passenger:Passenger) {
        this.passenger=passenger;
        place(passenger);
        update();
    }

    private function place(passenger:Passenger):void {
        var line;
        if(passenger.destination==StationType.FIRST){
            line = new LEVEL_1_BLUE;
        }
        else if(passenger.destination==StationType.SECOND){
            line = new LEVEL_1_YELLOW;
        }
        else if(passenger.destination==StationType.THIRD){
            line = new LEVEL_1_RED;
        }
        else if(passenger.destination==StationType.FOURTH){
            line = new LEVEL_1_GREEN;
        }
        addChild(line);
    }

     public override function update():void{

     }
}
}
