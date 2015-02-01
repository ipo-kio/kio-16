/**
 * Created by ilya on 31.01.15.
 */
package ru.ipo.kio._15.traincars {
public class CarsPositions {

    public static const STATIONS_COUNT:int = 4;
    public static const WAYS_COUNT:int = 4;

    private var _top:Vector.<Car>;
    private var _way:Vector.<Vector.<Car>> = new <Vector.<Car>>[]; // way -> number -> int

    private var _top_loco:Car;
    private var _way_loco:Vector.<Car> = new <Car>[];

    private var _railsSet:RailsSet;
    private var _railWay:Vector.<RailWay>;

    public function CarsPositions(railsSet:RailsSet, railWay:Vector.<RailWay>) {
        _railsSet = railsSet;
        _railWay = railWay;

        _top = new <Car>[
            new Car(0, 5),
            new Car(0, 4),
            new Car(0, 3),
            new Car(0, 2),
            new Car(0, 1),
            new Car(1, 5),
            new Car(1, 4),
            new Car(1, 3),
            new Car(1, 2),
            new Car(1, 1),
            new Car(2, 5),
            new Car(2, 4),
            new Car(2, 3),
            new Car(2, 2),
            new Car(2, 1),
            new Car(3, 5),
            new Car(3, 4),
            new Car(3, 3),
            new Car(3, 2),
            new Car(3, 1)
        ];

        for each (var c:Car in _top)
            _railsSet.addChild(c);

        for (var wayInd:int = 0; wayInd < WAYS_COUNT; wayInd++)
            _way[wayInd] = new <Car>[];

        _top_loco = new Car(4, 0);
        _railsSet.addChild(_top_loco);
        for (wayInd = 0; wayInd < WAYS_COUNT; wayInd++) {
            var loco:Car = new Car(4, 0);
            _way_loco.push(loco);
            _railsSet.addChild(loco);
        }
    }

    public function get top():Vector.<Car> {
        return _top;
    }

    public function get way():Vector.<Vector.<Car>> {
        return _way;
    }

    public function get railsSet():RailsSet {
        return _railsSet;
    }

    public function get railWay():Vector.<RailWay> {
        return _railWay;
    }

    public function get top_loco():Car {
        return _top_loco;
    }

    public function get way_loco():Vector.<Car> {
        return _way_loco;
    }

//   way way way way way             top top top top top top

    public function moveToTop(wayInd:int, count:int):Boolean {
        if (count == 0)
            return false;

        var way:Vector.<Car> = _way[wayInd];
        if (way.length < count)
            return false; // can not do this
        var cars:Vector.<Car> = way.splice(way.length - count, count);

        for each (var car:Car in cars.reverse())
            _top.splice(0, 0, car);

        return true;
    }

    public function moveFromTop(wayInd:int, count:int):Boolean {
        if (count == 0)
            return false;

        var way:Vector.<Car> = _way[wayInd];
        if (_top.length < count)
            return false; // can not do this
        var cars:Vector.<Car> = _top.splice(0, count);
        for each (var car:Car in cars)
            way.push(car);

        return true;
    }


    public function toString():String {
        return "CarsPositions{_top=" + String(_top) + ",_way=" + _way.join("+") + "}";
    }

    public function positionCars(): void {
        var topI:int = 0;
        for each (var topCar:Car in _top) {
            topCar.moveTo(_railWay[0], TrainCarsWorkspace.TOP_END_TICK - topI * Car.CAR_TICKS_LENGTH);
            topI++;
        }
        _top_loco.moveTo(_railWay[0], TrainCarsWorkspace.TOP_END_TICK - topI * Car.CAR_TICKS_LENGTH);

        for (var way_ind:int = 0; way_ind < WAYS_COUNT; way_ind++) {
            var wayI:int = carsCount(way_ind) - 1;
            for each (var wayCar:Car in _way[way_ind]) {
                wayCar.moveTo(_railWay[way_ind], TrainCarsWorkspace.WAY_START_TICK + wayI * Car.CAR_TICKS_LENGTH);
                wayI--;
            }
            _way_loco[way_ind].moveTo(_railWay[way_ind], TrainCarsWorkspace.WAY_START_TICK + carsCount(way_ind) * Car.CAR_TICKS_LENGTH);
        }
    }

    public function carsCount(wayInd:int):int {
        return _way[wayInd].length;
    }

    //does operation with no test
    public function moveOperationFromTop(wayInd:int):void {
        moveFromTop(wayInd, 1);
    }

    //does operation with no test
    public function moveOperationToTop(wayInd:int):void {
        moveToTop(wayInd, carsCount(wayInd));
    }

    public function mayMoveFromTop():Boolean {
        if (_top.length == 0)
            return false;

        for each (var car:Car in _top)
            if (car.moving == Car.MOVING_BACKWARDS)
                return false;
        for each (var cars:Vector.<Car> in _way)
            for each (car in cars)
                if (car.moving == Car.MOVING_BACKWARDS)
                    return false;

        return true;
    }

    public function mayMoveToTop(way_ind:int):Boolean {
        if (_way[way_ind].length == 0)
            return false;

        for each (var car:Car in _top)
            if (car.isMoving())
                return false;
        for each (var cars:Vector.<Car> in _way)
            for each (car in cars)
                if (car.isMoving())
                    return false;
        for each (car in _way_loco)
            if (car.isMoving())
                return false;

        return true;
    }
}
}
