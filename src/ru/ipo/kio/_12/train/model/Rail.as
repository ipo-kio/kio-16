/**
 * ����
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model {
import flash.geom.Point;

import ru.ipo.kio._12.train.model.RailEnd;

import ru.ipo.kio._12.train.model.types.RailType;

import ru.ipo.kio._12.train.view.RailView;

public class Rail extends VisibleEntity {

    private var _trafficNetwork:TrafficNetwork;

    private var _firstEnd:RailEnd;

    private var _secondEnd:RailEnd;
    
    private var _type:RailType;

    private var passengers:Vector.<Passenger> = new Vector.<Passenger>();

    private var leavedPassengers:Vector.<Passenger> = new Vector.<Passenger>();

    private var _active:Boolean;

    private var _id:int;
    
    public function Rail(trafficNetword:TrafficNetwork, type:RailType, firstPoint:Point, secondPoint:Point) {
        _type=type;
        _trafficNetwork = trafficNetword;
        _firstEnd = new RailEnd(firstPoint, this);
        _secondEnd = new RailEnd(secondPoint, this);
        view = new RailView(this);
    }
    
    public function addPassenger(passenger:Passenger):void{
        if(passengers.length<4){
        passengers.push(passenger);
        }
    }
    
    public function getPassengers():Vector.<Passenger>{
        return passengers;
    }
    
    public function removePassenger(passenger:Passenger):Boolean{
        var removeIndex:int = passengers.indexOf(passengers);
        if(removeIndex!=-1){
            passengers = passengers.splice(removeIndex,1);
            return true;
        }else{
            return false;
        }
    }

    public function get firstEnd():RailEnd {
        return _firstEnd;
    }

    public function get secondEnd():RailEnd {
        return _secondEnd;
    }

    public function get type():RailType {
        return _type;
    }

    public function get trafficNetwork():TrafficNetwork {
        return _trafficNetwork;
    }


    public function get active():Boolean {
        return _active;
    }

    public function set active(value:Boolean):void {
        _active = value;
        view.update();
    }

    public function getConnectedRails():Vector.<Rail> {
        var list:Vector.<Rail> = new Vector.<Rail>();
        for (var i:int = 0; i < firstEnd.connectors.length; i++) {
           list.push(firstEnd.connectors[i].getAnotherRail(this));
        }
        for (var i:int = 0; i < secondEnd.connectors.length; i++) {
            list.push(secondEnd.connectors[i].getAnotherRail(this));
        }

        return list;
    }

    public function getEnd(preLastRail:Rail):RailEnd {
        for (var i:int = 0; i < firstEnd.connectors.length; i++) {
            if(firstEnd.connectors[i].getAnotherRail(this)==preLastRail){
                return firstEnd;
            }
        }
        for (var i:int = 0; i < secondEnd.connectors.length; i++) {
            if(secondEnd.connectors[i].getAnotherRail(this)==preLastRail){
                return secondEnd;
            }
        }
        return null;
    }

    public function getAnotherEnd(end:RailEnd):RailEnd {
        if(firstEnd==end){
            return secondEnd;
        }else{
            return firstEnd;
        }
    }

    public function getEndBy(end:RailEnd):RailEnd {
        for (var i:int = 0; i < firstEnd.connectors.length; i++) {
            if(firstEnd.connectors[i].getAnotherEnd(end)!=null){
                return firstEnd.connectors[i].getAnotherEnd(end);
            }
        }
        for (var i:int = 0; i < secondEnd.connectors.length; i++) {
            if(secondEnd.connectors[i].getAnotherEnd(end)!=null){
                return secondEnd.connectors[i].getAnotherEnd(end);;
            }
        }
        return null;
    }

    public function action(train:Train){
        for(var i:int=passengers.length-1; i>=0; i--){
            if(passengers[i].destination == train.getClosestStation()){
               train.passengers.push(passengers[i]);
               leavedPassengers.push(passengers[i]);
               passengers.splice(i, 1);
            }
        }
    }

    public function restorePassengers():void{
        for(var i:int=leavedPassengers.length-1; i>=0; i--){
            passengers.push(leavedPassengers[i]);
        }
        leavedPassengers = new Vector.<Passenger>();
    }

    public function getConnector(rail:Rail):RailConnector{
        for (var i:int = 0; i < firstEnd.connectors.length; i++) {
            if(firstEnd.connectors[i].getAnotherRail(this)==rail){
                return firstEnd.connectors[i];
            }
        }
        for (var i:int = 0; i < secondEnd.connectors.length; i++) {
            if(secondEnd.connectors[i].getAnotherRail(this)==rail){
                return secondEnd.connectors[i];
            }
        }
        return null;
    }


    public function get id():int {
        return _id;
    }

    public function set id(value:int):void {
        _id = value;
    }
}
}
