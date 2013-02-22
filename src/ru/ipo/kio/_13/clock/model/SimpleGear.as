 package ru.ipo.kio._13.clock.model {


import ru.ipo.kio._13.clock.view.BasicView;
import ru.ipo.kio._13.clock.view.GearView;

 /**
  * This is a simple gear - a part if transfer gear
  * It is characterized by amount of cogs and part (low or upper)
  */
 public class SimpleGear {
    
    public static const LOWER_PART:int = 0;

    public static const UPPER_PART:int = 1;

    private var _part:int;

    private var _amountOfCogs:int;

    private var _selfAlpha:Number = Math.PI+Math.pow(10,-10);

    private var _transferGear:TransferGear;
    
    private var _view:BasicView;
    
    private var _color:int;
    
    public function SimpleGear(transferGear:TransferGear, amountOfCogs:int, part:int, color:int){
        _transferGear = transferGear;
        _color = color;
        _part=part;
        _view = new GearView(this);
        this.amountOfCogs = amountOfCogs;
    }

     public function get view():BasicView {
         return _view;
     }

     public function get transferGear():TransferGear {
         return _transferGear;
     }

     public function get part():int {
         return _part;
     }

     public function get color():int {
        return _color;
    }

    public function get amountOfCogs():int {
        return _amountOfCogs;
    }

    public function get innerRadius():int {
        return SettingsHolder.instance.sizeOfCog/(2*(Math.sin(Math.PI/_amountOfCogs)));
    }

    public function get outerRadius():int{
        var alpha:Number = Math.PI*2/amountOfCogs;
        return innerRadius*Math.cos(alpha/2)+SettingsHolder.instance.sizeOfCog*Math.sqrt(3)/2;
    }

    public function set innerRadius(value:int):void {
        amountOfCogs = Math.PI/Math.asin(SettingsHolder.instance.sizeOfCog/(value*2));
    }

    public function set amountOfCogs(value:int):void {
        _amountOfCogs = value;
       view.update();
    }


    public function getDrivenGear():SimpleGear{
        if(transferGear.isFirst()){
            if(SettingsHolder.instance.isDownToUp() && part == LOWER_PART){
                return transferGear.getNextTransferGear().lowerGear;
            }else if (!SettingsHolder.instance.isDownToUp() && part == UPPER_PART){
                return transferGear.getNextTransferGear().upperGear;
            }
        }else{
            if(SettingsHolder.instance.isDownToUp() && part == UPPER_PART){
                if(transferGear.getNextTransferGear().isFirst()){
                    return transferGear.getNextTransferGear().upperGear; 
                }else{
                    return transferGear.getNextTransferGear().lowerGear;
                }
            }else if (!SettingsHolder.instance.isDownToUp() && part == LOWER_PART){
                if(transferGear.getNextTransferGear().isFirst()){
                    return transferGear.getNextTransferGear().lowerGear;
                }else{
                    return transferGear.getNextTransferGear().upperGear;
                }
            }
        }
        return null;
    }

    public function isDrive():Boolean{
        if(transferGear.isFirst()){
            return (SettingsHolder.instance.isDownToUp() && part == LOWER_PART) ||
                   (!SettingsHolder.instance.isDownToUp() && part == UPPER_PART);
        }else{
            return (SettingsHolder.instance.isDownToUp() && part == UPPER_PART) ||
                    (!SettingsHolder.instance.isDownToUp() && part == LOWER_PART);
        }
    }

    public function canBeCrossed():Boolean {
    return (transferGear.isActive) ||
          (TransmissionMechanism.instance.getNextOfActive()==transferGear && !isDrive())
        ||(TransmissionMechanism.instance.getPreviousOfActive()==transferGear && isDrive())
    }

    public function isCrossedWithDriven():Boolean {
        var connectedGear:SimpleGear = getDrivenGear();

        if(connectedGear==null){
            return false;
        }

        var distance:Number = Math.sqrt(Math.pow(transferGear.x-connectedGear.transferGear.x,2)+
                Math.pow(transferGear.y-connectedGear.transferGear.y,2));

        return  bigCrossRadius+connectedGear.bigCrossRadius>distance &&
                smallCrossRadius+connectedGear.smallCrossRadius<distance;

    }


    public function isCrossed():Boolean {
        var connectedGear:SimpleGear = getDrivenGear();
        if(connectedGear==null){
            if(transferGear.getPreviousTransferGear().upperGear.getDrivenGear()==this){
                connectedGear=transferGear.getPreviousTransferGear().upperGear;
            }else{
                connectedGear=transferGear.getPreviousTransferGear().lowerGear;
            }
        }
        
        var distance:Number = Math.sqrt(Math.pow(transferGear.x-connectedGear.transferGear.x,2)+
                Math.pow(transferGear.y-connectedGear.transferGear.y,2));

        return  bigCrossRadius+connectedGear.bigCrossRadius>distance&&
                smallCrossRadius+connectedGear.smallCrossRadius<distance;
    }

    public function get smallCrossRadius():Number{
        var diffRadius:Number = outerRadius-innerRadius;
        return innerRadius+SettingsHolder.instance.crossZone/100*diffRadius;
   }

    public function get bigCrossRadius():Number{
        var diffRadius:Number = outerRadius-innerRadius;
        return outerRadius-SettingsHolder.instance.crossZone/100*diffRadius;
    }

    public function set alpha(value:Number):void {
      while(value>Math.PI*2){
        value -=Math.PI*2;
      }
      while(value<0){
        value+=Math.PI*2;
      }
      _selfAlpha=value;
    }

    public function get alpha():Number {
        if(transferGear.isFirst()&&
           ((part == LOWER_PART && SettingsHolder.instance.direction==SettingsHolder.UP_TO_DOWN ) ||
                   (part == UPPER_PART && SettingsHolder.instance.direction==SettingsHolder.DOWN_TO_UP ))){
            return _selfAlpha;
        }else{
            return transferGear.alpha;
        }
    }

    public function get other():SimpleGear {
        return (part == UPPER_PART) ? transferGear.lowerGear : transferGear.upperGear;
    }
}
}
