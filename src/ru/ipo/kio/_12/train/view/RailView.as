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
import ru.ipo.kio._12.train.model.Train;
import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.model.types.StationType;
import ru.ipo.kio._12.train.util.Pair;

public class RailView extends BasicView {

    private static const RAIL_LEHGTH:int = 18;

    private static const RAIL_LEHGTH_0:int = 24;

    [Embed(source='../_resources/Arrow_blue_0.png')]
    private static const BLUE_ARROW_0:Class;

    [Embed(source='../_resources/Arrow_red_0.png')]
    private static const RED_ARROW_0:Class;

    [Embed(source='../_resources/Arrow_blue.png')]
    private static const BLUE_ARROW:Class;

    [Embed(source='../_resources/Arrow_red.png')]
    private static const RED_ARROW:Class;

    [Embed(source='../_resources/Arrow_green.png')]
    private static const GREEN_ARROW:Class;

    [Embed(source='../_resources/Arrow_yellow.png')]
    private static const YELLOW_ARROW:Class;

    private var _rail:Rail;

    private var holst:Sprite = new Sprite();

    protected var placer:RailViewPlaceHelper;

    public function RailView(rail:Rail) {
        this._rail = rail;
        placer = new RailViewPlaceHelper(this);
        placer.placeRail();
        placer.addPictureAndHolst(holst);

        update();

        if (TrafficNetwork.instance.level != 2) {
            addRailActivationHandler(rail);
        }
    }

    private function addRailActivationHandler(rail:Rail):void {
        addEventListener(MouseEvent.MOUSE_OVER, function (event:Event):void {
            if (TrafficNetwork.instance.isPossibleAdd(rail)) {
                rail.active = true
            }
        });
        addEventListener(MouseEvent.MOUSE_OUT, function (event:Event):void {
            rail.active = false
        });

        addEventListener(MouseEvent.CLICK, function (event:Event):void {
            if (rail.active) {
                TrafficNetwork.instance.addToActiveRoute(rail);
                rail.active = false;
            } else{
//                if(TrafficNetwork.instance.activeTrain!=null && rail.getPassengers().length<4){
//                    rail.addPassenger(new Passenger(TrafficNetwork.instance.activeTrain.destination));
//                    TrafficNetwork.instance.view.update();
//                }
            }
        });
    }


    public function addSelector():void {

        if (TrafficNetwork.instance.level == 2) {
            return;
        }

        var selector:Sprite = new Sprite();
        selector.graphics.beginFill(0xff0000, 0);
        if (TrafficNetwork.instance.level == 1) {
            selector.graphics.drawCircle(0, 0, 30);
        } else if (TrafficNetwork.instance.level == 0) {
            selector.graphics.drawCircle(0, 0, 40);
        }
        selector.graphics.endFill();
        var addSelector:Boolean = false;
        var trainType:StationType;

        if (_rail.type == RailType.ROUND_TOP_LEFT) {
            addSelector = true;
            trainType = StationType.FIRST;
        } else if (_rail.type == RailType.ROUND_TOP_RIGHT) {
            addSelector = true;
            if (TrafficNetwork.instance.level == 1) {
                trainType = StationType.SECOND;
            } else if (TrafficNetwork.instance.level == 0) {
                trainType = StationType.FIRST;
            }
        } else if (_rail.type == RailType.ROUND_BOTTOM_LEFT) {
            addSelector = true;
            if (TrafficNetwork.instance.level == 1) {
                trainType = StationType.FOURTH
            } else if (TrafficNetwork.instance.level == 0) {
                trainType = StationType.THIRD;
            }
        } else if (_rail.type == RailType.ROUND_BOTTOM_RIGHT) {
            addSelector = true;
            trainType = StationType.THIRD;
        }


        selector.x = x + width / 2;
        selector.y = y + height / 2;
        if (addSelector) {
            TrafficNetwork.instance.view.addChild(selector);
        }

        selector.addEventListener(MouseEvent.CLICK, function (event:Event):void {
            var train:Train = TrafficNetwork.instance.getTrainByType(trainType);
            if (TrafficNetwork.instance.activeTrain == train) {
                TrafficNetwork.instance.activeTrain = null;
            } else {
                TrafficNetwork.instance.activeTrain = train;
            }
        });
    }

