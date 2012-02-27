/**
 *
 * @author: Vasily Akimushkin
 * @since: 30.01.12
 */
package ru.ipo.kio._12.train.view {

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._12.train.model.RailConnector;
import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.types.ArrowStateType;
import ru.ipo.kio._12.train.util.ConnectorInPath;

public class CrossConnectorView extends BasicView {

    [Embed(source='../_resources/one/Cross_section.png')]
    private static const LEVEL_1_CROSS:Class;

    [Embed(source='../_resources/zero/Cross_section.png')]
    private static const LEVEL_0_CROSS:Class;

    [Embed(source='../_resources/zero/Cross_section_top_2.png')]
    private static const LEVEL_0_UP:Class;

    [Embed(source='../_resources/zero/Cross_section_bottom_2.png')]
    private static const LEVEL_0_DOWN:Class;

    [Embed(source='../_resources/one/Cross_section_05.png')]
    private static const LEVEL_2_CROSS:Class;

    [Embed(source='../_resources/one/Cross_section_06.png')]
    private static const LEVEL_2_CROSS_1:Class;

    [Embed(source='../_resources/one/Cross_section_07.png')]
    private static const LEVEL_2_CROSS_2:Class;


    private var _connectors:Vector.<RailConnector> = new Vector.<RailConnector>();

    private var _connectorInPath:Vector.<ConnectorInPath> = new Vector.<ConnectorInPath>();

    private var holst:Sprite = new Sprite();

    private var line1;

    private var line2;

    private var line3;

    private var _type: ArrowStateType = ArrowStateType.DIRECT;

    public function CrossConnectorView(railId:int=-1, postRail:Boolean = false) {
        if(TrafficNetwork.instance.level==1){
            var line = new LEVEL_1_CROSS;
            addChild(line);
        }else if(TrafficNetwork.instance.level==0){
            if(railId == 0 && !postRail){
                var line = new LEVEL_0_UP;
            }
            else if(railId == 11 && postRail){
                var line = new LEVEL_0_DOWN;
            }
            else{
                var line = new LEVEL_0_CROSS;
            }
            addChild(line);
        }else if(TrafficNetwork.instance.level==2){
            line1 = new LEVEL_2_CROSS;
            addChild(line1);
            line1.visible =false;
            line2 = new LEVEL_2_CROSS_1;
            addChild(line2);
            line2.visible =false;
            line3 = new LEVEL_2_CROSS_2;
            addChild(line3);
            line3.visible =false;

            addEventListener(MouseEvent.CLICK, function(ev:Event):void{
                _type=_type.next();
                update();
            });
        }
        holst.x=0;
        holst.y=0;
        addChild(holst);
        update();
    }

     public override function update():void{
         holst.graphics.clear();

         if(TrafficNetwork.instance.level==2){

         line1.visible =false;
         line2.visible =false;
         line3.visible =false;
         
         if(_type == ArrowStateType.DIRECT){
             line2.visible=true;
         }else if(_type == ArrowStateType.RIGHT){
             line3.visible=true;
         }else if(_type == ArrowStateType.LEFT){
             line1.visible=true;
         }

         }

         _connectorInPath.sort(function compare(x:ConnectorInPath, y:ConnectorInPath):Number {
             return x.time-y.time;
         });
         
         for(var i:int = 0; i<_connectorInPath.length; i++){
             var connectorInPath:ConnectorInPath = _connectorInPath[i];
             var index:int = connectorInPath.index;
             var alpha:Number = 1;
             var active:Boolean = connectorInPath.active;
             var color:int =active?0xffffff:connectorInPath.color;
             var shiftX=12;
             var shiftY=12;
//             if(connectorInPath.type==RailConnectorType.HORIZONTAL){
//                 holst.graphics.lineStyle(2,0x000000,0.5);
//                 holst.graphics.moveTo(0,5+index*4+shiftY);
//                 holst.graphics.lineTo(width,5+index*4+shiftY);
//
//                 holst.graphics.lineStyle(active?3:2,color,alpha);
//                 holst.graphics.moveTo(0,3+index*4+shiftY);
//                 holst.graphics.lineTo(width,3+index*4+shiftY);
//             }
//             else if(connectorInPath.type==RailConnectorType.VERTICAL){
//                 holst.graphics.lineStyle(2,0x000000,0.5);
//                 holst.graphics.moveTo(5+index*4+shiftX,0);
//                 holst.graphics.lineTo(5+index*4+shiftX,height);
//
//                 holst.graphics.lineStyle(active?3:2,color,alpha);
//                 holst.graphics.moveTo(3+index*4+shiftX,0);
//                 holst.graphics.lineTo(3+index*4+shiftX,height);
//             }
         }
         
     }

    public function get connectors():Vector.<RailConnector> {
        return _connectors;
    }

    public function set connectors(value:Vector.<RailConnector>):void {
        _connectors = value;
    }

    public function get connectorInPath():Vector.<ConnectorInPath> {
        return _connectorInPath;
    }

    public function set connectorInPath(value:Vector.<ConnectorInPath>):void {
        _connectorInPath = value;
    }

    public function get type():ArrowStateType {
        return _type;
    }

    public function set type(value:ArrowStateType):void {
        _type = value;
    }
}
}
