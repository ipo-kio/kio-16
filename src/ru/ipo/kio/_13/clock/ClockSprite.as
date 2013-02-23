/**
 *
 * @author: Vasiliy
 * @date: 30.12.12
 */
package ru.ipo.kio._13.clock {
import fl.controls.ComboBox;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.utils.setTimeout;

import ru.ipo.kio._13.clock.model.SettingsHolder;
import ru.ipo.kio._13.clock.model.TransferGear;
import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.model.level.ITaskLevel;
import ru.ipo.kio._13.clock.utils.ColorGenerator;
import ru.ipo.kio._13.clock.utils.printf;
import ru.ipo.kio.api.KioApi;
import ru.ipo.kio.api.TextUtils;
import ru.ipo.kio.base.displays.ShellButton;

public class ClockSprite extends Sprite {

    private var _transmissionMechanism:TransmissionMechanism = TransmissionMechanism.instance;
    
    private var settingsPanel:Sprite = new Sprite();

    private var _squareField:TextField;

    private var _numberField:TextField;

    public static var instanse:ClockSprite;
    
    private var _levelImpl:ITaskLevel;
    
    private var errorSprite:Sprite = new Sprite();

    private var errorText:TextField = new TextField();

    private var productSprite:Sprite;

    public function ClockSprite(levelImpl:ITaskLevel) {
        _levelImpl = levelImpl;
        instanse=this;
        productSprite = levelImpl.getProductSprite();
        productSprite.x = 115;
        errorSprite.addChild(errorText);
        errorSprite.addEventListener(MouseEvent.CLICK, function(e:Event):void{
           removeChild(errorSprite);
        });
        addChild(transmissionMechanism.view);
        addChild(transmissionMechanism.viewSide);
        transmissionMechanism.viewSide.y = 400;
        transmissionMechanism.viewSide.x = 110;
        transmissionMechanism.view.x = 110;
        transmissionMechanism.addTransferGear(new TransferGear(transmissionMechanism, 320, 200, 25, 20, ColorGenerator.nextHueOfColor(transmissionMechanism.transferGearList)));
        transmissionMechanism.addTransferGear(new TransferGear(transmissionMechanism, 370, 257, 20, 10, ColorGenerator.nextHueOfColor(transmissionMechanism.transferGearList)));
        transmissionMechanism.addTransferGear(new TransferGear(transmissionMechanism, 435, 210, 20, 10, ColorGenerator.nextHueOfColor(transmissionMechanism.transferGearList)));
        /*for(var j:int=1; j<5; j++){
            for(var k:int=1; k<5; k++){
                var y:int = k*87;
                if(j%2==0){
                  y=(5-k)*87;
                }
                if(j ==1 && k ==1){
                    transmissionMechanism.addTransferGear(new TransferGear(transmissionMechanism, j*87, y, 25, 20, ColorGenerator.nextHueOfColor(transmissionMechanism.transferGearList)));
                }else{
                    transmissionMechanism.addTransferGear(new TransferGear(transmissionMechanism, j*87, y, 20, 10, ColorGenerator.nextHueOfColor(transmissionMechanism.transferGearList)));
                }
            }
        }*/

        addSettingsPanel();
    }
    
    public function showError(text:String):void{
        errorSprite.graphics.clear();
        errorSprite.graphics.beginFill(0xffffff,0.7);
        errorSprite.graphics.drawRect(115,0,675,400);
        errorSprite.graphics.endFill();
        errorText.text = text;
        var format:TextFormat = new TextFormat("Arial", 20, 0xff0000);
        errorText.setTextFormat(format);
        errorText.x=100+(700-errorText.textWidth)/2;
        errorText.width=errorText.textWidth+20;
        errorText.height=errorText.textHeight+20;
        errorText.y=(500-errorText.textHeight)/2;

        addChild(errorSprite);
    }

  private var _playButton:ShellButton;

  private var _stopButton:ShellButton;

    private var _showButton:ShellButton;

    private var _hideButton:ShellButton;

    private var _cbSpeed:ComboBox = new ComboBox();

    private function addSettingsPanel():void {
        var loc:Object = KioApi.getLocalization(ClockProblem.ID);

        addChild(settingsPanel);
        settingsPanel.x = 5;
        settingsPanel.graphics.beginFill(0xCCCCCC);
        settingsPanel.graphics.drawRect(0, 0, 110, 600);

        addSettingField("rotate", 0, 5, 0, function (e:KeyboardEvent):void {}, false);

        addChild(_cbSpeed);
      _cbSpeed.x = 10;
      _cbSpeed.y=25;
      _cbSpeed.width= 100;
        _cbSpeed.addItem( { label: loc.headers.very_slow, data:TransmissionMechanism.VERY_SLOW_SPEED } );
        _cbSpeed.addItem( { label: loc.headers.slow, data:TransmissionMechanism.SLOW_SPEED } );
       _cbSpeed.addItem( { label: loc.headers.middle, data:TransmissionMechanism.MIDDLE_SPEED } );
      _cbSpeed.addItem( { label: loc.headers.fast, data:TransmissionMechanism.FAST_SPEED } );
       _cbSpeed.addItem( { label: loc.headers.very_fast, data:TransmissionMechanism.VERY_FAST_SPEED } );
        _cbSpeed.selectedIndex=2;

      _cbSpeed.addEventListener(Event.CHANGE, speedSelected);


        createButton("step", 5, 55, function (event:MouseEvent):void {
            transmissionMechanism.rotate(SettingsHolder.instance.stepRotateInRadians);
        }, false);

        _playButton = createButton("play", 5, 85, function (event:MouseEvent):void {
            transmissionMechanism.playStop();
        }, false);

        _stopButton = createButton("stop", 5, 85, function (event:MouseEvent):void {
            transmissionMechanism.playStop();
        }, false);

        _stopButton.visible=false;
        _playButton.visible=true;

        createButton("reset", 5, 115, function (event:MouseEvent):void {
            transmissionMechanism.resetAlpha();
            transmissionMechanism.view.update();
        }, false);


        addSettingField("edit", 0, 150, 0, function (e:KeyboardEvent):void {}, false);

        _showButton = createButton("show", 5, 265, function (event:MouseEvent):void {
            _showButton.visible=false;
            _hideButton.visible=true;
            addChild(productSprite);
            _levelImpl.updateProductSprite();
        });


        _hideButton = createButton("hide", 5, 265, function (event:MouseEvent):void {
            _showButton.visible=true;
            _hideButton.visible=false;
            removeChild(productSprite);
        });

        _showButton.visible=true;
        _hideButton.visible=false;

        createButton("add", 5, 175, function (event:MouseEvent):void {
            transmissionMechanism.addTransferGear(new TransferGear(transmissionMechanism, 350, 200, 20, 10, ColorGenerator.nextHueOfColor(transmissionMechanism.transferGearList)));
            transmissionMechanism.deactivateAll();
            transmissionMechanism.transferGearList[transmissionMechanism.transferGearList.length-1].isActive=true;
            transmissionMechanism.transferGearList[transmissionMechanism.transferGearList.length-1].view.update();

        });

        createButton("delete", 5, 220, function (event:MouseEvent):void {
            var transferGear:TransferGear = transmissionMechanism.getActive();
            if(transferGear==null){
                showError(loc.messages.delete_empty);
            }else if (transferGear.isFirst()) {
                showError(loc.messages.delete_arrow);
            }else{
                transmissionMechanism.removeTransferGear(transferGear);
            }
        });

        addSettingField("result", 0, 310, 0, function (e:KeyboardEvent):void {}, false);

        _numberField = addSettingField("transmission", 0, 330, 0, function (e:KeyboardEvent):void {
        });
        _squareField = addSettingField("square", 0, 370, 0, function (e:KeyboardEvent):void {
        });

        _numberField.type=TextFieldType.DYNAMIC;
        _squareField.type=TextFieldType.DYNAMIC;
        if(_levelImpl.level==0){
            _squareField.height=60;
        }

//        var cogSizeField:TextField = addSettingField("cogSize", 0, 430, SettingsHolder.instance.sizeOfCog, function (e:KeyboardEvent):void {
//            if (e.keyCode == 13) {
//                SettingsHolder.instance.sizeOfCog = Number(cogSizeField.text);
//                TransmissionMechanism.instance.view.update();
//            }
//        });
//
//        var crossZoneField:TextField = addSettingField("crossZone", 0, 470, SettingsHolder.instance.crossZone, function (e:KeyboardEvent):void {
//            if (e.keyCode == 13) {
//                SettingsHolder.instance.crossZone = Number(crossZoneField.text);
//                TransmissionMechanism.instance.view.update();
//            }
//        });
//
//        var maxDivField:TextField = addSettingField("maxDiv", 0, 510, SettingsHolder.instance.maxDiv, function (e:KeyboardEvent):void {
//            if (e.keyCode == 13) {
//                SettingsHolder.instance.maxDiv = Number(maxDivField.text);
//            }
//        });


        _crashMarker = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        _crashMarker.htmlText = "<p align='center'>" + loc.headers.crash + "</p>";;
        _crashMarker.type = TextFieldType.DYNAMIC;
        _crashMarker.x = 5;
        _crashMarker.y = 420;
        if(_levelImpl.level==0){
            _crashMarker.y = 460;
        }
        _crashMarker.visible=false;
        settingsPanel.addChild(_crashMarker);
        _crashMarker.background=true;
        _crashMarker.backgroundColor=0xff0000;

    }

    private var _crashMarker:TextField;

    private function speedSelected(e:Event):void {
        SettingsHolder.instance.stepRotate = Number(_cbSpeed.selectedItem.data);
    }


    public function update():void{
        if(_numberField!=null){
      _numberField.text = TransmissionMechanism.instance.formattedNumber;
            if(TransmissionMechanism.instance.isFinished()&&
                    !TransmissionMechanism.instance.isConflict()){
                if(_levelImpl.level==0){
                       var sq:int =  TransmissionMechanism.instance.square;
                       var string:String = sq.toString();
                       var result:String = "";
                    var loc:Object = KioApi.getLocalization(ClockProblem.ID);

                       for(var i:int = 0; string.length>0; i++){
                           var item:String = "";
                           if(string.length>1){
                               item = string.substring(string.length-2);
                               string = string.substring(0,string.length-2);
                           }else{
                               item = string.substring(string.length-1);
                               string = string.substring(0,string.length-1);
                           }

                           if(item.charAt(0)=='0'){
                               item=item.substring(1);
                           }

                           if(i ==0){
                               result=item+" "+loc.headers["cm"]+" "+result;
                           }else if(i ==1){
                               result=item+" "+loc.headers["dm"]+"\n "+result;
                           }else if(i ==2){
                               result=item+" "+loc.headers["m"]+"\n "+result;
                           }
                       }
                       _squareField.text = result;
                }else{
                    _squareField.text = printf("%.3f", TransmissionMechanism.instance.square);
                }
            }else{
                _squareField.text = "---";
            }
         if(TransmissionMechanism.instance.isPlay()){
           _stopButton.visible=true;
           _playButton.visible=false;
         }else{
           _stopButton.visible=false;
           _playButton.visible=true;
         }

            if(TransmissionMechanism.instance.isConflict()){
                _crashMarker.visible=true;
            }else{
                _crashMarker.visible=false;
            }
        }
    }


    private function addSettingField(name:String, x:int, y:int, initialValue:int, action:Function, input:Boolean=true):TextField {
        var loc:Object = KioApi.getLocalization(ClockProblem.ID);
        var settingFieldLabel:TextField = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        settingFieldLabel.htmlText = "<p align='center'>" + loc.headers[name] + "</p>";;
        settingFieldLabel.type = TextFieldType.DYNAMIC;
        settingFieldLabel.x = x;
        settingFieldLabel.y = y;
        var settingField:TextField = new TextField();
        settingField.type = TextFieldType.INPUT;
        settingField.text=""+initialValue;
        settingField.border=true;
        settingField.x = x+10;
        settingField.y = y+settingFieldLabel.textHeight+5;
        settingField.width=90;
        settingField.height=20;
        settingField.addEventListener(KeyboardEvent.KEY_DOWN, action);
        settingsPanel.addChild(settingFieldLabel);
        if(input){
            settingsPanel.addChild(settingField);
        }
        return settingField;
    }



    private function createButton(caption:String, x:int, y:int, func:Function, high:Boolean = true):ShellButton {
        var loc:Object = KioApi.getLocalization(ClockProblem.ID);
        var clearButton:ShellButton = new ShellButton(loc.buttons[caption], false, high);
        addChild(clearButton);
        clearButton.x = x;
        clearButton.y = y;
        clearButton.addEventListener(MouseEvent.CLICK, func);
        settingsPanel.addChild(clearButton);
        return clearButton;
    }
                                                               
    public function get transmissionMechanism():TransmissionMechanism {
        return _transmissionMechanism;
    }


    public function get level():int {
        return _levelImpl.level;
    }

}
}
