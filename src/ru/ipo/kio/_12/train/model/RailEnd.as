/**
 * ����� ������, �������� ������ ����������
 *
 * @author: Vasily Akimushkin
 * @since: 30.01.12
 */
package ru.ipo.kio._12.train.model {
import flash.geom.Point;

import ru.ipo.kio._12.train.model.types.RailConnectorType;

public class RailEnd extends VisibleEntity{

    private var _point:Point;

    private var _rail:Rail;
    
    private var _connectors:Vector.<RailConnector> = new Vector.<RailConnector>();
    
    public function RailEnd(point:Point, rail:Rail) {
        _point = point;
        _rail = rail;
    }

    public function get point():Point {
        return _point;
    }

    public function get rail():Rail {
        return _rail;
    }

    public function addConnector(connector:RailConnector):void{
        _connectors.push(connector);
    }

    public function get connectors():Vector.<RailConnector> {
        return _connectors;
    }

    public function isConnected(rail:Rail): Boolean{
        for(var i:int; i<_connectors.length; i++){
            if(_connectors[i].getAnotherRail(_rail)==rail){
                return true;
            }
        }
        return false;
    }

    public function isFirst():Boolean{
        return rail.firstEnd==this;
    }

    public function getAllNearConnectors():Vector.<RailConnector> {
        var list:Vector.<RailConnector> = new Vector.<RailConnector>();
        for(var i:int=0; i<_connectors.length; i++){
            list.push(_connectors[i]);
            var end:RailEnd = _connectors[i].getAnotherEnd(this);
            for(var j:int=0; j<end.connectors.length; j++){
                list.push(end.connectors[j]);
            }
         }
        return list;
    }

    public function getRailByConnectorType(connectorType:RailConnectorType):Rail {
        for(var i:int; i<_connectors.length; i++){
            if(_connectors[i].type==connectorType){
                var rail:Rail = _connectors[i].getAnotherRail(_rail);
                if(rail!=null){
                    return rail;
                }
            }
        }
        throw new Error("Can't find rail by connector: "+connectorType.toString());
    }

    public function connectedE(firstEnd:RailEnd):Boolean {
        for(var i:int=0; i<_connectors.length; i++){
            var end:RailEnd = _connectors[i].getAnotherEnd(this);
            if(end == firstEnd)
                return true;
        }
        return false;
    }
}
}
