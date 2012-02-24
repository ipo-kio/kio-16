/**
 *
 * @author: Vasily Akimushkin
 * @since: 30.01.12
 */
package ru.ipo.kio._12.train.view {
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;

import ru.ipo.kio._12.train.model.Passenger;

import ru.ipo.kio._12.train.model.Rail;
import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.util.Pair;

public class RailView extends BasicView {

    [Embed(source='../_resources/Line_horizontal.png')]
    private static const LEVEL_1_HORIZONTAL:Class;

    [Embed(source='../_resources/Line_vertical.png')]
    private static const LEVEL_1_VERTICAL:Class;

    [Embed(source='../_resources/Sector_left.png')]
    private static const LEVEL_1_SEMI_LEFT:Class;

    [Embed(source='../_resources/Sector_right.png')]
    private static const LEVEL_1_SEMI_RIGHT:Class;

    [Embed(source='../_resources/Sector_bottom.png')]
    private static const LEVEL_1_SEMI_BOTTOM:Class;

    [Embed(source='../_resources/Sector_top.png')]
    private static const LEVEL_1_SEMI_TOP:Class;

    [Embed(source='../_resources/Loop_top_left.png')]
    private static const LEVEL_1_TOP_LEFT:Class;

    [Embed(source='../_resources/Loop_top_right.png')]
    private static const LEVEL_1_TOP_RIGHT:Class;

    [Embed(source='../_resources/Loop_bottom_left.png')]
    private static const LEVEL_1_BOTTOM_LEFT:Class;

    [Embed(source='../_resources/Loop_bottom_right.png')]
    private static const LEVEL_1_BOTTOM_RIGHT:Class;

    private static const RAIL_LEHGTH:int = 18;


    protected var rail:Rail;
    
    private var holst:Sprite = new Sprite();
    
    public function RailView(rail:Rail) {
        this.rail=rail;
        if(TrafficNetwork.instance.level==1){
            placeFirstLevel(rail);
        }
        update();

        addEventListener(MouseEvent.MOUSE_OVER, function(event:Event):void{
           if(TrafficNetwork.instance.isPossibleAdd(rail)){
                rail.active=true
           }
        });
        addEventListener(MouseEvent.MOUSE_OUT, function(event:Event):void{
            rail.active=false
         });

        addEventListener(MouseEvent.CLICK, function(event:Event):void{
            if(rail.active){
                TrafficNetwork.instance.addToActiveRoute(rail);
                rail.active=false;
            }
        });
    }

    protected function placeFirstLevel(rail:Rail):void {
        if (rail.type == RailType.HORIZONTAL) {
            x = rail.firstEnd.point.x;
            y = rail.firstEnd.point.y - rail.trafficNetwork.railSpace;
            var line = new LEVEL_1_HORIZONTAL;
            holst.y=12;
        } else if (rail.type == RailType.VERTICAL) {
            x = rail.firstEnd.point.x - rail.trafficNetwork.railSpace;
            y = rail.firstEnd.point.y;
            var line = new LEVEL_1_VERTICAL;
            holst.x=12;
        } else if (rail.type == RailType.SEMI_ROUND_TOP) {
            x = rail.firstEnd.point.x - rail.trafficNetwork.railSpace;
            y = rail.firstEnd.point.y - rail.trafficNetwork.railSpace*2;
            var line = new LEVEL_1_SEMI_TOP;
            holst.x=12;
        } else if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
            x = rail.firstEnd.point.x - rail.trafficNetwork.railSpace;
            y = rail.firstEnd.point.y;
            var line = new LEVEL_1_SEMI_BOTTOM;
            holst.x=12;
        } else if (rail.type == RailType.SEMI_ROUND_LEFT) {
            x = rail.firstEnd.point.x-rail.trafficNetwork.railSpace*2;
            y = rail.firstEnd.point.y-rail.trafficNetwork.railSpace;
            var line = new LEVEL_1_SEMI_LEFT;
            holst.y=12;
        } else if (rail.type == RailType.SEMI_ROUND_RIGHT) {
            x = rail.firstEnd.point.x;
            y = rail.firstEnd.point.y-rail.trafficNetwork.railSpace;
            var line = new LEVEL_1_SEMI_RIGHT;
            holst.y=12;
        } else if (rail.type == RailType.ROUND_TOP_LEFT) {
            x = rail.firstEnd.point.x - 63;
            y = rail.secondEnd.point.y - 63;
            var line = new LEVEL_1_TOP_LEFT;
        } else if (rail.type == RailType.ROUND_TOP_RIGHT) {
            x = rail.secondEnd.point.x - 30;
            y = rail.firstEnd.point.y - 63;
            var line = new LEVEL_1_TOP_RIGHT;
        } else if (rail.type == RailType.ROUND_BOTTOM_LEFT) {
            x = rail.secondEnd.point.x - 63;
            y = rail.firstEnd.point.y - 30;
            var line = new LEVEL_1_BOTTOM_LEFT;
        }  else if (rail.type == RailType.ROUND_BOTTOM_RIGHT) {
            x = rail.firstEnd.point.x - 30;
            y = rail.secondEnd.point.y - 30;
            var line = new LEVEL_1_BOTTOM_RIGHT;
        }
        addChild(line);
        addChild(holst);
    }

     public override function update():void{
         graphics.clear();
         holst.graphics.clear();
         var length:int = rail.trafficNetwork.railLength;
         var space:int = rail.trafficNetwork.railSpace;
         var width:int = rail.trafficNetwork.railWidth;
         

         if(rail.active){
             var glow_white:GlowFilter = new GlowFilter(0xFF0000, 1, 5, 5, 10, 3);
             filters = new Array(glow_white);
         }else{
             filters = new Array();
         }

         var counts:Vector.<Pair> = TrafficNetwork.instance.getRouteColor(rail);
         for(var i:int = 0; i<counts.length; i++){
             var trainColor:int = counts[i].train.color;
             if(counts[i].count>0){
             drawRail(i, TrafficNetwork.instance.activeTrain == counts[i].train ? 0xffffff:trainColor,
                     TrafficNetwork.instance.activeTrain == counts[i].train ? 1:counts[i].count, length, space,
                     TrafficNetwork.instance.activeTrain == counts[i].train);
             }
         }

         updatePassengers(length, width, space);
     }

    private function drawRail(index:int, color:int, alpha:Number, length:int, space:int, active:Boolean=false):void {
        graphics.lineStyle(1, color, alpha);
        if (rail.type == RailType.HORIZONTAL) {
            holst.graphics.lineStyle(2,0x000000,0.5);
            holst.graphics.moveTo(0,5+index*4);
            holst.graphics.lineTo(width,5+index*4);

            holst.graphics.lineStyle(active?3:2,color,alpha);
            holst.graphics.moveTo(0,3+index*4);
            holst.graphics.lineTo(width,3+index*4);
        } else if (rail.type == RailType.VERTICAL) {
            holst.graphics.lineStyle(2,0x000000,0.5);
            holst.graphics.moveTo(5+index*4, 0);
            holst.graphics.lineTo(5+index*4,height);

            holst.graphics.lineStyle(active?3:2,color,alpha);
            holst.graphics.moveTo(3+index*4, 0);
            holst.graphics.lineTo(3+index*4,height);
        } else {
            if (rail.type == RailType.SEMI_ROUND_TOP) {
                holst.graphics.lineStyle(2,0x000000,0.5);
                drawArc(holst, width/2-12, height-2, 42-index*4, -90/360, 180/360, 20);
                holst.graphics.lineStyle(active?3:2,color,alpha);
                drawArc(holst, width/2-12, height-2, 44-index*4, -90/360, 180/360, 20);
            } else if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
                holst.graphics.lineStyle(2,0x000000,0.5);
                drawArc(holst, width/2-12, 0, 42-index*4, 90/360, 180/360, 20);
                holst.graphics.lineStyle(active?3:2,color,alpha);
                drawArc(holst, width/2-12, 0, 44-index*4, 90/360, 180/360, 20);
            } else if (rail.type == RailType.SEMI_ROUND_LEFT) {
                holst.graphics.lineStyle(2,0x000000,0.5);
                drawArc(holst, width, height/2-12, 42-index*4, 180/360, 180/360, 20);
                holst.graphics.lineStyle(active?3:2,color,alpha);
                drawArc(holst, width, height/2-12, 44-index*4, 180/360, 180/360, 20);
            } else if (rail.type == RailType.SEMI_ROUND_RIGHT) {
                holst.graphics.lineStyle(2,0x000000,0.5);
                drawArc(holst, 0, height/2-12, 42-index*4, 0, 180/360, 20);
                holst.graphics.lineStyle(active?3:2,color,alpha);
                drawArc(holst, 0, height/2-12, 44-index*4, 0, 180/360, 20);
            } else if (rail.type == RailType.ROUND_TOP_LEFT) {
                holst.graphics.lineStyle(2,0x000000,0.5);
                drawArc(holst, width/2, height/2, 42-index*4, -180/360, 0.75, 40);
                holst.graphics.moveTo(width/2+42-index*4, height/2);
                holst.graphics.lineTo(width/2+42-index*4, height/2+RAIL_LEHGTH);
                holst.graphics.moveTo(width/2, height/2+42-index*4);
                holst.graphics.lineTo(width/2+RAIL_LEHGTH, height/2+42-index*4);

                holst.graphics.lineStyle(active?3:2,color,alpha);
                drawArc(holst, width/2, height/2, 44-index*4, -180/360, 0.75, 40);
                holst.graphics.moveTo(width/2+44-index*4, height/2);
                holst.graphics.lineTo(width/2+44-index*4, height/2+RAIL_LEHGTH);
                holst.graphics.moveTo(width/2, height/2+44-index*4);
                holst.graphics.lineTo(width/2+RAIL_LEHGTH, height/2+44-index*4);

            } else if (rail.type == RailType.ROUND_TOP_RIGHT) {
                holst.graphics.lineStyle(2,0x000000,0.5);
                drawArc(holst, width/2, height/2, 42-index*4, -90/360, 0.75, 40);
                holst.graphics.moveTo(width/2-42+index*4, height/2);
                holst.graphics.lineTo(width/2-42+index*4, height/2+RAIL_LEHGTH);
                holst.graphics.moveTo(width/2-RAIL_LEHGTH, height/2+42-index*4);
                holst.graphics.lineTo(width/2, height/2+42-index*4);

                holst.graphics.lineStyle(active?3:2,color,alpha);
                drawArc(holst, width/2, height/2, 44-index*4, -90/360, 0.75, 40);
                holst.graphics.moveTo(width/2-44+index*4, height/2);
                holst.graphics.lineTo(width/2-44+index*4, height/2+RAIL_LEHGTH);
                holst.graphics.moveTo(width/2-RAIL_LEHGTH, height/2+44-index*4);
                holst.graphics.lineTo(width/2, height/2+44-index*4);

            } else if (rail.type == RailType.ROUND_BOTTOM_LEFT) {
                holst.graphics.lineStyle(2,0x000000,0.5);
                drawArc(holst, width/2, height/2, 42-index*4, 90/360, 0.75, 40);
                holst.graphics.moveTo(width/2, height/2-42+index*4);
                holst.graphics.lineTo(width/2+RAIL_LEHGTH, height/2-42+index*4);
                holst.graphics.moveTo(width/2+42-index*4, height/2);
                holst.graphics.lineTo(width/2+42-index*4, height/2-RAIL_LEHGTH);

                holst.graphics.lineStyle(active?3:2,color,alpha);
                drawArc(holst, width/2, height/2, 44-index*4, 90/360, 0.75, 40);
                holst.graphics.moveTo(width/2, height/2-44+index*4);
                holst.graphics.lineTo(width/2+RAIL_LEHGTH, height/2-44+index*4);
                holst.graphics.moveTo(width/2+44-index*4, height/2);
                holst.graphics.lineTo(width/2+44-index*4, height/2-RAIL_LEHGTH);


            } else if (rail.type == RailType.ROUND_BOTTOM_RIGHT) {
                holst.graphics.lineStyle(2,0x000000,0.5);
                drawArc(holst, width/2, height/2, 42-index*4, 0/360, 0.75, 40);
                holst.graphics.moveTo(width/2, height/2-42+index*4);
                holst.graphics.lineTo(width/2-RAIL_LEHGTH, height/2-42+index*4);
                holst.graphics.moveTo(width/2-42+index*4, height/2);
                holst.graphics.lineTo(width/2-42+index*4, height/2-RAIL_LEHGTH);


                holst.graphics.lineStyle(active?3:2,color,alpha);
                drawArc(holst, width/2, height/2, 44-index*4, 0/360, 0.75, 40);
                holst.graphics.moveTo(width/2, height/2-44+index*4);
                holst.graphics.lineTo(width/2-RAIL_LEHGTH, height/2-44+index*4);
                holst.graphics.moveTo(width/2-44+index*4, height/2);
                holst.graphics.lineTo(width/2-44+index*4, height/2-RAIL_LEHGTH);

            }
        }
    }

    function drawArc(sprite:Sprite, centerX, centerY, radius, startAngle, arcAngle, steps):void{
        //
        // Rotate the point of 0 rotation 1/4 turn counter-clockwise.
        startAngle -= .25;
        //
        var twoPI = 2 * Math.PI;
        var angleStep = arcAngle/steps;
        var xx = centerX + Math.cos(startAngle * twoPI) * radius;
        var yy = centerY + Math.sin(startAngle * twoPI) * radius;
        sprite.graphics.moveTo(xx, yy);
        for(var i=1; i<=steps; i++){
            var angle = startAngle + i * angleStep;
            xx = centerX + Math.cos(angle * twoPI) * radius;
            yy = centerY + Math.sin(angle * twoPI) * radius;
            sprite.graphics.lineTo(xx, yy);
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
                passengers[i].view.x = i % 2 == 1 ? rail.view.x + length / 2 - passengerSize*2 : rail.view.x + length / 2 + passengerSize;
                passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? rail.view.y + passengerSize : rail.view.y + passengerSize * 10;
            }
            if (rail.type == RailType.VERTICAL) {
                passengers[i].view.x = (i % 4 == 1 || i % 4 == 2) ? rail.view.x + passengerSize : rail.view.x + passengerSize * 10;
                passengers[i].view.y = i % 2 == 1 ? rail.view.y + length / 2 - passengerSize*2 : rail.view.y + length / 2 + passengerSize;
            }
            if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
                passengers[i].view.x = i % 2 == 1 ? space + rail.view.x + length / 2 + passengerSize*5 : space + rail.view.x + length / 2 + passengerSize*8;
                passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? rail.view.y + length / 2 - passengerSize : rail.view.y + length / 2 + passengerSize * 10;
            }
            if (rail.type == RailType.SEMI_ROUND_TOP) {
                passengers[i].view.x = i % 2 == 1 ? space + rail.view.x + length / 2 + passengerSize*5 : space + rail.view.x + length / 2 + passengerSize*8;
                passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? rail.view.y + length / 2 - passengerSize*10 : rail.view.y + length / 2 + passengerSize * 2;
            }
            if (rail.type == RailType.SEMI_ROUND_LEFT) {
                passengers[i].view.x = (i % 4 == 1 || i % 4 == 2) ? rail.view.x + length / 2 - passengerSize*9 : rail.view.x + length / 2 +  passengerSpace;
                passengers[i].view.y = i % 2 == 1 ? rail.view.y + space + length / 2 + passengerSize*8 : rail.view.y + space + length / 2 +passengerSize*5;
            }
            if (rail.type == RailType.SEMI_ROUND_RIGHT) {
                passengers[i].view.x = (i % 4 == 1 || i % 4 == 2) ? rail.view.x + length / 2  : rail.view.x + length / 2 +  passengerSize * 10;
                passengers[i].view.y = i % 2 == 1 ? rail.view.y + space + length / 2 + passengerSize*8 : rail.view.y + space + length / 2 +passengerSize*5;
            }

        }
    }


}
}
