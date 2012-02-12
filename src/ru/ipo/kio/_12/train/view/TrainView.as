/**
 *
 * @author: Vasily Akimushkin
 * @since: 12.02.12
 */
package ru.ipo.kio._12.train.view {
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._12.train.model.Passenger;

import ru.ipo.kio._12.train.model.TrafficNetwork;

import ru.ipo.kio._12.train.model.Train;
import ru.ipo.kio._12.train.model.types.RailType;

public class TrainView extends BasicView {

    private var train:Train;
    
    public function TrainView(train:Train) {
        this.train=train;
        addEventListener(MouseEvent.CLICK, function(event:Event):void{
            if(TrafficNetwork.instance.activeTrain == train){
                TrafficNetwork.instance.tryClose();
            }else{
                TrafficNetwork.instance.activeTrain = train;
            }
        });
    }

    public override function update():void{
        var length:int = train.rail.trafficNetwork.railLength;

        if (train.rail.type == RailType.HORIZONTAL) {
            x = train.rail.view.x + length / 2;
            y = train.rail.view.y;
        }
        else if (train.rail.type == RailType.VERTICAL) {
            x = train.rail.view.x;
            y = train.rail.view.y + length / 2;
        }
        else if (train.rail.type == RailType.SEMI_ROUND_BOTTOM) {
            x = train.rail.view.x + length / 2;
            y = train.rail.view.y + length / 2;
        }
        else if (train.rail.type == RailType.SEMI_ROUND_TOP) {
            x = train.rail.view.x + length / 2;
            y = train.rail.view.y + length / 2;
        }
        else if (train.rail.type == RailType.SEMI_ROUND_LEFT || train.rail.type == RailType.SEMI_ROUND_RIGHT) {
            x = train.rail.view.x + length / 2;
            y = train.rail.view.y + length / 2;
        }else{
            x=train.rail.view.x;
            y=train.rail.view.y;
        }

        
        graphics.beginFill(train.color);
        graphics.drawCircle(0,0,8);
        graphics.endFill();


        var passengers:Vector.<Passenger> = train.passengers;
        for (var i:int = 0; i < passengers.length; i++) {
            if (TrafficNetwork.instance.view.contains(passengers[i].view)) {
                TrafficNetwork.instance.view.removeChild(passengers[i].view);
            }
        }

        
    }
}
}
