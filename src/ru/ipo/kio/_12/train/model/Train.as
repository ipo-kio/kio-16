/**
 *
 * @author: Vasily Akimushkin
 * @since: 12.02.12
 */
package ru.ipo.kio._12.train.model {
import ru.ipo.kio._12.train.model.types.ArrowStateType;
import ru.ipo.kio._12.train.model.types.RailConnectorType;
import ru.ipo.kio._12.train.model.types.RailType;
import ru.ipo.kio._12.train.model.types.StationType;
import ru.ipo.kio._12.train.util.ArrowStateRailConvertorUtil;
import ru.ipo.kio._12.train.util.StatePair;
import ru.ipo.kio._12.train.view.CrossConnectorView;
import ru.ipo.kio._12.train.view.TrainView;

public class Train extends VisibleEntity {

    private var _destination:StationType;

    public function get destination():StationType {
        return _destination;
    }

    public function set destination(value:StationType):void {
        _destination = value;
    }

    private var _rail:Rail;

    private var _route:TrainRoute = new TrainRoute();

    private var _color:int;

    private var _passengers:Vector.<Passenger> = new Vector.<Passenger>();

    private var _tick:int = 0;

    private var _count:int = 0;

    private var _pathTime:int = 0;

    private var _toPasTime:int = 0;

    private var state:int = 0;


    public function Train(destination:StationType) {
        _destination = destination;
        view = new TrainView(this);

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


    public function getClosestStation():StationType {
        for (var i:int = _count; i < route.rails.length; i++) {
            var rail:Rail = route.rails[i];
            if (rail instanceof TrainStation) {
                return (TrainStation(rail)).stationType;
            }
        }
        return null;
    }
    
    function isFinish():Boolean{
        return _count==route.rails.length-1;
    }

    public function action():void {
        for (var i:int = passengers.length - 1; i >= 0; i--) {
            passengers[i].time++;
        }

        if (rail.type.length > _tick + 1) {
            _tick++;
        } else if (route.rails.length > _count + 1){
            _tick = 0;
            _count++;
            rail = route.rails[_count];
            rail.processPassengers(this);
//          if(TrafficNetwork.instance.level==2){
//              if(_count<100){
//
//              _count++;
//
//              if(route.rails.length==1){
//                  var end:RailEnd = rail.secondEnd;
//              }else{
//                  var end:RailEnd = route.getLastEnd();
//              }
//              var connectors:Vector.<RailConnector> = end.connectors;
//              var crossType:ArrowStateType = (CrossConnectorView(connectors[0].view)).type;
//              crossType = ArrowStateRailConvertorUtil.getStateByEnd(end, crossType);
//              var statePair:StatePair = Automation.instance.getStep(state, crossType);
//              state = statePair.number;
//              var newRail:Rail = getRailByCross(end, statePair.arrow);
//              route.rails.push(newRail);
//              rail = route.rails[_count];
//              (CrossConnectorView(connectors[0].view)).type = ArrowStateRailConvertorUtil.getStateByEndToNormal(end, statePair.arrow);
//              }
        }
    }

    private function getRailByCross(end:RailEnd, arrow:ArrowStateType):Rail {
        var rail:Rail = end.rail;
        return end.getRailByConnectorType(rail.type.getConnector(arrow, end.isFirst()));
    }

    public function reset():void {
        rail = route.rails[0];
        _tick = 0;
        _count = 0;
        _pathTime = 0;
        state = 0;
        _toPasTime = 0;
        passengers = new Vector.<Passenger>();
    }

    public function moveLast():void {
        _count = route.rails.length - 1;
        rail = route.rails[_count];
    }

    public function getPreRail():Rail {
        if (route.rails.length <= 1 || _count == 0 || count > route.rails.length) {
            return null;
        }
        return route.rails[_count - 1];
    }

    public function isDirect():Boolean {
        if (route.rails.length <= 1 || _count == 0) {
            return true;
        }
        var preRail:Rail = route.rails[_count - 1];

        var res = rail.firstEnd.isConnected(preRail);

        //if(preRail.firstEnd.connectedE(rail.firstEnd) && preRail.secondEnd.connectedE(rail.secondEnd)){
            return route.getLastEndFor(_count+1)==rail.secondEnd;
//            dir = !train.isDirect();
//            trace(dir);
  //      }
        
    //    return res;
    }

    public function get tick():int {
        return _tick;
    }

    public function get pathTime():int {
        return _pathTime;
    }

    public function containsDestination(destination:StationType):Boolean {
        for (var i:int = _count; i < route.rails.length; i++) {
            var rail:Rail = route.rails[i];
            if (rail instanceof TrainStation) {
                if ((TrainStation(rail)).stationType == destination)
                    return true;
            }
        }
        return false;
    }

    public function get count():int {
        return _count;
    }

    public function getNextRail():Rail {
        if (rail.type.length > _tick + 1) {
            return rail;
        }

        if(route.rails.length > _count + 1){
            return route.rails[_count+1];
        }
        return null;
    }

    public function get toPasTime():int {
        return _toPasTime;
    }

    public function set toPasTime(value:int):void {
        _toPasTime = value;
    }
}
}
