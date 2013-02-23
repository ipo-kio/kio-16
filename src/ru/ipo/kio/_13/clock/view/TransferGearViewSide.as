/**
 *
 * @author: Vasiliy
 * @date: 01.01.13
 */
package ru.ipo.kio._13.clock.view {
import avmplus.implementsXml;

import flash.display.Sprite;

import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.text.TextField;
import flash.text.TextFieldType;

import ru.ipo.kio._13.clock.ClockProblem;

import ru.ipo.kio._13.clock.ClockSprite;
import ru.ipo.kio._13.clock.model.SimpleGear;
import ru.ipo.kio._13.clock.model.SettingsHolder;
import ru.ipo.kio._13.clock.model.TransferGear;
import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.base.displays.SettingsDisplay;

public class TransferGearViewSide extends BasicView {
    
    public static var FIELD_WIDTH:int = 20;

    public static var FIELD_HEIGHT:int = 20;
   
    private var _transferGear:TransferGear;

    private var _firstField:TextField;

    private var _secondField:TextField;

    private var _viewX:Number;

    private var _second:Boolean;
    
    private var _addSprite:Sprite = new Sprite();

    public function TransferGearViewSide(transferGear:TransferGear, second:Boolean=false) {
        _transferGear=transferGear;
        _second = second;


            _firstField = createField(true);
            _secondField = createField(false);

        if(!_second){
        addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void{
            if(_activeSprite){
                return;
            }
            transferGear.transmissionMechanism.deactivateAll();
            transferGear.isActive=true;
            (TransferGearView(transferGear.view)).updateNextAndPrevious();
            if(transferGear.transmissionMechanism.isPlay()){
                transferGear.transmissionMechanism.playStop();
            }
            //startDrag(false, new Rectangle(0,0,800,500));
        });
            
            addChild(_addSprite);

            _addSprite.addEventListener(MouseEvent.ROLL_OVER, function(e:Event):void{
                _activeSprite = true;
                redrawSprite();
            });

            _addSprite.addEventListener(MouseEvent.ROLL_OUT, function(e:Event):void{
                _activeSprite = false;
                redrawSprite();
            });

            _addSprite.addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void{
                TransmissionMechanism.instance.addTransferGearAfter(transferGear);
            });
        }

    }
    
    private var _activeSprite:Boolean = false;


    private function createField(upper:Boolean):TextField {
        var field:TextField = new TextField();
        disableField(field);
        field.width = FIELD_WIDTH;
        field.height = FIELD_HEIGHT;
        if(!_second){
            addChild(field);
        }
        field.addEventListener(MouseEvent.MOUSE_DOWN, function(e:Event):void{
            if(field.border==true){
                if(transferGear.transmissionMechanism.isPlay()){
                    transferGear.transmissionMechanism.playStop();
                }
                update();
            }
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
                update();
                ClockSprite.instanse.update();
            }else if(e.charCode==27){
                update();
            }
        });
        return field;
    }

    public function set viewX(viewX:Number):void {
        _viewX = viewX;
    }
  
  private var h:int=10;
    private var _viewX2:Number;
    
    public override function update():void{
        graphics.clear();
        _firstField.borderColor=0x000000;
        _secondField.borderColor=0x000000;

      h = 150/transferGear.transmissionMechanism.transferGearList.length;
      
        var k:Number = transferGear.transmissionMechanism.viewSide.koeffX;

        graphics.lineStyle(1,0x555555);

        drawGear(transferGear.upperGear, k, 0);

        if(transferGear.isFirst()){
          drawGear(transferGear.lowerGear, k, h*(transferGear.transmissionMechanism.transferGearList.length-1));
        }else{
          drawGear(transferGear.lowerGear, k, h);
        }


        graphics.moveTo(0,-10);
        graphics.lineTo(0,0);

        if(transferGear.isFirst()){
            graphics.moveTo(0,h);
            graphics.lineTo(0,h*(transferGear.transmissionMechanism.transferGearList.length-1));

            graphics.moveTo(0,h*(transferGear.transmissionMechanism.transferGearList.length-1)+h);
            graphics.lineTo(0,h*(transferGear.transmissionMechanism.transferGearList.length-1)+h+10);
        }else{
            graphics.moveTo(0,h*2);
            graphics.lineTo(0,h*2+10);
        }

        x = _viewX*k+30;
        if(transferGear.isFirst() && _second){
          x =  _viewX2*k+30;
        }
        


        y = 10+10+h*(transferGear.transmissionMechanism.getIndex(transferGear)-1);
        if(transferGear.isFirst()){
            y=10+10;
        }
        if(SettingsHolder.instance.isDownToUp()){
            y = 170-h*(transferGear.transmissionMechanism.getIndex(transferGear)+1);
            if(transferGear.isFirst()){
                y=10+10;
            }
        }
        
        redrawSprite();
        _firstField.y = -20;
        _firstField.x = -FIELD_WIDTH;
        _firstField.text = ""+transferGear.upperGear.amountOfCogs;
        
        _secondField.y = h*2;
        if(transferGear.isFirst()){
            _secondField.y = h*(transferGear.transmissionMechanism.transferGearList.length);
        }
        _secondField.x = -FIELD_WIDTH;
        _secondField.text = ""+transferGear.lowerGear.amountOfCogs;


        if(transferGear.isActive){
              enableField(_firstField);
            enableField(_secondField);

        }else{
            disableField(_firstField);
            disableField(_secondField);
        }

    }

    private function redrawSprite():void {
        var k:Number = transferGear.transmissionMechanism.viewSide.koeffX;
        _addSprite.x = transferGear.getRadius() * k - 2;
        _addSprite.graphics.clear();
        
        if(_activeSprite){
            _addSprite.graphics.lineStyle(2, 0xf754e1, 0.7);
        }else{
            _addSprite.graphics.lineStyle(2, 0xf754e1,0.1);
        }
        _addSprite.graphics.moveTo(1, -y+10);
        _addSprite.graphics.lineTo(1, 180 - y);
        var drawUp:Boolean = y+h>100;

        var startY:int = drawUp?-y+20:160-y;
        
        if(transferGear.isFirst() && SettingsHolder.instance.isDownToUp()){
            startY = 0;
        }

        if(_activeSprite){
            _addSprite.graphics.beginFill(0xf754e1, 0.7);
        }else{
            _addSprite.graphics.beginFill(0xf754e1, 0.1);
        }

        _addSprite.graphics.drawRect(-20,startY,20,20);
        _addSprite.graphics.endFill();



        if(_activeSprite){
            _addSprite.graphics.lineStyle(2, 0x768ea1, 1);
        }else{
            _addSprite.graphics.lineStyle(2, 0x768ea1, 0);
        }

        _addSprite.graphics.moveTo(-10, startY+2);
        _addSprite.graphics.lineTo(-10, startY+18);

        _addSprite.graphics.moveTo(-18, startY+10);
        _addSprite.graphics.lineTo(-2, startY+10);
        
        
    }




  private function drawGear(gear:SimpleGear, k:Number, y:int):void {

      if(_second){
          graphics.beginFill(gear.color,0.3);
      }else{
          graphics.beginFill(gear.color);
      }
    graphics.drawRect(-gear.outerRadius * k, y,
        gear.outerRadius * k * 2, h);
    for (var i:int = 0; i < gear.amountOfCogs; i++) {
      var dAlpha:Number = Math.PI * 2 / gear.amountOfCogs;
      var alpha:Number = -gear.alpha - dAlpha * i;
      while(alpha>Math.PI*2){
        alpha = alpha-Math.PI*2;
      }
      while(alpha<0){
        alpha+=Math.PI*2;
      }
      if (alpha >= 0 && alpha <= Math.PI / 2) {
        graphics.moveTo(0 - gear.outerRadius * k * Math.sin(alpha), y);
        graphics.lineTo(0 - gear.outerRadius * k * Math.sin(alpha), y+h);
      }
      if (alpha >= 3 * Math.PI / 2 && alpha <= 2 * Math.PI) {
        graphics.moveTo(gear.outerRadius * k * Math.sin(Math.PI * 2 - alpha), y);
        graphics.lineTo(gear.outerRadius * k * Math.sin(Math.PI * 2 - alpha), y+h);
      }
    }
    graphics.endFill();
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


    public function set viewX2(viewX2:Number):void {
        _viewX2 = viewX2;
    }
}
}