    public override function update():void {
        graphics.clear();
        holst.graphics.clear();
        while(holst.numChildren>0){
            holst.removeChildAt(0);
        }
        var length:int = _rail.trafficNetwork.railLength;
        var space:int = _rail.trafficNetwork.railSpace;
        var width:int = _rail.trafficNetwork.railWidth;


        if (_rail.active) {
            var glow_white:GlowFilter = new GlowFilter(TrafficNetwork.instance.activeTrain.color, 1, 5, 5, 10, 3);
            filters = new Array(glow_white);
        } else {
            filters = new Array();
        }

        var counts:Vector.<Pair> = TrafficNetwork.instance.getRouteColor(_rail);
        for (var i:int = 0; i < counts.length; i++) {
            var trainColor:int = counts[i].train.color;
            if (counts[i].count1 > 0 || counts[i].count2 > 0) {
                drawRail(i, TrafficNetwork.instance.activeTrain == counts[i].train ? 0xffffff : trainColor,
                        counts[i].count1, counts[i].count2, length, space,
                        TrafficNetwork.instance.activeTrain == counts[i].train);
            }
        }

        updatePassengers(_rail.getPassengers(), length, space);
    }

    private function drawRail(index:int, color:int, count1:int, count2:int, length:int, space:int, active:Boolean = false):void {
        if (TrafficNetwork.instance.level == 1 || TrafficNetwork.instance.level == 2) {
            drawFirstLevel(color, count1, count2, index, active);
        } else if (TrafficNetwork.instance.level == 0) {
            drawZeroLevel(color, count1, count2, index, active);
        }
    }

    private function drawFirstLevel(color:int,  count1:int, count2:int, index:int, active:Boolean):void {
        var alpha=1;
        graphics.lineStyle(1, color, alpha);
        if (_rail.type == RailType.HORIZONTAL) {
            holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
            holst.graphics.moveTo(0, 3 + index * 4);
            holst.graphics.lineTo(width, 3 + index * 4);

            for(var i:int = 0; i<Math.min(count1, 5); i++){
                var ar = getArrowByIndexForFirst(index);
                ar.rotation = 180;
                ar.y = 6+index*4;
                ar.x = 8 +i*3;
                holst.addChild(ar);
            }

            for(var i:int = 0; i<Math.min(count2, 5); i++){
                var ar = getArrowByIndexForFirst(index);
                ar.y = index*4;
                ar.x = width-12-i*3;
                holst.addChild(ar);
            }

        } else if (_rail.type == RailType.VERTICAL) {
            holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
            holst.graphics.moveTo(3 + index * 4, 0);
            holst.graphics.lineTo(3 + index * 4, height);


            for(var i:int = 0; i<Math.min(count1, 5); i++){
                var ar = getArrowByIndexForFirst(index);
                ar.rotation = -90;
                ar.x = index*4;
                ar.y = 8 +i*3;
                holst.addChild(ar);
            }

            for(var i:int = 0; i<Math.min(count2, 5); i++){
                var ar = getArrowByIndexForFirst(index);
                ar.rotation = 90;
                ar.x = 6+index*4;
                ar.y = height-12-i*3;
                holst.addChild(ar);
            }

        } else {
            if (_rail.type == RailType.SEMI_ROUND_TOP) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width / 2 - 12, height - 2, 44 - index * 4, -90 / 360, 180 / 360, 20);

                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = 90;
                    ar.y = height-10-3*i;
                    ar.x = 6+index*4;
                    holst.addChild(ar);
                }

