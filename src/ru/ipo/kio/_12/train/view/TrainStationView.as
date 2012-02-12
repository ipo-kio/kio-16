/**
 *
 * @author: Vasily Akimushkin
 * @since: 30.01.12
 */
package ru.ipo.kio._12.train.view {
import flash.events.MouseEvent;

import ru.ipo.kio._12.train.model.Rail;
import ru.ipo.kio._12.train.model.TrafficNetwork;
import ru.ipo.kio._12.train.model.TrainStation;
import ru.ipo.kio._12.train.model.types.RailType;

public class TrainStationView extends RailView {
    
    public function TrainStationView(station:TrainStation) {
        super(station);
        place(station);

        update();
    }



     public override function update():void{
         super.update();

         var length:int = TrafficNetwork.instance.railLength;
         var space:int = TrafficNetwork.instance.railSpace;

          if (rail.type == RailType.ROUND_TOP_LEFT) {
                graphics.lineStyle(3, (TrainStation (rail)).stationType.color);
                graphics.drawRect(length/6,length/6, length/6,length/6);
           } else if (rail.type == RailType.ROUND_BOTTOM_RIGHT) {
                graphics.lineStyle(3, (TrainStation (rail)).stationType.color);
                graphics.drawRect(length/6,length/6,length/6,length/6);
           }




     }
}
}
