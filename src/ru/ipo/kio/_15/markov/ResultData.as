/**
 * Created by Vasiliy on 21.02.2015.
 */
package ru.ipo.kio._15.markov {
public class ResultData {

    private var _ridgeDiff:int=0;

    private var _ruleAmount:int=0;

    private var _applyOperations:int = 0;

    private var _ruleLength:int = 0;

    private var _perc:Number = 0;

    private var _correctAmount:int = 0;

    private var _wrongPair:int = 0;

    private var _wrongOrder:int=0;

    private var _error:Boolean = false;


    public function get error():Boolean {
        return _error;
    }

    public function set error(value:Boolean):void {
        _error = value;
    }

    public function get wrongOrder():int {
        return _wrongOrder;
    }

    public function set wrongOrder(value:int):void {
        _wrongOrder = value;
    }

    public function get wrongPair():int {
        return _wrongPair;
    }

    public function set wrongPair(value:int):void {
        _wrongPair = value;
    }

    public function ResultData() {
    }


    public function get correctAmount():int {
        return _correctAmount;
    }

    public function set correctAmount(value:int):void {
        _correctAmount = value;
    }

    public function get ruleLength():int {
        return _ruleLength;
    }

    public function set ruleLength(value:int):void {
        _ruleLength = value;
    }

    public function get perc():Number {
        return _perc;
    }

    public function set perc(value:Number):void {
        _perc = value;
    }

    public function get ridgeDiff():int {
        return _ridgeDiff;
    }

    public function set ridgeDiff(value:int):void {
        _ridgeDiff = value;
    }

    public function get ruleAmount():int {
        return _ruleAmount;
    }

    public function set ruleAmount(value:int):void {
        _ruleAmount = value;
    }

    public function get applyOperations():int {
        return _applyOperations;
    }

    public function set applyOperations(value:int):void {
        _applyOperations = value;
    }

    public function clone():ResultData{
        var resultData = new ResultData();
        resultData._applyOperations = this.applyOperations;
        resultData._ridgeDiff = this.ridgeDiff;
        resultData._ruleAmount = this.ruleAmount;
        resultData._perc = this.perc;
        resultData._ruleLength = this.ruleLength;
        resultData.correctAmount = this.correctAmount;
        resultData.wrongPair = this.wrongPair;
        resultData.wrongOrder = this.wrongOrder;
        resultData.error = this.error;
        return resultData;

}
}
}
