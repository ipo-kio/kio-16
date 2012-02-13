/**
 *
 * @author: Vasily Akimushkin
 * @since: 30.01.12
 */
package ru.ipo.kio._12.train.view {
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._12.train.model.Passenger;

import ru.ipo.kio._12.train.model.Rail;
import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.util.Pair;

public class RailView extends BasicView {
    
    protected var rail:Rail;
    
    public function RailView(rail:Rail) {
        this.rail=rail;
        place(rail);
        update();

        addEventListener(MouseEvent.MOUSE_OVER, function(event:Event):void{
//            var v:Vector.<Rail> = rail.getConnectedRails();
//            for(var i:int = 0; i<v.length; i++){
//                v[i].active=true;
//            }
            
           if(TrafficNetwork.instance.isPossibleAdd(rail)){
                rail.active=true
           }
        });
        addEventListener(MouseEvent.MOUSE_OUT, function(event:Event):void{
//        TrafficNetwork.instance.reset();
            rail.active=false
         });


        addEventListener(MouseEvent.CLICK, function(event:Event):void{
            if(rail.active){
                TrafficNetwork.instance.addToActiveRoute(rail);
                rail.active=false;
            }
        });
    }

    protected function place(rail:Rail):void {
        if (rail.type == RailType.HORIZONTAL) {
            x = rail.firstEnd.point.x;
            y = rail.firstEnd.point.y - rail.trafficNetwork.railWidth / 2;
        } else if (rail.type == RailType.VERTICAL) {
            x = rail.firstEnd.point.x - rail.trafficNetwork.railWidth / 2;
            y = rail.firstEnd.point.y;
        } else if (rail.type == RailType.SEMI_ROUND_TOP) {
            x = rail.firstEnd.point.x ;
            y = rail.firstEnd.point.y-rail.trafficNetwork.railLength;
        } else if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
            x = rail.firstEnd.point.x ;
            y = rail.firstEnd.point.y;
        } else if (rail.type == RailType.SEMI_ROUND_LEFT) {
            x = rail.firstEnd.point.x-rail.trafficNetwork.railLength;
            y = rail.firstEnd.point.y;
        } else if (rail.type == RailType.SEMI_ROUND_RIGHT) {
            x = rail.firstEnd.point.x ;
            y = rail.firstEnd.point.y;
        } else if (rail.type == RailType.ROUND_TOP_LEFT) {
            x = rail.firstEnd.point.x - rail.trafficNetwork.railLength/2;
            y = rail.secondEnd.point.y - rail.trafficNetwork.railLength/2;
        } else if (rail.type == RailType.ROUND_TOP_RIGHT) {
            x = rail.secondEnd.point.x;
            y = rail.firstEnd.point.y - rail.trafficNetwork.railLength/2;
        } else if (rail.type == RailType.ROUND_BOTTOM_LEFT) {
            x = rail.secondEnd.point.x - rail.trafficNetwork.railLength/2;
            y = rail.firstEnd.point.y;
        }  else if (rail.type == RailType.ROUND_BOTTOM_RIGHT) {
            x = rail.firstEnd.point.x;
            y = rail.secondEnd.point.y;
        }
    }

     public override function update():void{
         graphics.clear();
         var length:int = rail.trafficNetwork.railLength;
         var space:int = rail.trafficNetwork.railSpace;
         var width:int = rail.trafficNetwork.railWidth;
         
         var color:int = 0x000000;
         if(rail.active){
            color = 0xbb0000;
         }

         var counts:Vector.<Pair> = TrafficNetwork.instance.getRouteColor(rail);
         for(var i:int = 0; i<counts.length; i++){
             var trainColor:int = counts[i].train.color;
             drawRail(trainColor, TrafficNetwork.instance.activeTrain==counts[i].train?counts[i].count/2:counts[i].count/4, length, space);
         }

         drawRail(color, 0.2, length, space);
         updatePassengers(length, width, space);
     }

    private function drawRail(color:int, alpha:Number, length:int, space:int):void {
        graphics.lineStyle(1, color, alpha);
        if (rail.type == RailType.HORIZONTAL) {
            graphics.beginFill(color, alpha);
            graphics.drawRect(0, 0,
                    rail.secondEnd.point.x - rail.firstEnd.point.x,
                    rail.trafficNetwork.railWidth);
            graphics.endFill();
        } else if (rail.type == RailType.VERTICAL) {
            graphics.beginFill(color, alpha);
            graphics.drawRect(0, 0,
                    rail.trafficNetwork.railWidth,
                    rail.secondEnd.point.y - rail.firstEnd.point.y);
            graphics.endFill();
        } else {
            graphics.lineStyle(rail.trafficNetwork.railWidth, color, alpha);
            if (rail.type == RailType.SEMI_ROUND_TOP) {
                graphics.moveTo(0, length);
                graphics.curveTo(length / 2 + space, 0, length + space * 2, length);
            } else if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
                graphics.moveTo(0, 0);
                graphics.curveTo(length / 2 + space, length, length + space * 2, 0);
            } else if (rail.type == RailType.SEMI_ROUND_LEFT) {
                graphics.moveTo(length, 0);
                graphics.curveTo(0, length / 2 + space, length, length + space * 2);
            } else if (rail.type == RailType.SEMI_ROUND_RIGHT) {
                graphics.moveTo(0, 0);
                graphics.curveTo(length, length / 2 + space, 0, length + space * 2);
            } else if (rail.type == RailType.ROUND_TOP_LEFT) {
                graphics.moveTo(0, 0);
                graphics.curveTo(length / 2, -length / 4, length / 2 + space, length / 2);
                graphics.moveTo(0, 0);
                graphics.curveTo(-length / 4, length / 2, length / 2, length / 2 + space);
            } else if (rail.type == RailType.ROUND_TOP_RIGHT) {
                graphics.moveTo(length / 2, 0);
                graphics.curveTo(0, -length / 4, -space, length / 2);
                graphics.moveTo(length / 2, 0);
                graphics.curveTo(3 * length / 4, length / 2, 0, length / 2 + space);
            } else if (rail.type == RailType.ROUND_BOTTOM_LEFT) {
                graphics.moveTo(0, length / 2);
                graphics.curveTo(-length / 4, 0, length / 2, -space);
                graphics.moveTo(0, length / 2);
                graphics.curveTo(length / 2, 3 * length / 4, length / 2 + space, 0);
            } else if (rail.type == RailType.ROUND_BOTTOM_RIGHT) {
                graphics.moveTo(length / 2, length / 2);
                graphics.curveTo(3 * length / 4, 0, 0, -space);
                graphics.moveTo(length / 2, length / 2);
                graphics.curveTo(0, 3 * length / 4, -space, 0);
            }
        }
    }

    private function updatePassengers(length:int, width:int, space:int):void {
        var passengers:Vector.<Passenger> = rail.getPassengers();
        for (var i:int = 0; i < passengers.length; i++) {
            if (rail.trafficNetwork.view.contains(passengers[i].view)) {
                rail.trafficNetwork.view.removeChild(passengers[i].view);
            }
        }

        var passengerSize:int = TrafficNetwork.instance.passengerSize;
        var passengerSpace:int = TrafficNetwork.instance.passengerSpace;

        for (var i:int = 0; i < passengers.length; i++) {
            rail.trafficNetwork.view.addChild(passengers[i].view);
            if (rail.type == RailType.HORIZONTAL) {
                passengers[i].view.x = i % 2 == 1 ? rail.view.x + length / 2 - passengerSize : rail.view.x + length / 2 + passengerSize + passengerSpace;
                passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? rail.view.y - passengerSize - passengerSpace : rail.view.y + width + passengerSize * 3 + passengerSpace;
            }
            if (rail.type == RailType.VERTICAL) {
                passengers[i].view.x = (i % 4 == 1 || i % 4 == 2) ? rail.view.x - passengerSize - passengerSpace : rail.view.x + width + passengerSize * 3 + passengerSpace;
                passengers[i].view.y = i % 2 == 1 ? rail.view.y + length / 2 - passengerSize : rail.view.y + length / 2 + passengerSize + passengerSpace;
            }
            if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
                passengers[i].view.x = i % 2 == 1 ? space + rail.view.x + length / 2 - passengerSize : space + rail.view.x + length / 2 + passengerSize + passengerSpace;
                passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? rail.view.y + length / 2 - passengerSize - passengerSpace : rail.view.y + length / 2 + width + passengerSize * 3 + passengerSpace;
            }
            if (rail.type == RailType.SEMI_ROUND_TOP) {
                passengers[i].view.x = i % 2 == 1 ? space + rail.view.x + length / 2 - passengerSize : space + rail.view.x + length / 2 + passengerSize + passengerSpace;
                passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? rail.view.y + length / 2 - passengerSize - passengerSpace : rail.view.y + length / 2 + width + passengerSize * 3 + passengerSpace;
            }
            if (rail.type == RailType.SEMI_ROUND_LEFT || rail.type == RailType.SEMI_ROUND_RIGHT) {
                passengers[i].view.x = (i % 4 == 1 || i % 4 == 2) ? rail.view.x + length / 2 - passengerSize - passengerSpace : rail.view.x + length / 2 + width + passengerSize * 3 + passengerSpace;
                passengers[i].view.y = i % 2 == 1 ? rail.view.y + space + length / 2 - passengerSize : rail.view.y + space + length / 2 + passengerSize + passengerSpace;
            }

        }
    }
}
}
