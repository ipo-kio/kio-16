/**
 *
 * @author: Vasiliy
 * @date: 01.01.13
 */
package ru.ipo.kio._13.clock.view {
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.ui.KeyboardType;

import mx.events.DragEvent;

import ru.ipo.kio._13.clock.ClockProblem;
import ru.ipo.kio._13.clock.ClockSprite;

import ru.ipo.kio._13.clock.model.SimpleGear;
import ru.ipo.kio._13.clock.model.SettingsHolder;
import ru.ipo.kio._13.clock.model.TransferGear;
import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio.api.KioApi;

public class TransferGearView extends BasicView {
    
    public static var FIELD_WIDTH:int = 20;

    public static var FIELD_HEIGHT:int = 20;
   
    private var _transferGear:TransferGear;

    private var _firstField:TextField;

    private var _secondField:TextField;

    private var _locked:Boolean = false;
    
    private var _shiftX:int;
    
    private var _shiftY:int;
    
    private var _childView:GearView;

    public function TransferGearView(transferGear:TransferGear) {
        _transferGear=transferGear;


        if(transferGear.transmissionMechanism.transferGearList.length==0){
            if(SettingsHolder.instance.isDownToUp()){
                addChild(transferGear.upperGear.view);
            }else{
                addChild(transferGear.upperGear.view);
            }
        }else{
            addChild(transferGear.lowerGear.view);
            addChild(transferGear.upperGear.view);
        }

        _firstField = createField(true);
        _secondField = createField(false);

        /*addEventListener(DragEvent.DRAG_EXIT, function(e:Event):void{
            if(transferGear.isMove){
                //var center:Point = new Point(e.stageX-parent.x-parent.parent.x, e.stageY-parent.parent.y);

                //transferGear.x = center.x-_shiftX;
                //transferGear.y = center.y-_shiftY;
                update();
                updateNextAndPrevious();
            }

        });*/

        addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
            if(e.charCode==27){
                _locked=false;
                transferGear.isActive=false;
                update();
            }
        }) ;

        addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
            if(_locked){
                return;
            }
            transferGear.transmissionMechanism.deactivateAll();
            transferGear.isMove=true;
            transferGear.isActive=true;
            updateNextAndPrevious();
            _shiftX= e.localX;
            _shiftY= e.localY;
            //if(!transferGear.isFirst()){
            KioApi.instance(ClockProblem.ID).log("START DRAG", transferGear.id, transferGear.x, transferGear.y);
            startDrag(false, new Rectangle(transferGear.getRadius()+5,transferGear.getRadius(),
                        675-transferGear.getRadius()*2,400-transferGear.getRadius()*2));
            //}

        });

        addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void{
            if(!transferGear.isMove){
                return;
            }
            var center:Point = new Point(e.stageX-parent.x-parent.parent.x,  e.stageY-parent.parent.y);
            transferGear.x = center.x-_shiftX;
            transferGear.y = center.y-_shiftY;
            if(transferGear.x<transferGear.getRadius()+5){
                transferGear.x = transferGear.getRadius()+5;
            }
            if(transferGear.y<transferGear.getRadius()){
                transferGear.y = transferGear.getRadius();
            }
            if(transferGear.x>transferGear.getRadius()+5+675-transferGear.getRadius()*2){
                transferGear.x = transferGear.getRadius()+5+675-transferGear.getRadius()*2;
            }
            if(transferGear.y>transferGear.getRadius()+400-transferGear.getRadius()*2){
                transferGear.y = transferGear.getRadius()+400-transferGear.getRadius()*2;
            }

            transferGear.isMove=false;
            //if(!transferGear.isFirst()){
            KioApi.instance(ClockProblem.ID).log("STOP DRAG", transferGear.id, transferGear.x, transferGear.y);
                stopDrag();
            //}
            updateNextAndPrevious();
            transferGear.transmissionMechanism.view.update();
            ClockSprite.instanse.update();
            transferGear.transmissionMechanism.viewSide.rebuild();
        });
    }


    public function updateNextAndPrevious():void {
        var nextTransferGear:TransferGear = transferGear.getNextTransferGear();
        var previousTransferGear:TransferGear = transferGear.getPreviousTransferGear();
        if (nextTransferGear != null) {
            nextTransferGear.view.update();
        }
        if (previousTransferGear != null) {
            previousTransferGear.view.update();
        }
    }

    private function createField(upper:Boolean):TextField {
        var field:TextField = new TextField();
        disableField(field);
        field.width = FIELD_WIDTH;
        field.height = FIELD_HEIGHT;
        addChild(field);
        field.addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void{
           // if(field.border==true){
            transferGear.transmissionMechanism.deactivateAll();
            if(transferGear.transmissionMechanism.isPlay()){
                transferGear.transmissionMechanism.playStop();
            }
            _locked=true;
            transferGear.isActive=true;
                update();

            //}
        });

        field.addEventListener(MouseEvent.MOUSE_UP, function(e:Event):void{
            field.setSelection(0,field.text.length);
        });
        field.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void{
            if(e.charCode==13){
                var newValue:int = new Number(field.text);
                KioApi.instance(ClockProblem.ID).log("VIEW1 INPUT "+upper?"UP":"DOWN", transferGear.id, newValue);
                if(newValue<8){
                    ClockSprite.instanse.showError(KioApi.getLocalization(ClockProblem.ID).messages.tooSmall);
                    return;
                }
                if(newValue>40){
                    ClockSprite.instanse.showError(KioApi.getLocalization(ClockProblem.ID).messages.tooBig);
                    return;
                }
                if(upper){
                    if(Math.max(newValue,transferGear.lowerGear.amountOfCogs)/Math.min(newValue,transferGear.lowerGear.amountOfCogs)>
                            SettingsHolder.instance.maxDiv){
                        ClockSprite.instanse.showError(KioApi.getLocalization(ClockProblem.ID).messages.tooBigDiv+""+
                                SettingsHolder.instance.maxDiv);
                        return;
                    }
                    transferGear.upperGear.amountOfCogs=newValue;
                    transferGear.transmissionMechanism.viewSide.rebuild();
                }
                else{
                    if(Math.max(newValue,transferGear.upperGear.amountOfCogs)/Math.min(newValue,transferGear.upperGear.amountOfCogs)>
                            SettingsHolder.instance.maxDiv){
                        ClockSprite.instanse.showError(KioApi.getLocalization(ClockProblem.ID).messages.tooBigDiv+""+
                                SettingsHolder.instance.maxDiv);
                        return;
                    }
                    transferGear.lowerGear.amountOfCogs=newValue;
                    transferGear.transmissionMechanism.viewSide.rebuild();
                }
                _locked=false;
                transferGear.updateConflict();
                update();
                ClockSprite.instanse.update();
            }else if(e.charCode==27){
                _locked=false;
                update();
            }
        });
        return field;
    }
    
    public override function update():void{
        graphics.clear();
        if(!transferGear.isActive){
            _locked=false;
        }
        if(_locked){
            _firstField.borderColor=0xFF0000;
            _secondField.borderColor=0xFF0000;
        }else{
            _firstField.borderColor=0x000000;
            _secondField.borderColor=0x000000;
        }

        if(transferGear.conflict){
            graphics.beginFill(0xff0000,0.5);
        }else{
            graphics.beginFill(0x000000,0);
        }
        graphics.drawCircle(0,0,transferGear.getRadius());
        graphics.endFill();

        if(!transferGear.isMove){
            x = transferGear.x;
            y = transferGear.y;
        }
        transferGear.lowerGear.view.update();
        transferGear.upperGear.view.update();
        
        _firstField.y = -transferGear.upperGear.innerRadius;
        _firstField.x = -FIELD_WIDTH/2;
        _firstField.text = ""+transferGear.upperGear.amountOfCogs;
        
        _secondField.y = transferGear.lowerGear.outerRadius-30;
        _secondField.x = -FIELD_WIDTH/2;
        _secondField.text = ""+transferGear.lowerGear.amountOfCogs;

        if(_childView!=null){
            _childView.x = x;
            _childView.y = y;
        }

        if(transferGear.isActive){
              enableField(_firstField);
            enableField(_secondField);

        }else{
            disableField(_firstField);
            disableField(_secondField);
        }

    }

    private function disableField(field:TextField):void {
        field.border = false;
        field.type = TextFieldType.DYNAMIC;
        field.selectable = false;
        field.background=false;
         }

    private function enableField(field:TextField):void {
        field.border = true;
        field.type = TextFieldType.INPUT;
        field.selectable = true;
        field.backgroundColor=0xDDDDDD;
        field.background=true;
    }

    public function get transferGear():TransferGear {
        return _transferGear;
    }

    public function set childView(childView:GearView):void {
        _childView = childView;
    }


    public function updateCoords():void {
        transferGear.x = x;
        transferGear.y = y;
    }
}
}
