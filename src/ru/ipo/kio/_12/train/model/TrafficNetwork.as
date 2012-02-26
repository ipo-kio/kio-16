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

import ru.ipo.kio._12.train.model.types.RegimeType;
import ru.ipo.kio._12.train.model.types.StationType;

import ru.ipo.kio._12.train.util.ConnectorInPath;

import ru.ipo.kio._12.train.util.Pair;
import ru.ipo.kio._12.train.util.TrafficNetworkCreator;
import ru.ipo.kio._12.train.view.BasicView;
import ru.ipo.kio._12.train.view.CrossConnectorView;
import ru.ipo.kio._12.train.view.RailView;

import ru.ipo.kio._12.train.view.TrafficNetworkView;

public class TrafficNetwork extends VisibleEntity {

    private static var _instance:TrafficNetwork;

    private var _railLength:int;

    private var _railSpace:int;

    private var _railWidth:int;

    private var _maxPassengers:int;

    private var _passengerSize:int;

    private var _passengerSpace:int;

    private var _regime:RegimeType = RegimeType.EDIT;

    private var _rails:Vector.<Rail> = new Vector.<Rail>();

    private var _connectorViews:Vector.<BasicView> = new Vector.<BasicView>();
    
    private var _trains:Vector.<Train> = new Vector.<Train>();
    
    private var _activeTrain:Train;

    private var _amountOfPassengers:int = 0;

    private var _amountOfHappyPassengers:int = 0;

    private var _timeOfTrip:int = 0;

    private var _timeOfStep = 1000;

    private var _level;

    private var _cnt:int = 0;

    private var _fault:Boolean;

    private var _amountOfTrain:int;


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
        (RailView(rail.view)).addSelector();
        _amountOfPassengers+=rail.getPassengers().length;
        rail.id=_cnt;
        _cnt++;
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

    public function get level():* {
        return _level;
    }

    public function set level(value):void {
        _level = value;
    }

    public function get connectorViews():Vector.<BasicView> {
        return _connectorViews;
    }

    public function set connectorViews(value:Vector.<BasicView>):void {
        _connectorViews = value;
    }

    public function calcConnectors():void {
        for(var i:int = 0; i<trains.length; i++){
            var tempTrain:Train = trains[i];
            var tick:int = 0;

            for(var j:int=0; j<tempTrain.route.rails.length-1; j++){
                var rail:Rail = tempTrain.route.rails[j];
                var railNext:Rail = tempTrain.route.rails[j+1];
                var connector:RailConnector = rail.getConnector(railNext);
                (CrossConnectorView(connector.view)).connectorInPath.push(new ConnectorInPath(connector.type, i, tick, tempTrain.color, activeTrain==tempTrain));
                tick+=rail.type.length;
            }
        }
    }

    private function checkError():void {
        for(var i:int = 0; i<trains.length; i++){
            var train:Train =  trains[i];
            for(var j:int = i+1; j<trains.length; j++){
                var train1:Train =  trains[j];
                if(train.rail==train1.rail){
                    fault=true;
                }

            }

        }
    }

