/**
 *
 * @author: Vasily Akimushkin
 * @since: 12.02.12
 */
package ru.ipo.kio._12.train.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._12.train.model.FirstLevelTrainPlacer;

import ru.ipo.kio._12.train.model.Passenger;
import ru.ipo.kio._12.train.model.Rail;
import ru.ipo.kio._12.train.model.RailConnector;

import ru.ipo.kio._12.train.model.TrafficNetwork;

import ru.ipo.kio._12.train.model.Train;
import ru.ipo.kio._12.train.model.ZeroLevelTrainPlacer;
import ru.ipo.kio._12.train.model.types.RailConnectorType;
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
        this.train = train;

        if (TrafficNetwork.instance.level != 2)
            addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {

                if (event.altKey) {
                    train.view.rotation += 15;
                    return;
                }
                if (event.ctrlKey) {
                    train.view.rotation -= 15;
                    return;
                }
                if (!dragged) {
                    startDrag();
                    dragged = true;
                } else {
                    stopDrag();
                    dragged = false;
                    trace("{x:"+(-train.rail.view.x + x)+", y:"+(-train.rail.view.y + y)+", r:"+(rotation)+"},");
                }


//            if(TrafficNetwork.instance.activeTrain == train){
//                TrafficNetwork.instance.activeTrain = null;
//            }else{
//                TrafficNetwork.instance.activeTrain = train;
//            }
            });


        if (train.destination == StationType.FIRST) {
            tram = new BlueTram();
            addChild(tram);
        }
        else if (train.destination == StationType.SECOND) {
            tram = new YellowTram();
            addChild(tram);
        }
        else if (train.destination == StationType.THIRD) {
            tram = new RedTram();
            addChild(tram);
        }
        else if (train.destination == StationType.FOURTH) {
            tram = new GreenTram();
            addChild(tram);
        }
    }

    public function preupdate():void {
        var length:int = train.rail.trafficNetwork.railLength;
        var view:BasicView = train.rail.view;

        var shiftX:int = 12;
        var shiftY:int = 12;

        var preRail:Rail = train.getPreRail();
        if (preRail == null || preRail == train.rail) {
            update();
            return;
        }

        var con:RailConnector = train.rail.getConnector(preRail);
        var v:BasicView = con.view;
        x = v.x;
        y = v.y;
        if (con.type == RailConnectorType.HORIZONTAL) {
            x += 157;
        } else if (con.type == RailConnectorType.VERTICAL) {

        } else if (con.type == RailConnectorType.BOTTOM_RIGHT && preRail.view.y >= train.rail.view.y) {

        } else if (con.type == RailConnectorType.BOTTOM_RIGHT && preRail.view.y < train.rail.view.y) {

        } else if (con.type == RailConnectorType.BOTTOM_LEFT && preRail.view.y >= train.rail.view.y) {

        } else if (con.type == RailConnectorType.BOTTOM_LEFT && preRail.view.y < train.rail.view.y) {

        } else if (con.type == RailConnectorType.TOP_RIGHT && preRail.view.y <= train.rail.view.y) {

        } else if (con.type == RailConnectorType.TOP_RIGHT && preRail.view.y > train.rail.view.y) {

        } else if (con.type == RailConnectorType.TOP_LEFT && preRail.view.y <= train.rail.view.y) {

        } else if (con.type == RailConnectorType.TOP_LEFT && preRail.view.y > train.rail.view.y) {

        }


    }

    var initR;


    public override function update():void {
        var view:BasicView = train.rail.view;
        x = train.rail.view.x;
        y = train.rail.view.y;
        if (TrafficNetwork.instance.level == 0) {
            ZeroLevelTrainPlacer.place(train, this, tram.width, tram.height);
        } else {
            FirstLevelTrainPlacer.place(train, this, tram.width, tram.height);
        }
        var passengers:Vector.<Passenger> = train.passengers;
        for (var i:int = 0; i < passengers.length; i++) {
            if (TrafficNetwork.instance.view.contains(passengers[i].view)) {
                TrafficNetwork.instance.view.removeChild(passengers[i].view);
            }
        }
        
        initR = rotation;
    }


}
}
