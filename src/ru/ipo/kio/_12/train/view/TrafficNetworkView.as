/**
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.view {
import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.util.ConnectorInPath;

public class TrafficNetworkView extends BasicView {

    private var _trafficNetwork:TrafficNetwork;

    public function TrafficNetworkView(trafficNetwork:TrafficNetwork) {
        super();
        _trafficNetwork=trafficNetwork;
    }

    public override function update():void{
        


        
        //обновляем рельсы
        for(var i:int = 0; i<_trafficNetwork.rails.length; i++){
            _trafficNetwork.rails[i].view.update();
        }

        //обновляем поезда
        for(var i:int = 0; i<_trafficNetwork.trains.length; i++){
            _trafficNetwork.trains[i].view.update();
        }

        //обновляем пересечения
//        for(var i:int = 0; i<_trafficNetwork.connectorViews.length; i++){
//            (CrossConnectorView (_trafficNetwork.connectorViews[i])).connectorInPath = new Vector.<ConnectorInPath>();
//        }

//        _trafficNetwork.calcConnectors();

        for(var i:int = 0; i<_trafficNetwork.connectorViews.length; i++){
            _trafficNetwork.connectorViews[i].update();
        }
    }


}
}
