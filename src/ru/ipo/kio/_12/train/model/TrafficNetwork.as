/**
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.model {
import flash.events.Event;
import flash.events.TimerEvent;
import flash.sampler._getInvocationCount;
import flash.utils.Timer;

import org.osmf.layout.PaddingLayoutFacet;

import ru.ipo.kio._12.train.util.Pair;
import ru.ipo.kio._12.train.util.TrafficNetworkCreator;

import ru.ipo.kio._12.train.view.TrafficNetworkView;

public class TrafficNetwork extends VisibleEntity {

    private static var _instance:TrafficNetwork;

    private var _railLength:int;

    private var _railSpace:int;

    private var _railWidth:int;

    private var _maxPassengers:int;

    private var _passengerSize:int;

    private var _passengerSpace:int;

    private var _rails:Vector.<Rail> = new Vector.<Rail>();
    
    private var _trains:Vector.<Train> = new Vector.<Train>();
    
    private var _activeTrain:Train;

    private var _amountOfPassengers:int =0;

    private var _amountOfHappyPassengers:int =0;

    private var _timeOfStep = 1000;

    private var railConnectors:Vector.<RailConnector> = new Vector.<RailConnector>();

    public static function get instance():TrafficNetwork {
        if(TrafficNetwork._instance == null)
            TrafficNetwork._instance=new TrafficNetwork(new PrivateClass( ));
        return _instance;
    }


    public function TrafficNetwork(privateClass:PrivateClass) {
        view=new TrafficNetworkView(this);
    }


    public function get maxPassengers():int {
        return _maxPassengers;
    }

    public function set maxPassengers(value:int):void {
        _maxPassengers = value;
    }

    public function reset():void{
        for(var i:int=0; i<_rails.length; i++){
            _rails[i].active = false;
        }
    }

    public function get railLength():int {
        return _railLength;
    }

    public function set railLength(value:int):void {
        _railLength = value;
    }

    public function get railSpace():int {
        return _railSpace;
    }

    public function set railSpace(value:int):void {
        _railSpace = value;
    }

    public function get amountOfPassengers():int {
        return _amountOfPassengers;
    }

    public function addRail(rail:Rail):void{
        _rails.push(rail);
        view.addChild(rail.view);
        _amountOfPassengers+=rail.getPassengers().length;
    }

    public function getRail(index:int):Rail{
        return _rails[index];
    }

    public function set railWidth(railWidth:int):void {
        _railWidth = railWidth;
    }

    public function get railWidth():int {
        return _railWidth;
    }

    public function get rails():Vector.<Rail> {
        return _rails;
    }

    public function set passengerSize(passengerSize:int):void {
        _passengerSize = passengerSize;
    }

    public function get passengerSize():int {
        return _passengerSize;
    }

    public function get passengerSpace():int {
        return _passengerSpace;
    }

    public function set passengerSpace(value:int):void {
        _passengerSpace = value;
    }

    public function get trains():Vector.<Train> {
        return _trains;
    }


    public function getRouteColor(rail:Rail):Vector.<Pair> {
        var counts:Vector.<Pair> = new Vector.<Pair>();
        for(var i:int = 0; i<trains.length; i++){
            var count:int = trains[i].route.getAmountOfInput(rail);
            counts.push(new Pair(trains[i], count));
        }
        return counts;
    }

    public function get activeTrain():Train {
        return _activeTrain;
    }

    public function set activeTrain(value:Train):void {
        _activeTrain = value;
        view.update();
    }

    public function isPossibleAdd(rail:Rail):Boolean {
       if(activeTrain!=null && !activeTrain.route.finished){
            if(activeTrain.route.rails.length==1){
                var lastRail:Rail = activeTrain.route.rails[0];
                if(lastRail==rail){
                    return false;
                }
                return lastRail.firstEnd.isConnected(rail) || lastRail.secondEnd.isConnected(rail);
            }else{
//                var lastRail:Rail = activeTrain.route.rails[activeTrain.route.rails.length-1];
//                var preLastRail:Rail = activeTrain.route.rails[activeTrain.route.rails.length-2];
//                var end:RailEnd = lastRail.getConnector(preLastRail);

                var end:RailEnd = activeTrain.route.getLastEnd();

                //return lastRail.getAnotherEnd(end).isConnected(rail);

                return end.isConnected(rail);
            }
       }
       return false;
    }

    public function addToActiveRoute(rail:Rail):void {
        activeTrain.route.addRail(rail);
        view.update();
    }

    public function removeLastFromActive():void {
       if(activeTrain!=null){
           if(activeTrain.route.rails.length>1){
            activeTrain.route.removeLast();
        }
       }
        view.update();
    }

    public function clearRoutes():void {

        for(var i:int = 0; i<trains.length; i++){
            var tempTrain:Train = trains[i];
            while(tempTrain.route.rails.length>1){
                tempTrain.route.removeLast();
            }
        }

        view.update();
    }

    public function tryClose():void {
      if(activeTrain.route.rails.length>1 && activeTrain.route.getLastEnd().isConnected(activeTrain.rail)){
          activeTrain.route.addRail(activeTrain.rail);
          activeTrain.route.finish();
          activeTrain=null;
      }
        view.update();
    }

    public function play():void {
        for(var i:int = 0; i<trains.length; i++){
            if(!trains[i].route.finished){
                return;
            }
        }

        var timer:Timer = new Timer(_timeOfStep, getMaximumLength());

        timer.addEventListener(TimerEvent.TIMER, function(event:Event):void{
            for(var i:int = 0; i<trains.length; i++){
                var train:Train =  trains[i];
                train.action();
            }
            view.update();
        });

        timer.addEventListener(TimerEvent.TIMER_COMPLETE, function(event:Event):void{

            TrafficNetworkCreator.instance.result.text = "passengers: "+amountOfHappyPassengers+"/"+amountOfPassengers+
                    "  time: "+getMaximumLength();

            for(var i:int = 0; i<trains.length; i++){
                var train:Train =  trains[i];
                train.reset();
            }
        });
        
        timer.start();



    }

    private function getMaximumLength():int {
        var l:int = 0;
        for(var i:int = 0; i<trains.length; i++){
            if(trains[i].route.time>l){
                l = trains[i].route.time;
            }
        }
        return l;
    }

    public function get amountOfHappyPassengers():int {
        return _amountOfHappyPassengers;
    }

    public function set amountOfHappyPassengers(value:int):void {
        _amountOfHappyPassengers = value;
    }

    public function get timeOfStep():* {
        return _timeOfStep;
    }

    public function set timeOfStep(value):void {
        _timeOfStep = value;
    }
}
}
class PrivateClass{
    public function PrivateClass(){

    }
}
