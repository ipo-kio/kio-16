/**
 *
 * @author: Vasily Akimushkin
 * @since: 12.02.12
 */
package ru.ipo.kio._12.train.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._12.train.model.Passenger;

import ru.ipo.kio._12.train.model.TrafficNetwork;

import ru.ipo.kio._12.train.model.Train;
import ru.ipo.kio._12.train.model.types.StationType;
import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.view.gui.BlueTram;
import ru.ipo.kio._12.train.view.gui.GreenTram;
import ru.ipo.kio._12.train.view.gui.RedTram;
import ru.ipo.kio._12.train.view.gui.YellowTram;

public class TrainView extends BasicView {


    private var train:Train;
    
    private var dragged:Boolean = false;
    
    private var tram:Sprite;
    
    public function TrainView(train:Train) {
        this.train=train;
        addEventListener(MouseEvent.CLICK, function(event:Event):void{

//            if(!dragged){
//                startDrag();
//                dragged=true;
//            }else{
//                stopDrag();
//                dragged=false;
//                trace(x-train.rail.view.x);
//                trace(y-train.rail.view.y);
//            }


            if(TrafficNetwork.instance.activeTrain == train){
                TrafficNetwork.instance.activeTrain = null;
            }else{
                TrafficNetwork.instance.activeTrain = train;
            }
        });



        
        if(train.destination==StationType.FIRST){
            tram = new BlueTram();
            addChild(tram);
        }
        else if(train.destination==StationType.SECOND){
            tram = new YellowTram();
            addChild(tram);
        }
        else if(train.destination==StationType.THIRD){
            tram = new RedTram();
            addChild(tram);
        }
        else if(train.destination==StationType.FOURTH){
            tram = new GreenTram();
            addChild(tram);
        }
    }

    public override function update():void{
        var length:int = train.rail.trafficNetwork.railLength;
        var view:BasicView = train.rail.view;

        var shiftX:int = 12;
        var shiftY:int = 12;
        x = train.rail.view.x; 
        y = train.rail.view.y;

        if(train.rail.type == RailType.ROUND_TOP_LEFT){
            rotation = -45;
            x += 21;
            y += 22;
        }
        else if(train.rail.type == RailType.ROUND_TOP_RIGHT){
            rotation = 45;
            if(TrafficNetwork.instance.level==1 || TrafficNetwork.instance.level==2){
                x += 73;
                y += 23;
            }else if(TrafficNetwork.instance.level==0){
                x += 117;
                y += 23;
            }
        }
        else if(train.rail.type == RailType.ROUND_BOTTOM_LEFT){
            rotation = 45;
            if(TrafficNetwork.instance.level==1  || TrafficNetwork.instance.level==2){
                x += 23;
                y += 76;
            }else if(TrafficNetwork.instance.level==0){
                x += 24;
                y += 120;
            }
        }
        else if(train.rail.type == RailType.ROUND_BOTTOM_RIGHT){
            rotation = -45;
            x += 75;
            y += 72;
        }
        else if (train.rail.type == RailType.HORIZONTAL) {
            if(!train.isFinished()){
                rotation = train.isDirect()? 0:180;
            }
            x += view.width / 2;
            y += view.height / 2;
        }
        else if (train.rail.type == RailType.VERTICAL) {
            if(!train.isFinished()){
                rotation = train.isDirect()? 90:-90;
            }
            x += view.width / 2;
            y += view.height / 2;
        }
        else if (train.rail.type == RailType.SEMI_ROUND_BOTTOM) {
            if(!train.isFinished()){
                rotation = train.isDirect()? 0:180;
            }
            x += view.width / 2;
            y += view.height - tram.height/2;
        }
        else if (train.rail.type == RailType.SEMI_ROUND_TOP) {
            if(!train.isFinished()){
                rotation = train.isDirect()? 0:180;
            }
            x += view.width / 2;
            y += tram.height/2;
        }
        else if (train.rail.type == RailType.SEMI_ROUND_LEFT) {
            if(!train.isFinished()){
                rotation = train.isDirect()? 90:-90;
            }
            x += tram.height / 2;
            y += view.height/2;
        }else if (train.rail.type == RailType.SEMI_ROUND_RIGHT) {
            if(!train.isFinished()){
                rotation = train.isDirect()? 90:-90;
            }
            x += view.width - tram.height/2;
            y += view.height/2;
        }else {
            x=train.rail.view.x;
            y=train.rail.view.y;
        }


        var passengers:Vector.<Passenger> = train.passengers;
        for (var i:int = 0; i < passengers.length; i++) {
            if (TrafficNetwork.instance.view.contains(passengers[i].view)) {
                TrafficNetwork.instance.view.removeChild(passengers[i].view);
            }
        }

        
    }
}
}