    public function resetTrains():void{
        for(var i:int = 0; i<trains.length; i++){
            var train:Train =  trains[i];
            train.reset();
            view.update();
        }
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



    public function addToActiveRoute(rail:Rail):void {
        resetToEdit();
        activeTrain.route.addRail(rail);
        moveTrainToLast();
        view.update();
    }

    public function removeLastFromActive():void {
        resetToEdit();
        if(activeTrain!=null){
            if(activeTrain.route.rails.length>1){
                activeTrain.route.removeLast();
            }
        }
        moveTrainToLast();
        view.update();
    }

    public function clearRoutes():void {
        if(level!=2){
            resetToEdit();
        }
        if(activeTrain!=null){
            while(activeTrain.route.rails.length>1){
                activeTrain.route.removeLast();
            }
        }else{
        for(var i:int = 0; i<trains.length; i++){
            var tempTrain:Train = trains[i];
            while(tempTrain.route.rails.length>1){
                tempTrain.route.removeLast();
            }
        }
        }
        moveTrainToLast();
        view.update();
    }

    public function set activeTrain(value:Train):void {
        _activeTrain = value;
        if(value!=null){
            resetToEdit();
            moveTrainToLast();
        }
        view.update();

    }

    public function calc():void{
        initial();

        var max:int = getMaximumLength();
        
        for(var j:int = 0; j<max; j++){
            doAction();
        }
    }

    var timer:Timer;

    public function play():void {

        if(_regime==RegimeType.PLAY){
            return;
        }

        moveToStep();

        _regime = RegimeType.PLAY;
        
        if(timer!=null){
            timer.stop();
        }

        timer = new Timer(_timeOfStep, getMaximumLength());

        timer.addEventListener(TimerEvent.TIMER, function(event:Event):void{
            if(regime!=RegimeType.PLAY){
                return;
            }
            doAction();
        });

        timer.start();
    }

    private function doAction():void {
        for (var i:int = 0; i < trains.length; i++) {
            var train:Train = trains[i];
            train.action();
        }
        checkError();
        TrafficNetworkCreator.instance.result.text = "passengers: " + amountOfHappyPassengers + "/" + amountOfPassengers +
                "\ntime: " + timeOfTrip / amountOfHappyPassengers;
        
        if(_fault){
            TrafficNetworkCreator.instance.result.text += "\n Столкновение";
        }

        view.update();
    }



    public function initial():void{
        activeTrain=null;
        resetToEdit();
        moveToStep();
        resetToEdit();
        moveToStep();
    }

    public function step():void{
        moveToStep();
        doAction();
    }


    public function moveToStep():void{

        if(_regime==RegimeType.STEP){
            return;
        }

        if(_regime==RegimeType.PLAY){
            if(timer!=null){
                timer.stop;
            }
            _regime = RegimeType.STEP;
            return;
        }

        activeTrain=null;

        _regime = RegimeType.STEP;

        TrafficNetworkCreator.instance.result.text = "";

        _fault=false;
        amountOfHappyPassengers=0;
        timeOfTrip = 0;

        for(var i:int = 0; i<trains.length; i++){
            var tempTrain:Train = trains[i];
            tempTrain.reset();
        }

        for(var i:int = 0; i<rails.length; i++){
            rails[i].restorePassengers();
            if(rails[i] instanceof TrainStation){
                ( TrainStation (rails[i])).reset();
            }
        }

    }

    public function moveTrainToLast():void{
        for(var i:int = 0; i<trains.length; i++){
            var tempTrain:Train = trains[i];
            tempTrain.moveLast();
        }
    }


    public function resetToEdit():void{

        if(regime==RegimeType.PLAY){
            if(timer!=null){
                timer.stop;
            }
        }

        if(regime==RegimeType.EDIT){
            return;
        }

        _regime = RegimeType.EDIT;

        TrafficNetworkCreator.instance.result.text = "";

        _fault=false;
        amountOfHappyPassengers=0;
        timeOfTrip = 0;

        for(var i:int = 0; i<trains.length; i++){
            var tempTrain:Train = trains[i];
            tempTrain.reset();
        }
        
        for(var i:int = 0; i<rails.length; i++){
            rails[i].restorePassengers();
            if(rails[i] instanceof TrainStation){
                ( TrainStation (rails[i])).reset();
            }
        }
        
        if(level ==2){
            clearRoutes();
        }
    }

    public function get fault():Boolean {
        return _fault;
    }

    public function set fault(value:Boolean):void {
        _fault = value;
    }

    public function getRailById(id:int):Rail {
        for(var i:int = 0; i<rails.length; i++){
            if(rails[i].id==id){
                return rails[i];
            }
        }
        throw new Error("Can't find rail with id "+id);
    }

    public function get regime():RegimeType {
        return _regime;
    }

    public function get amountOfTrain():int {
        return _amountOfTrain;
    }

    public function set amountOfTrain(value:int):void {
        _amountOfTrain = value;
    }
    
    public function getTrainByType(type:StationType):Train{
        for(var i:int = 0; i<trains.length; i++){
            if(trains[i].destination==type){
                return trains[i];
            }
        }
        throw new Error("Can't find train by type: "+type.toString());
        
    }

    public function get timeOfTrip():int {
        return _timeOfTrip;
    }

    public function set timeOfTrip(value:int):void {
        _timeOfTrip = value;
    }

    public function get cnt():int {
        return _cnt;
    }
}
}
class PrivateClass{
    public function PrivateClass(){

    }
}
