/**
 * Отображение для рассажира.
 * Цветная точка.
 *
 * @author: Vasily Akimushkin
 * @since: 30.01.12
 */
package ru.ipo.kio._12.train.view {

import ru.ipo.kio._12.train.model.Passenger;
import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.types.StationType;

public class PassengerView extends BasicView {

    [Embed(source='../_resources/one/Dot_red.png')]
    private static const LEVEL_1_RED:Class;

    [Embed(source='../_resources/one/Dot_green.png')]
    private static const LEVEL_1_GREEN:Class;

    [Embed(source='../_resources/one/Dot_blue.png')]
    private static const LEVEL_1_BLUE:Class;

    [Embed(source='../_resources/one/Dot_yellow.png')]
    private static const LEVEL_1_YELLOW:Class;

    [Embed(source='../_resources/zero/Dot_red.png')]
    private static const LEVEL_0_RED:Class;

    [Embed(source='../_resources/zero/Dot_blue.png')]
    private static const LEVEL_0_BLUE:Class;

    private var passenger:Passenger;
    
    public function PassengerView(passenger:Passenger) {
        this.passenger=passenger;
        addPicture(passenger);
        update();
    }

    private function addPicture(passenger:Passenger):void {
        var passengerPicture;
        if(TrafficNetwork.instance.level==1 || TrafficNetwork.instance.level==2){
            passengerPicture = getPictureForFirstSecondLevel(passenger);
        }else if (TrafficNetwork.instance.level==0){
            passengerPicture = getPictureForZeroLevel(passenger);
        }else{
            throw new Error("Undefined level: "+TrafficNetwork.instance.level);
        }
        addChild(passengerPicture);
    }

    private function getPictureForZeroLevel(passenger:Passenger):* {
        var passengerPicture;
        if (passenger.destination == StationType.FIRST) {
            passengerPicture = new LEVEL_0_BLUE;
        } else if (passenger.destination == StationType.THIRD) {
            passengerPicture = new LEVEL_0_RED;
        } else {
            throw new Error("Undefined passenger destination");
        }
        return passengerPicture;
    }

    private function getPictureForFirstSecondLevel(passenger:Passenger):* {
        var passengerPicture;
        if (passenger.destination == StationType.FIRST) {
            passengerPicture = new LEVEL_1_BLUE;
        } else if (passenger.destination == StationType.SECOND) {
            passengerPicture = new LEVEL_1_YELLOW;
        } else if (passenger.destination == StationType.THIRD) {
            passengerPicture = new LEVEL_1_RED;
        } else if (passenger.destination == StationType.FOURTH) {
            passengerPicture = new LEVEL_1_GREEN;
        } else {
            throw new Error("Undefined passenger destination");
        }
        return passengerPicture;
    }

    public override function update():void{

     }
}
}
