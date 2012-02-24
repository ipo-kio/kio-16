/**
 *
 * @author: Vasily Akimushkin
 * @since: 30.01.12
 */
package ru.ipo.kio._12.train.view {

import flash.display.Sprite;

import ru.ipo.kio._12.train.model.RailConnector;
import ru.ipo.kio._12.train.model.types.RailConnectorType;
import ru.ipo.kio._12.train.util.ConnectorInPath;

public class CrossConnectorView extends BasicView {

    [Embed(source='../_resources/Cross_section.png')]
    private static const LEVEL_1_CROSS:Class;

    private var _connectors:Vector.<RailConnector> = new Vector.<RailConnector>();

    private var _connectorInPath:Vector.<ConnectorInPath> = new Vector.<ConnectorInPath>();

    private var holst:Sprite = new Sprite();

    public function CrossConnectorView() {
        var line = new LEVEL_1_CROSS;
        addChild(line);
        holst.x=0;
        holst.y=0;
        addChild(holst);
        update();
    }

     public override function update():void{
         holst.graphics.clear();

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
}
}
