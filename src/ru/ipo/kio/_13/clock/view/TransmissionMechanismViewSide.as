
package ru.ipo.kio._13.clock.view {
import flash.events.MouseEvent;

import ru.ipo.kio._13.clock.ClockSprite;
import ru.ipo.kio._13.clock.model.SimpleGear;
import ru.ipo.kio._13.clock.model.SettingsHolder;
import ru.ipo.kio._13.clock.model.TransferGear;
import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.utils.ColorGenerator;

public class TransmissionMechanismViewSide extends BasicView {

    private var _transmissionMechanism:TransmissionMechanism;

    public function TransmissionMechanismViewSide(transmissionMechanism:TransmissionMechanism) {
     _transmissionMechanism = transmissionMechanism;

     addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
         /*if(e.ctrlKey){
            transmissionMechanism.addTransferGear(new TransferGear(transmissionMechanism, e.stageX, e.stageY, 20, 10, ColorGenerator.nextHueOfColor(transmissionMechanism.transferGearList)));
            transmissionMechanism.transferGearList[transmissionMechanism.transferGearList.length-1].view.update();
         }else{
             if(transmissionMechanism.getByCoord(e.stageX, e.stageY)==null){
                 transmissionMechanism.deactivateAll();
             }
         } */
     });
        update();
    }

    public override function update():void{
        graphics.clear();
        graphics.lineStyle(1, 0x000000);
     graphics.beginFill(0xffffff);
     graphics.drawRect(0,0,680,200);
     graphics.endFill();
      for(var i:int=0; i<transmissionMechanism.transferGearList.length; i++){
        transmissionMechanism.transferGearList[i].viewSide.update();
          if(transmissionMechanism.transferGearList[i].secondViewSide!=null){
            transmissionMechanism.transferGearList[i].secondViewSide.update();
          }
     }
    }

    public function get transmissionMechanism():TransmissionMechanism {
        return _transmissionMechanism;
    }
    
    private var _koeffX:Number = 1;
    
    public function rebuild():void{
        var first1:SimpleGear = transmissionMechanism.firstGear.upperGear.isDrive()?transmissionMechanism.firstGear.upperGear:
                transmissionMechanism.firstGear.lowerGear;

        var distance1:Number = first1.outerRadius;
        var distance:Number = distance1;

        (TransferGearViewSide(transmissionMechanism.firstGear.viewSide)).viewX=distance;

        var first:SimpleGear = first1;
        distance+=distance1;

        do{
          if(!first.transferGear.upperGear.isCrossedWithDriven()&&
              !first.transferGear.lowerGear.isCrossedWithDriven()){
            distance+=10;
          }
            var temp:SimpleGear = first.getDrivenGear();
            if(temp == null){
                temp = (first == first.transferGear.lowerGear)?
                        first.transferGear.upperGear.getDrivenGear():
                        first.transferGear.lowerGear.getDrivenGear() ;
                if(temp == null){
                    break;
                }
            }
            first = temp;
            distance+=first.outerRadius;
            (TransferGearViewSide(first.transferGear.viewSide)).viewX=distance;
            distance+=first.other.outerRadius;
        }while(first.transferGear.getNextTransferGear()!=first1.transferGear)
        if(transmissionMechanism.firstGear.secondViewSide!=null){
            if(transmissionMechanism.isFinished()){
                if(SettingsHolder.instance.isDownToUp()){
                    distance+=first1.transferGear.upperGear.outerRadius;
                }else{
                    distance+=first1.transferGear.lowerGear.outerRadius;
                }
            }
            transmissionMechanism.firstGear.secondViewSide.viewX2=distance;
            addChild(transmissionMechanism.firstGear.secondViewSide);
        }
        if(transmissionMechanism.isFinished()){
            distance+=first1.transferGear.getRadius();
        }else{
            if(transmissionMechanism.firstGear.secondViewSide!=null){
                removeChild(transmissionMechanism.firstGear.secondViewSide);
            }
        }

        _koeffX = 590/distance;
        update();
    }
    
    public function transferGearAdded(transferGear:TransferGear):void {
      addChild(transferGear.viewSide);
      rebuild();
    }
    

    public function transferGearRemoved(transferGear:TransferGear):void {
       removeChild(transferGear.viewSide);
       rebuild();
    }

    public function get koeffX():Number {
        return _koeffX;
    }

    public function removeAdditional():void {

        if(transmissionMechanism.firstGear.secondViewSide!=null){
            removeChild(transmissionMechanism.firstGear.secondViewSide);
        }
    }
}
}
