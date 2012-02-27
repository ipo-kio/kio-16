/**
 *
 * @author: Vasily Akimushkin
 * @since: 26.02.12
 */
package ru.ipo.kio._12.train.model {
import ru.ipo.kio._12.train.model.types.ArrowStateType;

public class AutomationStep {
    
    private var _number:int;

    private var _leftStep:int;

    private var _rightStep:int;

    private var _directStep:int;

    private var _leftArrowState:ArrowStateType = ArrowStateType.DIRECT;

    private var _rightArrowState:ArrowStateType = ArrowStateType.DIRECT;

    private var _directArrowState:ArrowStateType = ArrowStateType.DIRECT;


    public function AutomationStep(number:int) {
        _number = number;
    }

    public function get number():int {
        return _number;
    }

    public function set number(value:int):void {
        _number = value;
    }

    public function get leftStep():int {
        return _leftStep;
    }

    public function set leftStep(value:int):void {
        _leftStep = value;
    }

    public function get rightStep():int {
        return _rightStep;
    }

    public function set rightStep(value:int):void {
        _rightStep = value;
    }

    public function get directStep():int {
        return _directStep;
    }

    public function set directStep(value:int):void {
        _directStep = value;
    }

    public function get leftArrowState():ArrowStateType {
        return _leftArrowState;
    }

    public function set leftArrowState(value:ArrowStateType):void {
        _leftArrowState = value;
    }

    public function get rightArrowState():ArrowStateType {
        return _rightArrowState;
    }

    public function set rightArrowState(value:ArrowStateType):void {
        _rightArrowState = value;
    }

    public function get directArrowState():ArrowStateType {
        return _directArrowState;
    }

    public function set directArrowState(value:ArrowStateType):void {
        _directArrowState = value;
    }

    public function nextLeftDirection():void {
        _leftArrowState = _leftArrowState.next();
    }

    public function nextRightDirection():void {
        _rightArrowState = _rightArrowState.next();
    }

    public function nextDirectDirection():void {
        _directArrowState = _directArrowState.next();
    }

    public function get rightArrowStatePic():String {
        return _rightArrowState.getString();
    }

    public function get leftArrowStatePic():String {
        return _leftArrowState.getString();
    }

    public function get directArrowStatePic():String {
        return _directArrowState.getString();
    }

}
}
