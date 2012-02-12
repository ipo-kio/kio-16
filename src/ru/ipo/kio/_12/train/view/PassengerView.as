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
import ru.ipo.kio._12.train.model.types.RailType;

public class PassengerView extends BasicView {
    
    private var passenger:Passenger;
    
    public function PassengerView(passenger:Passenger) {
        this.passenger=passenger;
        place(passenger);
        update();
    }

    private function place(passenger:Passenger):void {

    }

     public override function update():void{
         graphics.clear();
         graphics.lineStyle(0,passenger.destination.color);
         graphics.beginFill(passenger.destination.color);
         graphics.drawCircle(-TrafficNetwork.instance.passengerSize,-TrafficNetwork.instance.passengerSize, TrafficNetwork.instance.passengerSize);
         graphics.endFill();
     }
}
}