                for(var i:int = 0; i<Math.min(count2, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = 90;
                    ar.y = height-10-3*i;
                    ar.x = width-25-index*4;
                    holst.addChild(ar);
                }

            } else if (_rail.type == RailType.SEMI_ROUND_BOTTOM) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width / 2 - 12, 0, 44 - index * 4, 90 / 360, 180 / 360, 20);

                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = -90;
                    ar.y = 10+3*i;
                    ar.x = index*4;
                    holst.addChild(ar);
                }

                for(var i:int = 0; i<Math.min(count2, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = -90;
                    ar.y = 10+3*i;
                    ar.x = width-30-index*4;
                    holst.addChild(ar);
                }

            } else if (_rail.type == RailType.SEMI_ROUND_LEFT) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width, height / 2 - 12, 44 - index * 4, 180 / 360, 180 / 360, 20);

                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = 0;
                    ar.y = index*4;
                    ar.x = width-10-3*i;
                    holst.addChild(ar);
                }

                for(var i:int = 0; i<Math.min(count2, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = 0;
                    ar.y = height-30-index*4;
                    ar.x = width-10-3*i;
                    holst.addChild(ar);
                }

            } else if (_rail.type == RailType.SEMI_ROUND_RIGHT) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, 0, height / 2 - 12, 44 - index * 4, 0, 180 / 360, 20);

                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = 180;
                    ar.y = 6+index*4;
                    ar.x = 10+3*i;
                    holst.addChild(ar);
                }

                for(var i:int = 0; i<Math.min(count2, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = 180;
                    ar.y = height-25-index*4;
                    ar.x = 10+3*i;
                    holst.addChild(ar);
                }

            } else if (_rail.type == RailType.ROUND_TOP_LEFT) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width / 2, height / 2, 44 - index * 4, -180 / 360, 0.75, 40);
                holst.graphics.moveTo(width / 2 + 44 - index * 4, height / 2);
                holst.graphics.lineTo(width / 2 + 44 - index * 4, height / 2 + RAIL_LEHGTH);
                holst.graphics.moveTo(width / 2, height / 2 + 44 - index * 4);
                holst.graphics.lineTo(width / 2 + RAIL_LEHGTH, height / 2 + 44 - index * 4);

                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = 0;
                    ar.y = height-6-index*4;
                    ar.x = width-40-3*i;
                    holst.addChild(ar);
                }

            } else if (_rail.type == RailType.ROUND_TOP_RIGHT) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width / 2, height / 2, 44 - index * 4, -90 / 360, 0.75, 40);
                holst.graphics.moveTo(width / 2 - 44 + index * 4, height / 2);
                holst.graphics.lineTo(width / 2 - 44 + index * 4, height / 2 + RAIL_LEHGTH);
                holst.graphics.moveTo(width / 2 - RAIL_LEHGTH, height / 2 + 44 - index * 4);
                holst.graphics.lineTo(width / 2, height / 2 + 44 - index * 4);

                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = 90;
                    ar.y = height-40-i*3;
                    ar.x = 6+index*4;
                    holst.addChild(ar);
                }

            } else if (_rail.type == RailType.ROUND_BOTTOM_LEFT) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width / 2, height / 2, 44 - index * 4, 90 / 360, 0.75, 40);
                holst.graphics.moveTo(width / 2, height / 2 - 44 + index * 4);
                holst.graphics.lineTo(width / 2 + RAIL_LEHGTH, height / 2 - 44 + index * 4);
                holst.graphics.moveTo(width / 2 + 44 - index * 4, height / 2);
                holst.graphics.lineTo(width / 2 + 44 - index * 4, height / 2 - RAIL_LEHGTH);

                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = 0;
                    ar.y = index*4;
                    ar.x = width-40-3*i;
                    holst.addChild(ar);
                }

            } else if (_rail.type == RailType.ROUND_BOTTOM_RIGHT) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width / 2, height / 2, 44 - index * 4, 0 / 360, 0.75, 40);
                holst.graphics.moveTo(width / 2, height / 2 - 44 + index * 4);
                holst.graphics.lineTo(width / 2 - RAIL_LEHGTH, height / 2 - 44 + index * 4);
                holst.graphics.moveTo(width / 2 - 44 + index * 4, height / 2);
                holst.graphics.lineTo(width / 2 - 44 + index * 4, height / 2 - RAIL_LEHGTH);

                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForFirst(index);
                    ar.rotation = -90;
                    ar.y = 40+3*i;
                    ar.x = index*4;
                    holst.addChild(ar);
                }

            }
        }
    }

    private function drawZeroLevel(color:int,  count1:int, count2:int, index:int, active:Boolean):void {
        var alpha=1;
        graphics.lineStyle(1, color, alpha);
        if (_rail.type == RailType.HORIZONTAL) {
            holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
            holst.graphics.moveTo(0, 1 + index * 4);
            holst.graphics.lineTo(width, 1 + index * 4);
            
            for(var i:int = 0; i<Math.min(count1, 5); i++){
                var ar = getArrowByIndexForZero(index);
                ar.rotation = 180;
                if(index ==1){
                    ar.y = 10;
                    ar.x = 8 +i*5;
                }else{
                    ar.y = 6;
                    ar.x = 20 +i*5;
                }
                holst.addChild(ar);
            }

            for(var i:int = 0; i<Math.min(count2, 5); i++){
                var ar = getArrowByIndexForZero(index);
                if(index ==1){
                    ar.y = 2;
                    ar.x = width - 10 - i*5;
                }else{
                    ar.y = -2;
                    ar.x = width - 22 - i*5;
                }
                holst.addChild(ar);
            }

        } else if (_rail.type == RailType.VERTICAL) {
            holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
            holst.graphics.moveTo(1 + index * 4, 0);
            holst.graphics.lineTo(1 + index * 4, height);

            for(var i:int = 0; i<Math.min(count1, 5); i++){
                var ar = getArrowByIndexForZero(index);
                ar.rotation = -90;
                if(index ==1){
                    ar.y = 8 +i*5;
                    ar.x = 2
                }else{
                    ar.y = 20 +i*5;
                    ar.x = -2;
                }
                holst.addChild(ar);
            }

            for(var i:int = 0; i<Math.min(count2, 5); i++){
                var ar = getArrowByIndexForZero(index);
                ar.rotation = 90;
                if(index ==1){
                    ar.y = width - 4 - i*5;
                    ar.x = 8;
                }else{
                    ar.y = width - 16 - i*5;
                    ar.x = 4;
                }
                holst.addChild(ar);
            }

        } else {
            var shiftX:int = 22;
            var shiftY:int = 58;

            if (_rail.type == RailType.SEMI_ROUND_TOP) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width / 2 - shiftX, height - 2, 58 - index * 4, -90 / 360, 180 / 360, 20);


                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForZero(index);
                    ar.rotation = 90;
                    if(index ==1){
                        ar.y = height-20-i*5;
                        ar.x = 8;
                    }else{
                        ar.y = height-30-i*5;
                        ar.x = 6;
                    }
                    holst.addChild(ar);
                }

                for(var i:int = 0; i<Math.min(count2, 5); i++){
                    var ar = getArrowByIndexForZero(index);
                    ar.rotation = 90;
                    if(index ==1){
                        ar.y = height-20-i*5;
                        ar.x = width-45;
                    }else{
                        ar.y = height-30-i*5;
                        ar.x = width-43;;
                    }
                    holst.addChild(ar);
                }

            } else if (_rail.type == RailType.SEMI_ROUND_BOTTOM) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width / 2 - shiftX, 2, shiftY - index * 4, 90 / 360, 180 / 360, 20);

                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForZero(index);
                    ar.rotation = -90;
                    if(index ==1){
                        ar.y = 15+i*5;
                        ar.x = 4;
                    }else{
                        ar.y = 25+i*5;
                        ar.x = 2;
                    }
                    holst.addChild(ar);
                }

                for(var i:int = 0; i<Math.min(count2, 5); i++){
                    var ar = getArrowByIndexForZero(index);
                    ar.rotation = -90;
                    if(index ==1){
                        ar.y = 15+i*5;
                        ar.x = width-50;
                    }else{
                        ar.y = 25+i*5;
                        ar.x = width-48;;
                    }
                    holst.addChild(ar);
                }
            } else if (_rail.type == RailType.SEMI_ROUND_LEFT) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width-2, height / 2 - 22, shiftY - index * 4, 180 / 360, 180 / 360, 20);


                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForZero(index);
                    ar.rotation = 0;
                    if(index ==1){
                        ar.y = 3;
                        ar.x = width-20-i*5;
                    }else{
                        ar.y = 1;
                        ar.x = width-30-i*5;
                    }
                    holst.addChild(ar);
                }

                for(var i:int = 0; i<Math.min(count2, 5); i++){
                    var ar = getArrowByIndexForZero(index);
                    ar.rotation = 0;
                    if(index ==1){
                        ar.y = height-50;
                        ar.x = width-20-i*5;
                    }else{
                        ar.y = height-48;
                        ar.x = width-30-i*5;
                    }
                    holst.addChild(ar);
                }


            } else if (_rail.type == RailType.SEMI_ROUND_RIGHT) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, 2, height / 2 - 22, shiftY - index * 4, 0, 180 / 360, 20);


                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForZero(index);
                    ar.rotation = 180;
                    if(index ==1){
                        ar.y = 7;
                        ar.x = 10+i*5;
                    }else{
                        ar.y = 5;
                        ar.x = 20+i*5;
                    }
                    holst.addChild(ar);
                }

                for(var i:int = 0; i<Math.min(count2, 5); i++){
                    var ar = getArrowByIndexForZero(index);
                    ar.rotation = 180;
                    if(index ==1){
                        ar.y = height-45;
                        ar.x = 10+i*5;
                    }else{
                        ar.y = height-43;
                        ar.x = 20+i*5;
                    }
                    holst.addChild(ar);
                }

            } else if (_rail.type == RailType.ROUND_TOP_RIGHT) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width / 2-2, height / 2+2, shiftY-2 - index * 4, -90 / 360, 0.75, 40);
                holst.graphics.moveTo(width / 2 - shiftY + index * 4, height / 2);
                holst.graphics.lineTo(width / 2 - shiftY + index * 4, height / 2 + RAIL_LEHGTH_0);
                holst.graphics.moveTo(width / 2 - RAIL_LEHGTH_0, height / 2 + shiftY - index * 4);
                holst.graphics.lineTo(width / 2, height / 2 + shiftY - index * 4);




                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForZero(index);
                    ar.rotation = 90;
                    if(index ==1){
                        ar.y = height-50-i*5;
                        ar.x = 18;
                    }else{
                        ar.y = height-60-i*5;
                        ar.x = 15;
                    }
                    holst.addChild(ar);
                }


            } else if (_rail.type == RailType.ROUND_BOTTOM_LEFT) {
                holst.graphics.lineStyle(active ? 3 : 2, color, alpha);
                drawArc(holst, width / 2+2, height / 2-2, shiftY-2 - index * 4, 90 / 360, 0.75, 40);
                holst.graphics.moveTo(width / 2, height / 2 - shiftY + index * 4);
                holst.graphics.lineTo(width / 2 + RAIL_LEHGTH_0, height / 2 - shiftY + index * 4);
                holst.graphics.moveTo(width / 2 + shiftY - index * 4, height / 2);
                holst.graphics.lineTo(width / 2 + shiftY - index * 4, height / 2 - RAIL_LEHGTH_0);

                for(var i:int = 0; i<Math.min(count1, 5); i++){
                    var ar = getArrowByIndexForZero(index);
                    ar.rotation = 0;
                    if(index ==1){
                        ar.y = 13;
                        ar.x = width-40-i*5;
                    }else{
                        ar.y = 10;
                        ar.x = width-50-i*5;
                    }
                    holst.addChild(ar);
                }
            }
        }
    }

    private function getArrowByIndexForZero(index:int):* {
        if(index == 1)
            return new BLUE_ARROW_0;
        else
            return new RED_ARROW_0;
    }

    private function getArrowByIndexForFirst(index:int):* {
        if(index == 1)
            return new RED_ARROW;
        else if (index == 2)
            return new BLUE_ARROW;
        else if (index == 3)
            return new YELLOW_ARROW;
        else
            return new GREEN_ARROW;
    }

    function drawArc(sprite:Sprite, centerX, centerY, radius, startAngle, arcAngle, steps):void {
        //
        // Rotate the point of 0 rotation 1/4 turn counter-clockwise.
        startAngle -= .25;
        //
        var twoPI = 2 * Math.PI;
        var angleStep = arcAngle / steps;
        var xx = centerX + Math.cos(startAngle * twoPI) * radius;
        var yy = centerY + Math.sin(startAngle * twoPI) * radius;
        sprite.graphics.moveTo(xx, yy);
        for (var i = 1; i <= steps; i++) {
            var angle = startAngle + i * angleStep;
            xx = centerX + Math.cos(angle * twoPI) * radius;
            yy = centerY + Math.sin(angle * twoPI) * radius;
            sprite.graphics.lineTo(xx, yy);
        }
    }


    protected function updatePassengers(passengers:Vector.<Passenger>, length:int, space:int):void {
        for (var i:int = 0; i < passengers.length; i++) {
            if (_rail.trafficNetwork.view.contains(passengers[i].view)) {
                _rail.trafficNetwork.view.removeChild(passengers[i].view);
            }
        }

        var passengerSize:int = TrafficNetwork.instance.passengerSize;
        var passengerSpace:int = TrafficNetwork.instance.passengerSpace;

        for (var i:int = 0; i < passengers.length; i++) {
            _rail.trafficNetwork.view.addChild(passengers[i].view);
            if (TrafficNetwork.instance.level == 1 || TrafficNetwork.instance.level == 2) {
                updateForFirst(passengers, i, length, passengerSize, space, passengerSpace);
            } else if (TrafficNetwork.instance.level == 0) {
                updateForZero(passengers, i, length, passengerSize, space, passengerSpace);
            }

        }
    }


    private function updateForZero(passengers:Vector.<Passenger>, i:int, length:int, passengerSize:int, space:int, passengerSpace:int):void {
        if (_rail.type == RailType.HORIZONTAL) {
            passengers[i].view.x = i % 2 == 1 ? _rail.view.x + length / 2 - passengerSize * 2 : _rail.view.x + length / 2 + passengerSize;
            passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? _rail.view.y + passengerSize * 4 : _rail.view.y + passengerSize * 10;
        }
        if (_rail.type == RailType.VERTICAL) {
            passengers[i].view.x = (i % 4 == 1 || i % 4 == 2) ? _rail.view.x + passengerSize * 4 : _rail.view.x + passengerSize * 10;
            passengers[i].view.y = i % 2 == 1 ? _rail.view.y + length / 2 - passengerSize * 2 : _rail.view.y + length / 2 + passengerSize;
        }
        if (_rail.type == RailType.SEMI_ROUND_BOTTOM) {
            passengers[i].view.x = i % 2 == 1 ? space + _rail.view.x + length / 2 + passengerSize * 5 : space + _rail.view.x + length / 2 + passengerSize * 8;
            passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? _rail.view.y + length / 2 + passengerSize * 4 : _rail.view.y + length / 2 + passengerSize * 13;
        }
        if (_rail.type == RailType.SEMI_ROUND_TOP) {
            passengers[i].view.x = i % 2 == 1 ? space + _rail.view.x + length / 2 + passengerSize * 5 : space + _rail.view.x + length / 2 + passengerSize * 8;
            passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? _rail.view.y + length / 2 - passengerSize * 14 : _rail.view.y + length / 2 - passengerSize * 4;
        }
        if (_rail.type == RailType.SEMI_ROUND_LEFT) {
            passengers[i].view.x = (i % 4 == 1 || i % 4 == 2) ? _rail.view.x + length / 2 - passengerSize * 13 : _rail.view.x + length / 2 - passengerSpace * 5;
            passengers[i].view.y = i % 2 == 1 ? _rail.view.y + space + length / 2 + passengerSize * 8 : _rail.view.y + space + length / 2 + passengerSize * 5;
        }
        if (_rail.type == RailType.SEMI_ROUND_RIGHT) {
            passengers[i].view.x = (i % 4 == 1 || i % 4 == 2) ? _rail.view.x + length / 2 + passengerSize * 4 : _rail.view.x + length / 2 + passengerSize * 13;
            passengers[i].view.y = i % 2 == 1 ? _rail.view.y + space + length / 2 + passengerSize * 8 : _rail.view.y + space + length / 2 + passengerSize * 5;
        }
    }

    private function updateForFirst(passengers:Vector.<Passenger>, i:int, length:int, passengerSize:int, space:int, passengerSpace:int):void {
        if (_rail.type == RailType.HORIZONTAL) {
            passengers[i].view.x = i % 2 == 1 ? _rail.view.x + length / 2 - passengerSize * 2 : _rail.view.x + length / 2 + passengerSize;
            passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? _rail.view.y + passengerSize : _rail.view.y + passengerSize * 10;
        }
        if (_rail.type == RailType.VERTICAL) {
            passengers[i].view.x = (i % 4 == 1 || i % 4 == 2) ? _rail.view.x + passengerSize : _rail.view.x + passengerSize * 10;
            passengers[i].view.y = i % 2 == 1 ? _rail.view.y + length / 2 - passengerSize * 2 : _rail.view.y + length / 2 + passengerSize;
        }
        if (_rail.type == RailType.SEMI_ROUND_BOTTOM) {
            passengers[i].view.x = i % 2 == 1 ? space + _rail.view.x + length / 2 + passengerSize * 5 : space + _rail.view.x + length / 2 + passengerSize * 8;
            passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? _rail.view.y + length / 2 - passengerSize : _rail.view.y + length / 2 + passengerSize * 10;
        }
        if (_rail.type == RailType.SEMI_ROUND_TOP) {
            passengers[i].view.x = i % 2 == 1 ? space + _rail.view.x + length / 2 + passengerSize * 5 : space + _rail.view.x + length / 2 + passengerSize * 8;
            passengers[i].view.y = (i % 4 == 1 || i % 4 == 2) ? _rail.view.y + length / 2 - passengerSize * 10 : _rail.view.y + length / 2 + passengerSize * 2;
        }
        if (_rail.type == RailType.SEMI_ROUND_LEFT) {
            passengers[i].view.x = (i % 4 == 1 || i % 4 == 2) ? _rail.view.x + length / 2 - passengerSize * 9 : _rail.view.x + length / 2 + passengerSpace;
            passengers[i].view.y = i % 2 == 1 ? _rail.view.y + space + length / 2 + passengerSize * 8 : _rail.view.y + space + length / 2 + passengerSize * 5;
        }
        if (_rail.type == RailType.SEMI_ROUND_RIGHT) {
            passengers[i].view.x = (i % 4 == 1 || i % 4 == 2) ? _rail.view.x + length / 2 : _rail.view.x + length / 2 + passengerSize * 10;
            passengers[i].view.y = i % 2 == 1 ? _rail.view.y + space + length / 2 + passengerSize * 8 : _rail.view.y + space + length / 2 + passengerSize * 5;
        }
    }


    public function get rail():Rail {
        return _rail;
    }
}
}
