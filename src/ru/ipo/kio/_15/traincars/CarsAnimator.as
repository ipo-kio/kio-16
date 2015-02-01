/**
 * Created by ilya on 01.02.15.
 */
package ru.ipo.kio._15.traincars {
public class CarsAnimator {

    private var _railsSet:RailsSet;
    private var _railWays:Vector.<RailWay>;
    private var _carsPositions:CarsPositions;

    private var _animation:Boolean = false;

    public function CarsAnimator(railsSet:RailsSet, railWays:Vector.<RailWay>, carsPositions:CarsPositions) {
        _railsSet = railsSet;
        _railWays = railWays;
        _carsPositions = carsPositions;
    }
}
}
