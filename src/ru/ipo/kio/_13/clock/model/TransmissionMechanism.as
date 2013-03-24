/**
 *
 * @author: Vasiliy
 * @date: 31.12.12
 */
package ru.ipo.kio._13.clock.model {
import ru.ipo.kio._13.clock.ClockProblem;

import ru.ipo.kio._13.clock.ClockSprite;
import ru.ipo.kio._13.clock.utils.ColorGenerator;

import ru.ipo.kio._13.clock.view.TransmissionMechanismView;
import ru.ipo.kio._13.clock.view.TransmissionMechanismViewSide;
import ru.ipo.kio.api.KioApi;

public class TransmissionMechanism {

    public static const VERY_FAST_SPEED:int = 3;

    public static const VERY_SLOW_SPEED:int = 4;

    public static const FAST_SPEED:int = 0;

    public static const SLOW_SPEED:int = 1;

    public static const MIDDLE_SPEED:int = 2;

    private var _transferGearList:Vector.<TransferGear> = new Vector.<TransferGear>();

    private var _view:TransmissionMechanismView;

    private var _viewSide:TransmissionMechanismViewSide;

    private static var _instance:TransmissionMechanism;

    public static function clearInstance():void {
        _instance = null;
    }

    public static function get instance():TransmissionMechanism {
        if(TransmissionMechanism._instance == null)
            TransmissionMechanism._instance=new TransmissionMechanism(new PrivateClass( ));
        return _instance;
    }

    public function TransmissionMechanism(pvt:PrivateClass) {
        _view = new TransmissionMechanismView(this);
        _viewSide = new TransmissionMechanismViewSide(this);

    }
                       
    public function get leadingSimpleGear():SimpleGear{
        if(SettingsHolder.instance.isDownToUp()){
           return firstGear.lowerGear; 
        }else{
            return firstGear.upperGear;
        }
    }
    
    public function get lastDrivenSimpleGear():SimpleGear{
        var transferGear:TransferGear = getLastInChain();
        if(transferGear==null){
            return null;
        }
        if(SettingsHolder.instance.isDownToUp()){
            return transferGear.upperGear;
        }else{
            return transferGear.lowerGear;
        }
    }

    
    internal function getPrevious(transferGear:TransferGear):TransferGear{
        var index:int = getIndex(transferGear);
        if(index>0){
            return transferGearList[index-1];
        }else if(index ==0){
            return transferGearList[transferGearList.length-1];
        }
        return null;
    }

    internal function getNext(transferGear:TransferGear):TransferGear{
       var index:int = getIndex(transferGear);
        if(index>=0 && index<transferGearList.length-1){
            return transferGearList[index+1];
        }else if(index ==transferGearList.length-1){
            return transferGearList[0];
        }
        return null;
    }
    
    public function getIndex(transferGear:TransferGear):int{
        for(var i:int = 0; i<_transferGearList.length; i++){
            if(_transferGearList[i]==transferGear){
                return i;
            }
        }
        return -1;
    }
    

    public function addTransferGear(transferGear:TransferGear):void{
        _transferGearList.push(transferGear);
        view.transferGearAdded(transferGear);
        viewSide.transferGearAdded(transferGear);
      ClockSprite.instance.update();
    }


    public function addTransferGearAfter(transferGear:TransferGear):void {

        var newTG:TransferGear = new TransferGear(this, Math.min(transferGear.x+10,630), Math.min(transferGear.y+10,350), 10, 10, ColorGenerator.nextHueOfColor(transferGearList));
        KioApi.log(ClockProblem.ID, "CREATE AFTER @SS", newTG.id, transferGear.id);
        _transferGearList.splice(getIndex(transferGear)+1,0,newTG);
        view.transferGearAdded(newTG, transferGear);
        viewSide.transferGearAdded(newTG);
        ClockSprite.instance.update();
    }


    public function get transferGearList():Vector.<TransferGear> {
        return _transferGearList;
    }
    
    public function clear():void{
        viewSide.removeAdditional();
        while(_transferGearList.length>0){
            var tg:TransferGear = _transferGearList.splice(0, 1)[0];
            view.transferGearRemoved(tg);
            viewSide.removeChild(tg.viewSide);
        }
        view.removeView();
        view.update();

    }

    public function removeTransferGear(transferGear:TransferGear):void{
        var index:int = _transferGearList.indexOf(transferGear);
        _transferGearList.splice(index, 1);
        view.transferGearRemoved(transferGear);
        viewSide.transferGearRemoved(transferGear);
        ClockSprite.instance.update();

    }

    public function get view():TransmissionMechanismView {
        return _view;
    }

    public function get viewSide():TransmissionMechanismViewSide {
        return _viewSide;
    }

    public function getNextOfActive():TransferGear {
       var transferGear:TransferGear = getActive();
        if(transferGear!=null){
            return getNext(transferGear);
        }
        return null;
    }

    public function getPreviousOfActive():TransferGear {
        var transferGear:TransferGear = getActive();
        if(transferGear!=null){
            return getPrevious(transferGear);
        }
        return null;
    }

    public function getActive():TransferGear{
        for(var i:int = 0; i<_transferGearList.length; i++){
            if(_transferGearList[i].isActive){
                return _transferGearList[i];
            }
        }
        return null;
    }

    public function get absTransmissionError():Number{
        return Math.abs(transmissionNumber-SettingsHolder.instance.levelImpl.correctRatio);
    }

    public function get relTransmissionError():Number{
        return 100*(TransmissionMechanism.instance.absTransmissionError/SettingsHolder.instance.levelImpl.correctRatio);
    }
    
    private function get transmissionNumber():Number{
        var up:Number=1;
        var down:Number = 1;
        var temp:SimpleGear = leadingSimpleGear;
        while(temp!=null){
            if(temp.getDrivenGear()!=null && temp.isCrossedWithDriven()){
                up *= temp.amountOfCogs;
                temp = temp.getDrivenGear()
                down *= temp.amountOfCogs;
            }else{
                break;
            }
          if(temp!=null && temp.transferGear==firstGear){
            break;
          }
            temp = temp.other;
        }
        return up/down;
    }

    public function getMaxY():int{
        var max:Number = 0;
        for(var i:int = 0; i<_transferGearList.length; i++){
            var gear:TransferGear = _transferGearList[i];
            max = Math.max(gear.y+gear.getRadius(),max);
        }
        return max;
    }

    public function getMaxX():int{
        var max:Number = 0;
        for(var i:int = 0; i<_transferGearList.length; i++){
            var gear:TransferGear = _transferGearList[i];
            max = Math.max(gear.x+gear.getRadius(),max);
        }
        return max;
    }

    public function getMinY():int{
        var min:Number = Number.MAX_VALUE;
        for(var i:int = 0; i<_transferGearList.length; i++){
            var gear:TransferGear = _transferGearList[i];
            min = Math.min(gear.y-gear.getRadius(),min);
        }
        return min;
    }

    public function getMinX():int{
        var min:Number = Number.MAX_VALUE;
        for(var i:int = 0; i<_transferGearList.length; i++){
            var gear:TransferGear = _transferGearList[i];
            min = Math.min(gear.x-gear.getRadius(),min);
        }
        return min;
    }

    public function getCenter():Object {
        var distance:Number = 0;
        var first:TransferGear;
        var second:TransferGear;
        for(var i:int = 0; i<_transferGearList.length; i++){
            for(var j:int = 0; j<_transferGearList.length; j++){
                var gear1:TransferGear = _transferGearList[i];
                var gear2:TransferGear = _transferGearList[j];
                if(i ==0 && j ==0){
                    first=gear1;
                    second=gear2;
                }
                var nDistance:Number = Math.pow(Math.pow(gear1.x-gear2.x,2)+Math.pow(gear1.y-gear2.y,2), 1/2)
                        +gear1.getRadius()
                +gear2.getRadius();
                if(nDistance>distance){
                    first=gear1;
                    second=gear2;
                    distance=nDistance;
                }
            }
        }
        if(first==null){
                return {x:0,y:0};
        }else{
            if(first.x<second.x){
                var temp:TransferGear = first;
                first = second;
                second = temp;
            }

            var alpha:Number = Math.atan((first.y-second.y)/(first.x-second.x));

            var y :Number= (first.y+first.getRadius()*Math.sin(alpha)+second.y-second.getRadius()*Math.sin(alpha))/2;
            return {x:(first.x+first.getRadius()*Math.cos(alpha)+second.x-second.getRadius()*Math.cos(alpha))/2,
                y:y};
        }
    }
    
    public function getR():Number{
        var distance:Number = 0;
        for(var i:int = 0; i<_transferGearList.length; i++){
            for(var j:int = 0; j<_transferGearList.length; j++){
                var gear1:TransferGear = _transferGearList[i];
                var gear2:TransferGear = _transferGearList[j];
                distance = Math.max(
                        Math.pow(Math.pow(gear1.x-gear2.x,2)+Math.pow(gear1.y-gear2.y,2), 1/2)
                                +gear1.getRadius()
                                +gear2.getRadius(),
                        distance);
            }
        }
        return distance/2;
     }


    public function getR1():Number{
        var distance:Number = 0;
        for(var i:int = 0; i<_transferGearList.length; i++){
                var gear:TransferGear = firstGear;
                var gear1:TransferGear = _transferGearList[i];
                distance = Math.max(
                        Math.pow(Math.pow(gear1.x-gear.x,2)+Math.pow(gear1.y-gear.y,2), 1/2)
                                +gear1.getRadius(),
                        distance);
            
        }
        return distance;
    }
    
    public function get square():Number{

        if(SettingsHolder.instance.levelImpl.level==0){
            return (getMaxX()-getMinX())*(getMaxY()-getMinY());
        }else if(SettingsHolder.instance.levelImpl.level==1){
            var radius:Number = getR();
            return Math.PI*(radius)*(radius);
        }else{
            var radius1:Number = getR1();
            return Math.PI*(radius1)*(radius1);
        }
    }

    public function deactivateAll():void{
        for(var i:int = 0; i<_transferGearList.length; i++){
                _transferGearList[i].isActive=false;
        }
        for(var j:int = 0; j<_transferGearList.length; j++){
            _transferGearList[j].isActive=false;
        }
    }

    public function get firstGear():TransferGear {
        return _transferGearList.length>0?_transferGearList[0]:null;
    }

    public function getByCoord(localX:Number, localY:Number):TransferGear {
        for(var i:int = 0; i<_transferGearList.length; i++){
            var gear:TransferGear = _transferGearList[i];
            if(localX>gear.x-gear.getRadius()&&localX<gear.x+gear.getRadius()&&
                    localY>gear.y-gear.getRadius() && localY<gear.y+gear.getRadius()){
            return gear;
            }
        } 
        return null;
    }
    
    private function getLastInChain():TransferGear{
        var step:Number = 1;
        var last:TransferGear = firstGear;
        for(var i:int = 1; i<_transferGearList.length; i++){
            var transferGear:TransferGear = _transferGearList[i-1];
            var gear:SimpleGear = transferGear.lowerGear.isDrive()?transferGear.lowerGear:transferGear.upperGear;
            if(gear.isCrossedWithDriven()){
                step = gear.amountOfCogs/gear.getDrivenGear().amountOfCogs*step;
                last = gear.getDrivenGear().transferGear;
                if(i == _transferGearList.length-1){
                    transferGear = _transferGearList[i];
                    gear = transferGear.lowerGear.isDrive()?transferGear.lowerGear:transferGear.upperGear;
                    if(gear.isCrossedWithDriven()){
                        step = gear.amountOfCogs/gear.getDrivenGear().amountOfCogs*step
                        last = gear.getDrivenGear().transferGear;
                    }
                }
            }else{
                return last;
            }
        }
        return last;
    }
    
    public function isFinished():Boolean{
        return getLastInChain()==firstGear && leadingSimpleGear.isCrossedWithDriven();
    }

    private function getFastestMultiple():Number {
        var step:Number = 1;
        var fastestMultiple:Number = 1;
        for(var i:int = 1; i<_transferGearList.length; i++){
            var transferGear:TransferGear = _transferGearList[i-1];
            var gear:SimpleGear = transferGear.lowerGear.isDrive()?transferGear.lowerGear:transferGear.upperGear;
            if(gear.isCrossedWithDriven()){
                step = gear.amountOfCogs/gear.getDrivenGear().amountOfCogs*step;
                fastestMultiple=Math.max(fastestMultiple,step);        
                if(i == _transferGearList.length-1){
                    transferGear = _transferGearList[i];
                    gear = transferGear.lowerGear.isDrive()?transferGear.lowerGear:transferGear.upperGear;
                    if(gear.isCrossedWithDriven()){
                        step = gear.amountOfCogs/gear.getDrivenGear().amountOfCogs*step
                        fastestMultiple=Math.max(fastestMultiple,step);
                    }
                }
            }else{
                return fastestMultiple;
            }
        }
        return fastestMultiple;
    }
    
    public function isConflict():Boolean{
        for(var i:int=0; i <transferGearList.length; i++){
            if(transferGearList[i].conflict){
                return true;
            }
        }
        return false;
    }

    public function rotate(number:Number):void {
        if(isConflict()){
            ClockSprite.instance.showError(KioApi.getLocalization(ClockProblem.ID).messages.play_crash);
            if(play){
                playStop();
            }
            return;
        }
        var fastest:Number = getFastestMultiple();
        var step:Number = Math.PI/(10*2.1*fastest);
        if(SettingsHolder.instance.stepRotate==FAST_SPEED){
            step *= 1;
        }else if(SettingsHolder.instance.stepRotate==SLOW_SPEED){
            step/=10;
        }else if(SettingsHolder.instance.stepRotate==VERY_FAST_SPEED){
            step*=5;
        }else if(SettingsHolder.instance.stepRotate==VERY_SLOW_SPEED){
            step/=15;
        }else if (SettingsHolder.instance.stepRotate==MIDDLE_SPEED){
            step/=5;
        }
        firstGear.alpha-=step;
        for(var i:int = 1; i<_transferGearList.length; i++){
            var transferGear:TransferGear = _transferGearList[i-1];
            var gear:SimpleGear = transferGear.lowerGear.isDrive()?transferGear.lowerGear:transferGear.upperGear;
            if(gear.isCrossedWithDriven()){
                step = gear.amountOfCogs/gear.getDrivenGear().amountOfCogs*step
                gear.getDrivenGear().transferGear.alpha+=Math.pow(-1,i+1)*step;
                if(i == _transferGearList.length-1){
                    transferGear = _transferGearList[i];
                    gear = transferGear.lowerGear.isDrive()?transferGear.lowerGear:transferGear.upperGear;
                    if(gear.isCrossedWithDriven()){
                        step = gear.amountOfCogs/gear.getDrivenGear().amountOfCogs*step
                        gear.getDrivenGear().alpha+=Math.pow(-1,i)*step;
                    }
                }
            }else{
                break;
            }
        }

        view.update();
        viewSide.update();
        SettingsHolder.instance.levelImpl.updateProductSprite();
    }

    public function resetAlpha():void {
        for(var i:int = 0; i<_transferGearList.length; i++){
            _transferGearList[i].alpha=Math.PI+Math.pow(10,-10);
          _transferGearList[i].upperGear.alpha=Math.PI+Math.pow(10,-10);
          _transferGearList[i].lowerGear.alpha=Math.PI+Math.pow(10,-10);

        }
        SettingsHolder.instance.levelImpl.updateProductSprite();
        }
    
    private var play:Boolean = false;

    public function playStop():void {
        play = !play;
        deactivateAll();
      ClockSprite.instance.updateAnimateButtons();
    }

    public function innerTick():void {
        if(play){
            rotate(SettingsHolder.instance.stepRotateInRadians);
        }
        var ac:TransferGear = getActive();
        if(ac!=null){
            ac.updateIfNeeded();
        }
    }

  public function isPlay():Boolean {
    return play;
  }

   public function isCorrectDirection():Boolean {
       var amountInChain:int;
       var lastInChain:TransferGear = getLastInChain();
       if(lastInChain==firstGear){
           amountInChain=_transferGearList.length;
       }else{
          amountInChain = getIndex(lastInChain)+1;
       }
        return (isFinished() && amountInChain%2==0) ||
                (!isFinished() && amountInChain%2==1);
    }
}
}

internal class PrivateClass{
    public function PrivateClass(){
    }
}
