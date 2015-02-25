/**
 * Created by ilya on 01.02.15.
 */
package ru.ipo.kio._15.traincars {
import flash.events.Event;

public class MovingAction {

    public static const TYP_TO_TOP:int = 0;
    public static const TYP_FROM_TOP:int = 1;

    private var _typ:int;
    private var _position:CarsPositions;
    private var _way_ind:int;

    private var _cars_top:Vector.<Car>;
    private var _cars_move:Vector.<Car>;
    private var _cars_way:Vector.<Car>;

    public static function createFromShortRepresentation(repr:int, position:CarsPositions):MovingAction {
        return new MovingAction(repr < 0 ? TYP_TO_TOP : TYP_FROM_TOP, position, Math.abs(repr) - 1);
    }

    public function MovingAction(typ:int, position:CarsPositions, way_ind:int) {
        _typ = typ;
        _position = position;
        _way_ind = way_ind;
    }

    private function storeCars():void {
        var way_cars:Vector.<Car> = _position.way[_way_ind];
        if (_typ == TYP_TO_TOP) {
            _cars_top = _position.top.slice();
            _cars_move = way_cars.slice();
            _cars_way = new <Car>[];
        } else if (_typ == TYP_FROM_TOP) {
            _cars_top = _position.top.slice(1);
            _cars_move = _position.top.slice(0, 1);
            _cars_way = way_cars.slice();
        }
    }

    public function get typ():int {
        return _typ;
    }

    public function get way():RailWay {
        return _position.railWay[_way_ind];
    }

    public function execute(animate:Boolean):void {
        storeCars();
        if (_typ == TYP_TO_TOP) {
            _position.moveOperationToTop(_way_ind);
            if (animate)
                executeToTop();
            else
                _position.positionCars();
        } else if (_typ == TYP_FROM_TOP) {
            _position.moveOperationFromTop(_way_ind);
            if (animate)
                executeFromTop();
            else
                _position.positionCars();
        }
    }

    private function executeFromTop():void {
        var delta:int = TrainCarsWorkspace.WAY_START_TICK - TrainCarsWorkspace.TOP_END_TICK;

        for each (var car:Car in _cars_top)
            car.addMoveDelta(Car.CAR_TICKS_LENGTH, way);

        for each (car in _cars_move) {
            car.addMoveDelta(delta, way);
            car.addEventListener(Car.EVENT_PUSH_DOWN, pushDownHandler);
            car.addEventListener(Car.EVENT_STOP_MOVE, carStoppedHandler);
        }

        _position.top_loco.addMoveDelta(Car.CAR_TICKS_LENGTH, way);
    }

    private function executeToTop():void {
        var delta:int = _cars_move[0].tick - TrainCarsWorkspace.TOP_END_TICK;
        for each (var car:Car in _cars_move) {
            car.subMoveDelta(delta, way);
            car.addEventListener(Car.EVENT_PUSH_UP, pushUpHandler);
            car.addEventListener(Car.EVENT_STOP_MOVE, carStoppedHandler);
        }
        var loco:Car = _position.way_loco[_way_ind];
        loco.subMoveDelta(loco.tick - TrainCarsWorkspace.TOP_END_TICK - Car.CAR_TICKS_LENGTH, way);
        loco.addEventListener(Car.EVENT_PUSH_UP, locoPushUpHandler);
    }

    private function carStoppedHandler(e:Event):void {
        var car:Car = Car(e.target);
        car.removeEventListener(Car.EVENT_PUSH_DOWN, pushDownHandler);
        car.removeEventListener(Car.EVENT_PUSH_UP, pushUpHandler);

        car.removeEventListener(Car.EVENT_STOP_MOVE, carStoppedHandler);
    }

    private function pushDownHandler(event:Event):void {
        var car:Car = Car(event.target);
        car.removeEventListener(Car.EVENT_PUSH_DOWN, pushDownHandler);
        for each (car in _cars_way)
            car.addMoveDelta(Car.CAR_TICKS_LENGTH, way);
        _position.way_loco[_way_ind].addMoveDelta(Car.CAR_TICKS_LENGTH, way);
    }

    private function pushUpHandler(event:Event):void {
        var car:Car = Car(event.target);
        car.removeEventListener(Car.EVENT_PUSH_UP, pushUpHandler);
        for each (var car_top:Car in _cars_top)
            car_top.subMoveDelta(Car.CAR_TICKS_LENGTH, way);
        _position.top_loco.subMoveDelta(Car.CAR_TICKS_LENGTH, way);
    }

    private function locoPushUpHandler(event:Event):void {
        var loco:Car = Car(event.target);
        loco.removeEventListener(Car.EVENT_PUSH_UP, locoPushUpHandler);
        loco.addMoveDelta(TrainCarsWorkspace.WAY_START_TICK - loco.tick, way);
        _position.dispatchEvent(new Event(CarsPositions.EVENT_SOME_CAR_STARTED_MOVING));
    }

    public function undo():void {
        _position.positionCars();

        var top_cars_list:Vector.<Car> = new <Car>[];
        var way_cars_list:Vector.<Car> = new <Car>[];

        if (_typ == TYP_FROM_TOP) {
            top_cars_list = _cars_move.concat(_cars_top);
            way_cars_list = _cars_way.slice();
        } else if (_typ == TYP_TO_TOP) {
            top_cars_list = _cars_top.slice();
            way_cars_list = _cars_way.concat(_cars_move);
        }

        _position.setCars(top_cars_list, _way_ind, way_cars_list);

        _position.positionCars();
    }

    public function get shortRepresentation():int {
        if (_typ == TYP_FROM_TOP)
            return _way_ind + 1;
        else if (_typ == TYP_TO_TOP)
            return -_way_ind - 1;

        return 0;
    }
}
}

//TODO semaphore should become green when loco goes down