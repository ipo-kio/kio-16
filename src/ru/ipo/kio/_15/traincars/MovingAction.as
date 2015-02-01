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

    public function get way():RailWay {
        return _position.railWay[_way_ind];
    }

    public function execute():void {
        storeCars();
        if (_typ == TYP_TO_TOP) {
            _position.moveOperationToTop(_way_ind);
            executeToTop();
        } else if (_typ == TYP_FROM_TOP) {
            _position.moveOperationFromTop(_way_ind);
            executeFromTop();
        }
    }

    private function executeFromTop():void {
        var delta:int = TrainCarsWorkspace.WAY_START_TICK - TrainCarsWorkspace.TOP_END_TICK;

        for each (var car:Car in _cars_top)
            car.addMoveDelta(Car.CAR_TICKS_LENGTH, way);

        for each (car in _cars_move) {
            car.addMoveDelta(delta, way);
            car.addEventListener(Car.EVENT_PUSH_DOWN, pushDownHandler);
        }

        _position.top_loco.addMoveDelta(Car.CAR_TICKS_LENGTH, way);
    }

    private function executeToTop():void {
        var delta:int = _cars_move[0].tick - TrainCarsWorkspace.TOP_END_TICK;
        for each (var car:Car in _cars_move) {
            car.subMoveDelta(delta, way);
            car.addEventListener(Car.EVENT_PUSH_UP, pushUpHandler);
        }
        var loco:Car = _position.way_loco[_way_ind];
        loco.subMoveDelta(loco.tick - TrainCarsWorkspace.TOP_END_TICK - Car.CAR_TICKS_LENGTH, way);
        loco.addEventListener(Car.EVENT_PUSH_UP, locoPushUpHandler);
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
    }
}
}
