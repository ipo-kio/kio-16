/**
 *
 * @author: Vasily Akimushkin
 * @since: 29.01.12
 */
package ru.ipo.kio._12.train.view {
import ru.ipo.kio._12.train.model.TrafficNetwork;

public class TrafficNetworkView extends BasicView {

    private var _trafficNetwork:TrafficNetwork;

    public function TrafficNetworkView(trafficNetwork:TrafficNetwork) {
        super();
        _trafficNetwork=trafficNetwork;
    }

    public override function update():void{
        for(var i:int = 0; i<_trafficNetwork.rails.length; i++){
            _trafficNetwork.rails[i].view.update();
        }

        for(var i:int = 0; i<_trafficNetwork.trains.length; i++){
            _trafficNetwork.trains[i].view.update();
        }
    }


}
}
