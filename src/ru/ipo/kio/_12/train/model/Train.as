/**
 *
 * @author: Vasily Akimushkin
 * @since: 12.02.12
 */
package ru.ipo.kio._12.train.model {
import ru.ipo.kio._12.train.model.types.RailStationType;
import ru.ipo.kio._12.train.view.TrainView;

public class Train extends VisibleEntity {

    private var _destination:RailStationType;

    public function get destination():RailStationType {
        return _destination;
    }

    public function set destination(value:RailStationType):void {
        _destination = value;
    }

    private var _rail:Rail;
    
    private var _route:TrainRoute = new TrainRoute();
    
    private var _color:int;
    
    private var _passengers:Vector.<Passenger> = new Vector.<Passenger>();

    private var tick:int =0;

    private var count:int =0;


    public function Train(destination:RailStationType) {
        _destination = destination;
        view=new TrainView(this);

    }


    public function get rail():Rail {
        return _rail;
    }

    public function set rail(value:Rail):void {
        _rail = value;
    }

    public function get route():TrainRoute {
        return _route;
    }

    public function set route(value:TrainRoute):void {
        _route = value;
    }

    public function get color():int {
        return _color;
    }

    public function set color(value:int):void {
        _color = value;
    }

    public function get passengers():Vector.<Passenger> {
        return _passengers;
    }

    public function set passengers(value:Vector.<Passenger>):void {
        _passengers = value;
    }


    public function getClosestStation():RailStationType {
        for(var i:int = count; i<route.rails.length; i++){
            var rail:Rail = route.rails[i];
            if(rail instanceof TrainStation){
                return (TrainStation(rail)).stationType;
            }
        }
        return null;
    }

    public function action():void {
      if(rail.type.length>tick+1){
          tick++;
      }else{
          tick = 0;
          rail.action(this);
          count++;
          if(route.rails.length>count){
            rail = route.rails[count];
          }
      }
    }

    public function reset():void{
       rail = route.rails[0];
       tick = 0;
        count = 0;
    }
    
    public function moveLast():void{
        count = route.rails.length-1;
        rail = route.rails[count];
    }

    public function isFinished():Boolean{
        return count >= route.rails.length;
    }

    public function isDirect():Boolean {
        if(route.rails.length<=1 || count == 0){
            return true;
        }
        var preRail:Rail = route.rails[count-1];
        
        return rail.firstEnd.isConnected(preRail);
    }
}
}
