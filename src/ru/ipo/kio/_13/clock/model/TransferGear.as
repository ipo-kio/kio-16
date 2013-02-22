package ru.ipo.kio._13.clock.model {
import mx.utils.HSBColor;

import ru.ipo.kio._13.clock.utils.MathUtils;

import ru.ipo.kio._13.clock.view.BasicView;
import ru.ipo.kio._13.clock.view.TransferGearView;
import ru.ipo.kio._13.clock.view.TransferGearViewSide;

public class TransferGear {
    
    private var _x:int;
    
    private var _y:int;
    
    private var _upperGear:SimpleGear;
    
    private var _lowerGear:SimpleGear;
    
    private var _view:BasicView;

    private var _viewSide:BasicView;
    
    private var _hue:int;

    private var _isMove:Boolean;
    
    private var _isActive:Boolean;
    
    private var _transmissionMechanism:TransmissionMechanism;
    
    private var _alpha:Number = Math.PI+Math.pow(10,-10);

    private var _secondViewSide:BasicView;
    
    private var _conflict:Boolean = false;

    public function TransferGear(transmissionMechanism:TransmissionMechanism, x:int, y:int, upperAmountOfCogs:int, lowerAmountOfCogs:int, hue:int) {
        _transmissionMechanism=transmissionMechanism;
        _hue = hue;
        _upperGear = new SimpleGear(this, lowerAmountOfCogs, SimpleGear.UPPER_PART, HSBColor.convertHSBtoRGB(hue, 1, 1));
        _lowerGear = new SimpleGear(this, upperAmountOfCogs, SimpleGear.LOWER_PART, HSBColor.convertHSBtoRGB(hue, 1, 30));
        _x = x;
        _y = y;
        _view = new TransferGearView(this);
        _viewSide = new TransferGearViewSide(this);
        if(transmissionMechanism.transferGearList.length==0){
            _secondViewSide = new TransferGearViewSide(this, true);
        }
    }


    public function get viewSide():BasicView {
        return _viewSide;
    }

    public function get hue():int {
        return _hue;
    }

    public function get upperGear():SimpleGear {
        return _upperGear;
    }

    public function get lowerGear():SimpleGear {
        return _lowerGear;
    }


    public function get x():int {
        return _x;
    }

    public function set x(value:int):void {
        _x = value;
        if(view!=null){
            view.update();
        }
    }

    public function get y():int {
        return _y;
    }

    public function set y(value:int):void {
        _y = value;
        if(view!=null){
            view.update();
        }
    }

    public function get view():BasicView {
        return _view;
    }


    public function get isMove():Boolean {
        return _isMove;
    }

    public function set isMove(value:Boolean):void {
        _isMove = value;
        if(view!=null){
            view.update();
        }
    }


    public function get isActive():Boolean {
        return _isActive;
    }

    public function set isActive(value:Boolean):void {
        _isActive = value;
        if(view!=null){
            view.update();
        } if(_viewSide!=null){
            viewSide.update();
        }

    }

    public function getRadius():int{
        return Math.max(lowerGear.outerRadius, upperGear.outerRadius);
    }
    
    public function getNextTransferGear():TransferGear{
      return _transmissionMechanism.getNext(this);
    }

    public function getPreviousTransferGear():TransferGear{
       return _transmissionMechanism.getPrevious(this);
    }

    public function get transmissionMechanism():TransmissionMechanism {
        return _transmissionMechanism;
    }


    public function get alpha():Number {
        return _alpha;
    }

    public function set alpha(value:Number):void {
      while(value>Math.PI*2){
        value -=Math.PI*2;
      }
      while(value<0){
        value+=Math.PI*2;
      }
        _alpha = value;
    }

    public function isLast(): Boolean{
       return transmissionMechanism.getIndex(this)==transmissionMechanism.transferGearList.length-1;
    }

    public function isFirst():Boolean {
       return transmissionMechanism.firstGear==this;
    }

    public function toJson():Object {
        return {"x":x, 
            "y":y,
            "hue":_hue,
            "upperAmountOfCogs":upperGear.amountOfCogs,
            "lowerAmountOfCogs":lowerGear.amountOfCogs};
    }

    public function get secondViewSide():TransferGearViewSide {
        return TransferGearViewSide(_secondViewSide);
    }

    public function updateIfNeeded():void {
         if(isMove){
             updateConflict();
             (TransferGearView (view)).updateCoords();
             view.update();
             (TransferGearView (view)).updateNextAndPrevious();
         }
    }
    
    public function updateConflict():void{
        for(var i:int=0; i<transmissionMechanism.transferGearList.length; i++){
            var tg:TransferGear = transmissionMechanism.transferGearList[i];
            if(tg == this){
                continue;
            }
            if(getRadius()>=MathUtils.distance(tg.x,  tg.y, x, y)){
                _conflict=true;
                return;
            }
        }
        _conflict=false;
    }


    public function get conflict():Boolean {
        return _conflict;
    }
}
}
