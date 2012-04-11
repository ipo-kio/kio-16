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
import ru.ipo.kio._12.train.view.TrainView;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.controls.RecordBlinkEffect;

public class TrafficNetwork extends VisibleEntity {


    public var api:KioApi;

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
    
    private var _times:Array=new Array();


    public static function get instance():TrafficNetwork {
        if(TrafficNetwork._instance == null)
            TrafficNetwork._instance=new TrafficNetwork(new PrivateClass( ));
        return _instance;
    }

    public static function reset_singleton():void {
        _instance = null;
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
            var count1:int = trains[i].route.getAmountOfDirectInput(rail);
            var count2:int = trains[i].route.getAmountOfReverseInput(rail);
            counts.push(new Pair(trains[i], count1, count2));
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
                if(train.tick==0 && train1.tick==0
                   && train.getPreRail()!=null
                   && train1.getPreRail()!=null){

                    var c1:RailConnector = train.rail.getConnector(train.getPreRail());
                    var c2:RailConnector = train1.rail.getConnector(train1.getPreRail());
                    
                    if(c1!=null && c2!=null && c1.view==c2.view)
                        fault = true;
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
        if(level == 2)
            return 100;
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
        api.autoSaveSolution();
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
        api.autoSaveSolution();
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
        api.autoSaveSolution();
    }

    public function set activeTrain(value:Train):void {
        _activeTrain = value;
        if(value!=null){
            resetToEdit();
            moveTrainToLast();
        }
        view.update();

    }

    var viewUpdateLock:Boolean = false;

    public function calc():void{
        initial();


        var max:int = getMaximumLength();

        viewUpdateLock = true;

        for(var j:int = 0; j<max; j++){
            doAction();
        }

        viewUpdateLock=false;
        
        view.update();
    }

    private var additionTick = 0;
    
    private var _inner:int = 0;

    public function innerTick():void{
//        if(additionTick != 2 ){
//            additionTick++;
//            return;
//        }
//
//        additionTick=0;

        if(_inner == (8*4-1) ){
            _inner = 0;
            doAction();
            view.update();
        }else{
            _inner++;
            for(var i:int = 0; i<trains.length; i++){
                trains[i].view.update();
            }
        }

    }

    public function play():void {

        if(_regime==RegimeType.PLAY){
            return;
        }

        moveToStep();
        _inner=0;
        additionTick=0;
        _regime = RegimeType.PLAY;
        

    }
    
    var record:Object = {time:999, pas:0};

    private function doAction():void {
        
        var finish:Boolean = true;
        
        for (var i:int = 0; i < trains.length; i++) {
            var train:Train = trains[i];
            train.action();

            if(!train.isFinish()){
                finish = false;
            }
        }
        checkError();
        TrafficNetworkCreator.instance.resultAmount.htmlText = "<p align='center'>"+amountOfHappyPassengers + " из " + amountOfPassengers+"</p>";
        if(level == 0){
            var maxTime:int = getMaxTime();
            TrafficNetworkCreator.instance.resultTime.htmlText = "<p align='center'>"+ maxTime+"</p>";
        }
        else {
            //if(amountOfHappyPassengers!=0)
                TrafficNetworkCreator.instance.resultTime.htmlText = "<p align='center'>"+ getMediana()+"</p>";
            //else
            //    TrafficNetworkCreator.instance.resultTime.htmlText = "<p align='center'>0</p>";

        }
        
        if(_fault){
            TrafficNetworkCreator.instance.resultCrash.visible = true;
        }
        
        if(!viewUpdateLock)
            view.update();

        if(finish && !fault){
            if(level ==0 ){
              if(amountOfHappyPassengers>record.pas){
                  updateRecordZero(maxTime);
              }else if(amountOfHappyPassengers==record.pas && record.time>maxTime){
                  updateRecordZero(maxTime);
              }
            }else{
                if(amountOfHappyPassengers>record.pas){
                    updateRecordFirst(maxTime);
                }else if(amountOfHappyPassengers==record.pas && amountOfHappyPassengers!=0 && record.time>getMediana()){
                    updateRecordFirst(maxTime);
                }
            }

        }
    }

    public function getMaxTime():int {
        var maxTime:int = 0;
        for (var i:int = 0; i < trains.length; i++) {
            var tempTrain:Train = trains[i];
            maxTime = Math.max(tempTrain.toPasTime, maxTime);
        }
        return maxTime;
    }

    public function getMediana():int {
        _times = _times.sort(Array.NUMERIC);
        if(_times.length==0)
            return 0;
        if(_times.length%2==1){
            return times[Math.floor(_times.length/2)];
        }else{
            return (times[_times.length/2]+times[_times.length/2-2])/2;
        }
    }

    private function updateRecordFirst(maxTime:int):void {
        record.pas = amountOfHappyPassengers;
        record.time = getMediana();
        //RecordBlinkEffect.blink();
        api.saveBestSolution();
        TrafficNetworkCreator.instance.resultAmountRecord.htmlText = "<p align='center'>" + amountOfHappyPassengers + " из " + amountOfPassengers + "</p>";
        //if(amountOfHappyPassengers!=0)
//            TrafficNetworkCreator.instance.resultTimeRecord.htmlText = "<p align='center'>"+ (timeOfTrip / amountOfHappyPassengers).toFixed(3)+"</p>";
  //      else
            TrafficNetworkCreator.instance.resultTimeRecord.htmlText = "<p align='center'>"+getMediana()+"</p>";
    }


    private function updateRecordZero(maxTime:int):void {
        record.pas = amountOfHappyPassengers;
        record.time = maxTime;
        //RecordBlinkEffect.blink();
        api.saveBestSolution();
        TrafficNetworkCreator.instance.resultAmountRecord.htmlText = "<p align='center'>" + amountOfHappyPassengers + " из " + amountOfPassengers + "</p>";
        TrafficNetworkCreator.instance.resultTimeRecord.htmlText = "<p align='center'>" + maxTime + "</p>";
    }

    public function initial():void{
        activeTrain=null;
        _times=new Array();
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
            _regime = RegimeType.STEP;
            _inner=0;
            additionTick=0;
            return;
        }

        activeTrain=null;

        _regime = RegimeType.STEP;

        TrafficNetworkCreator.instance.resultCrash.visible = false;
        TrafficNetworkCreator.instance.resultAmount.htmlText = "<p align='center'>0</p>";
        TrafficNetworkCreator.instance.resultTime.htmlText = "<p align='center'>0</p>";


        _fault=false;
        amountOfHappyPassengers=0;
        timeOfTrip = 0;
        _times=new Array();

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
            _inner=0;
            additionTick=0;
        }

        if(regime==RegimeType.EDIT){
            return;
        }

        _regime = RegimeType.EDIT;

        TrafficNetworkCreator.instance.resultCrash.visible = false;
        TrafficNetworkCreator.instance.resultAmount.htmlText = "<p align='center'>0</p>";
        TrafficNetworkCreator.instance.resultTime.htmlText = "<p align='center'>0</p>";

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

    public function resetArrows():void {
        resetToEdit();
         for(var i:int = 0; i<connectorViews.length; i++){
             (CrossConnectorView(connectorViews[i])).randomType();
         }
        view.update();
    }

    public function get inner():int {
        return _inner;
    }

    public function set amountOfPassengers(value:int):void {
        _amountOfPassengers = value;
    }

    public function get times():Array {
        return _times;
    }

    public function set times(value:Array):void {
        _times = value;
    }
}
}
class PrivateClass{
    public function PrivateClass(){

    }
}
