/**
 *
 * @author: Vasily Akimushkin
 * @since: 26.02.12
 */
package ru.ipo.kio._12.train.view {
import flash.display.Sprite;

import ru.ipo.kio._12.train.model.Rail;
import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.types.RailType;

public class RailViewPlaceHelper {

    [Embed(source='../_resources/one/Line_horizontal.png')]
    private static const LEVEL_1_HORIZONTAL:Class;

    [Embed(source='../_resources/one/Line_vertical.png')]
    private static const LEVEL_1_VERTICAL:Class;

    [Embed(source='../_resources/one/Sector_left.png')]
    private static const LEVEL_1_SEMI_LEFT:Class;

    [Embed(source='../_resources/one/Sector_right.png')]
    private static const LEVEL_1_SEMI_RIGHT:Class;

    [Embed(source='../_resources/one/Sector_bottom.png')]
    private static const LEVEL_1_SEMI_BOTTOM:Class;

    [Embed(source='../_resources/one/Sector_top.png')]
    private static const LEVEL_1_SEMI_TOP:Class;

    [Embed(source='../_resources/one/Loop_top_left.png')]
    private static const LEVEL_1_TOP_LEFT:Class;

    [Embed(source='../_resources/one/Loop_top_right.png')]
    private static const LEVEL_1_TOP_RIGHT:Class;

    [Embed(source='../_resources/one/Loop_bottom_left.png')]
    private static const LEVEL_1_BOTTOM_LEFT:Class;

    [Embed(source='../_resources/one/Loop_bottom_right.png')]
    private static const LEVEL_1_BOTTOM_RIGHT:Class;

    [Embed(source='../_resources/zero/Line_horizontal.png')]
    private static const LEVEL_0_HORIZONTAL:Class;

    [Embed(source='../_resources/zero/Line_vertical.png')]
    private static const LEVEL_0_VERTICAL:Class;

    [Embed(source='../_resources/zero/Sector_left.png')]
    private static const LEVEL_0_SEMI_LEFT:Class;

    [Embed(source='../_resources/zero/Sector_right.png')]
    private static const LEVEL_0_SEMI_RIGHT:Class;

    [Embed(source='../_resources/zero/Sector_bottom.png')]
    private static const LEVEL_0_SEMI_BOTTOM:Class;

    [Embed(source='../_resources/zero/Sector_top.png')]
    private static const LEVEL_0_SEMI_TOP:Class;

    [Embed(source='../_resources/zero/Loop_top_right.png')]
    private static const LEVEL_0_TOP_RIGHT:Class;

    [Embed(source='../_resources/zero/Loop_bottom_left.png')]
    private static const LEVEL_0_BOTTOM_LEFT:Class;
    
    private var railView:RailView;

    public function RailViewPlaceHelper(railView:RailView) {
        this.railView=railView;
    }

    public function placeRail():void{
        if(TrafficNetwork.instance.level==1 || TrafficNetwork.instance.level==2){
            placeRailForLevel(railView.rail, 63, 30);
        }
        else if(TrafficNetwork.instance.level==0){
            placeRailForLevel(railView.rail, 85, 51);
        }else{
            throw new Error("Undefined level: "+TrafficNetwork.instance.level);
        }
    }

    protected function placeRailForLevel(rail:Rail, bigShift:int,  smallShift:int):void {
        if (rail.type == RailType.HORIZONTAL) {
            railView.x = rail.firstEnd.point.x;
            railView.y = rail.firstEnd.point.y - rail.trafficNetwork.railSpace;
        } else if (rail.type == RailType.VERTICAL) {
            railView.x = rail.firstEnd.point.x - rail.trafficNetwork.railSpace;
            railView.y = rail.firstEnd.point.y;
        } else if (rail.type == RailType.SEMI_ROUND_TOP) {
            railView.x = rail.firstEnd.point.x - rail.trafficNetwork.railSpace;
            railView.y = rail.firstEnd.point.y - rail.trafficNetwork.railSpace*2;
        } else if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
            railView.x = rail.firstEnd.point.x - rail.trafficNetwork.railSpace;
            railView.y = rail.firstEnd.point.y;
        } else if (rail.type == RailType.SEMI_ROUND_LEFT) {
            railView.x = rail.firstEnd.point.x-rail.trafficNetwork.railSpace*2;
            railView.y = rail.firstEnd.point.y-rail.trafficNetwork.railSpace;
        } else if (rail.type == RailType.SEMI_ROUND_RIGHT) {
            railView.x = rail.firstEnd.point.x;
            railView.y = rail.firstEnd.point.y-rail.trafficNetwork.railSpace;
        } else if (rail.type == RailType.ROUND_TOP_LEFT) {
            railView.x = rail.firstEnd.point.x - bigShift;
            railView.y = rail.secondEnd.point.y - bigShift;
        } else if (rail.type == RailType.ROUND_TOP_RIGHT) {
            railView.x = rail.secondEnd.point.x - smallShift;
            railView.y = rail.firstEnd.point.y - bigShift;
        } else if (rail.type == RailType.ROUND_BOTTOM_LEFT) {
            railView.x = rail.secondEnd.point.x - bigShift;
            railView.y = rail.firstEnd.point.y - smallShift;
        }  else if (rail.type == RailType.ROUND_BOTTOM_RIGHT) {
            railView.x = rail.firstEnd.point.x - smallShift;
            railView.y = rail.secondEnd.point.y - smallShift;
        }
    }

    public function addPictureAndHolst(holst:Sprite):void{
        if(TrafficNetwork.instance.level==1 || TrafficNetwork.instance.level==2){
            addPictureAndHolstFirstSecondLevel(railView.rail, holst);
        }
        else if(TrafficNetwork.instance.level==0){
            addPictureAndHolstZeroLevel(railView.rail, holst);
        }else{
            throw new Error("Undefined level: "+TrafficNetwork.instance.level);
        }
    }

    private function addPictureAndHolstFirstSecondLevel(rail:Rail, holst:Sprite):void {
        var picture;
        if (rail.type == RailType.HORIZONTAL) {
            picture = new LEVEL_1_HORIZONTAL;
            holst.y=12;
        } else if (rail.type == RailType.VERTICAL) {
            picture = new LEVEL_1_VERTICAL;
            holst.x=12;
        } else if (rail.type == RailType.SEMI_ROUND_TOP) {
            picture = new LEVEL_1_SEMI_TOP;
            holst.x=12;
        } else if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
            picture = new LEVEL_1_SEMI_BOTTOM;
            holst.x=12;
        } else if (rail.type == RailType.SEMI_ROUND_LEFT) {
            picture = new LEVEL_1_SEMI_LEFT;
            holst.y=12;
        } else if (rail.type == RailType.SEMI_ROUND_RIGHT) {
            picture = new LEVEL_1_SEMI_RIGHT;
            holst.y=12;
        } else if (rail.type == RailType.ROUND_TOP_LEFT) {
            picture = new LEVEL_1_TOP_LEFT;
        } else if (rail.type == RailType.ROUND_TOP_RIGHT) {
            picture = new LEVEL_1_TOP_RIGHT;
        } else if (rail.type == RailType.ROUND_BOTTOM_LEFT) {
            picture = new LEVEL_1_BOTTOM_LEFT;
        }  else if (rail.type == RailType.ROUND_BOTTOM_RIGHT) {
            picture = new LEVEL_1_BOTTOM_RIGHT;
        }
        railView.addChild(picture);
        railView.addChild(holst);

    }

    private function addPictureAndHolstZeroLevel(rail:Rail, holst:Sprite):void {
        var picture;
        if (rail.type == RailType.HORIZONTAL) {
            picture = new LEVEL_0_HORIZONTAL;
            holst.y=22;
        } else if (rail.type == RailType.VERTICAL) {
            picture = new LEVEL_0_VERTICAL;
            holst.x=22;
        } else if (rail.type == RailType.SEMI_ROUND_TOP) {
            picture = new LEVEL_0_SEMI_TOP;
            holst.x=22;
        } else if (rail.type == RailType.SEMI_ROUND_BOTTOM) {
            picture = new LEVEL_0_SEMI_BOTTOM;
            holst.x=22;
        } else if (rail.type == RailType.SEMI_ROUND_LEFT) {
            picture = new LEVEL_0_SEMI_LEFT;
            holst.y=22;
        } else if (rail.type == RailType.SEMI_ROUND_RIGHT) {
            picture = new LEVEL_0_SEMI_RIGHT;
            holst.y=22;
        } else if (rail.type == RailType.ROUND_TOP_RIGHT) {
            picture = new LEVEL_0_TOP_RIGHT;
            holst.x=12;
            holst.y=-12;
        } else if (rail.type == RailType.ROUND_BOTTOM_LEFT) {
            picture = new LEVEL_0_BOTTOM_LEFT;
            holst.x=-12;
            holst.y=12;
        }
        railView.addChild(picture);
        railView.addChild(holst);
    }

}
}
