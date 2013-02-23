
package ru.ipo.kio._13.clock.view {
import flash.events.MouseEvent;

import ru.ipo.kio._13.clock.ClockSprite;
import ru.ipo.kio._13.clock.model.SettingsHolder;
import ru.ipo.kio._13.clock.model.TransferGear;
import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.utils.ColorGenerator;

public class TransmissionMechanismView extends BasicView {

    private var _transmissionMechanism:TransmissionMechanism;

    public function TransmissionMechanismView(transmissionMechanism:TransmissionMechanism) {
     _transmissionMechanism = transmissionMechanism;

     addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void{
         if(e.ctrlKey){
            transmissionMechanism.addTransferGear(new TransferGear(transmissionMechanism, e.stageX, e.stageY, 20, 10, ColorGenerator.nextHueOfColor(transmissionMechanism.transferGearList)));
            transmissionMechanism.transferGearList[transmissionMechanism.transferGearList.length-1].view.update();
         }else{
             if(transmissionMechanism.getByCoord(e.stageX-parent.x-parent.parent.x-100, e.stageY-parent.y-parent.parent.y)==null){
                 transmissionMechanism.deactivateAll();
             }
         }
     });
        update();
    }

    public override function update():void{
        graphics.clear();
        graphics.lineStyle(1, 0x000000);
     graphics.beginFill(0xffffff);
     graphics.drawRect(0,0,680,400);
     graphics.endFill();
        
        if(transmissionMechanism.transferGearList.length>0 && transmissionMechanism.isFinished()){
            if(ClockSprite.instanse.level==0){
                graphics.drawRect(transmissionMechanism.getMinX(),transmissionMechanism.getMinY(),
                        transmissionMechanism.getMaxX()-transmissionMechanism.getMinX(),
                        transmissionMechanism.getMaxY()-transmissionMechanism.getMinY());
            }else if (ClockSprite.instanse.level==1){
                graphics.drawCircle(transmissionMechanism.getCenter().x,transmissionMechanism.getCenter().y,
                        transmissionMechanism.getR());
            }else{
                graphics.drawCircle(transmissionMechanism.firstGear.x,transmissionMechanism.firstGear.y,
                        transmissionMechanism.getR1());
            }
        }
        
      for(var i:int=0; i<transmissionMechanism.transferGearList.length; i++){
          transmissionMechanism.transferGearList[i].updateConflict();
        transmissionMechanism.transferGearList[i].view.update();
     }
    }

    public function get transmissionMechanism():TransmissionMechanism {
        return _transmissionMechanism;
    }
    
    private var view:BasicView;

    public function transferGearAdded(transferGear:TransferGear, transferGear2:TransferGear=null):void {
      if(SettingsHolder.instance.direction==SettingsHolder.DOWN_TO_UP){
        if(transferGear.isFirst()){
            view = transferGear.lowerGear.view;
            (TransferGearView(transferGear.view)).childView= GearView(view);
            addChild(transferGear.lowerGear.view);
            addChild(transferGear.view);
        }else{
          if(transferGear2!=null){
              addChildAt(transferGear.view,getChildIndex(transferGear2.view)+1);
          }else{
              addChildAt(transferGear.view, numChildren-1);
          }
          }
      }else{
        if(transferGear.isFirst()){
            view = transferGear.lowerGear.view;
            addChild(transferGear.lowerGear.view);
            (TransferGearView(transferGear.view)).childView= GearView(view);
        }
          if(transferGear2!=null){
            addChildAt(transferGear.view,getChildIndex(transferGear2.view));
          }else{
            addChildAt(transferGear.view,1);
          }
      }
      transferGear.view.update();
      ClockSprite.instanse.update();
    }
    
    public function removeView():void{
        if(view!=null){
            removeChild(view);
            view = null;
        }                   
    }

    public function transferGearRemoved(transferGear:TransferGear):void {
       removeChild(transferGear.view);
    }
}
}
