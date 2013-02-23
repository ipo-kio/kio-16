/**
 *
 * @author: Vasiliy
 * @date: 23.02.13
 */
package ru.ipo.kio._13.clock.view.controls {
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import ru.ipo.kio._13.clock.ClockProblem;
import ru.ipo.kio._13.clock.model.SettingsHolder;
import ru.ipo.kio._13.clock.utils.printf;
import ru.ipo.kio.api.KioApi;

import ru.ipo.kio.api.TextUtils;

public class InfoPanel extends AbstractPanel {

    private var _crashMarker:TextField;

    private var _squareField:TextField;

    private var _numberField:TextField;

    private var _directionMarker:TextField;

    public function InfoPanel(header:String) {
        addChild(addSettingField(header, 0, 0, 0, function (e:KeyboardEvent):void {}).label);

        var objNumberField:Object = addSettingField("transmission", 0, 15, 0, function (e:KeyboardEvent):void {});
        var objSquareField:Object = addSettingField("square", 0, 55, 0, function (e:KeyboardEvent):void {});
        addChild(objNumberField.label);
        addChild(objNumberField.field);
        addChild(objSquareField.label);
        addChild(objSquareField.field);
        _numberField = objNumberField.field;
        _squareField = objSquareField.field;

        _numberField.type=TextFieldType.DYNAMIC;
        _squareField.type=TextFieldType.DYNAMIC;

        _directionMarker = new TextField();
        _directionMarker.type = TextFieldType.DYNAMIC;
        _directionMarker.x = 90;
        _directionMarker.y = _numberField.y;
        _directionMarker.width=11;
        _directionMarker.height=_numberField.height+1;
        addChild(_directionMarker);

        var loc:Object = KioApi.getLocalization(ClockProblem.ID);
        _crashMarker = TextUtils.createTextFieldWithFont(TextUtils.FONT_MESSAGES, 13);
        _crashMarker.htmlText = "<p align='center'>" + loc.headers.crash + "</p>";
        _crashMarker.type = TextFieldType.DYNAMIC;
        _crashMarker.x = 5;
        _crashMarker.y = 100;
        _crashMarker.visible=false;
        addChild(_crashMarker);
        _crashMarker.background=true;
        _crashMarker.backgroundColor=0xff0000;

        if(SettingsHolder.instance.levelImpl.level==0){
            _squareField.height=50;
            _crashMarker.y = 125;
        }
    }


    public function displayCrashMaker(isDisplay:Boolean):void{
        _crashMarker.visible=isDisplay;
    }

    public function updateNumbers(correctDirection:Boolean, formattedNumber:String, square:Number=0):void {
        _numberField.text=formattedNumber;
        _directionMarker.background=true;
        if(correctDirection){
            _directionMarker.backgroundColor=0xAAFFAA;
        }else{
            _directionMarker.backgroundColor=0xFFAAAA;
        }
        if(square!=0){
            if(SettingsHolder.instance.levelImpl.level==0){
                _squareField.htmlText = getFormattedSquareForZeroLevel(square);
            }else{
                _squareField.text = printf("%.3f", square);
            }
        }else{
            _squareField.text = "---";
        }
        _squareField.setTextFormat(new TextFormat("Courier"));
    }

    private function getFormattedSquareForZeroLevel(square:Number):String {
        var sq:int = square;
        var string:String = sq.toString();
        var result:String = "";
        var loc:Object = KioApi.getLocalization(ClockProblem.ID);

        for (var i:int = 0; string.length > 0; i++) {
            var item:String = "";
            if (string.length > 1) {
                item = string.substring(string.length - 2);
                string = string.substring(0, string.length - 2);
            } else {
                item = string.substring(string.length - 1);
                string = string.substring(0, string.length - 1);
            }

            if (item.charAt(0) == '0') {
                item = item.substring(1);
            }

            if (item.length==1) {
                item = " "+item;
            }

            if (i == 0) {
                result = item + " " + loc.headers["cm"] + "" + result;
            } else if (i == 1) {
                result = item + " " + loc.headers["dm"] + "\n" + result;
            } else if (i == 2) {
                result = item + " " + loc.headers["m"] + "\n"+ result;
            }
        }
        return result;
    }
}
}
