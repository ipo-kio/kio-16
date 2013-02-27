/**
 * Ñïåöèôè÷íûå îïåðàöèè äëÿ âòîðîãî óðîâíÿ
 * @author: Vasiliy
 * @date: 21.02.13
 */
package ru.ipo.kio._13.clock.model.level {
import flash.display.Sprite;

import ru.ipo.kio._13.clock.model.SettingsHolder;
import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.utils.printf;
import ru.ipo.kio._13.clock.view.gui.HourArrow;
import ru.ipo.kio._13.clock.view.gui.MinuteArrow;


public class SecondLevel extends BasicProductDrawer implements ITaskLevel {

    [Embed(source='../../_resources/Level_2-Statement-1.jpg')]
    private static var ICON_STATEMENT:Class;

    [Embed(source='../../_resources/Level_2-Help-1.jpg')]
    private static var ICON_HELP:Class;

    [Embed(source='../../_resources/level2/fall.png')]
    private static const FALL:Class;

    [Embed(source='../../_resources/level2/summer.png')]
    private static const SUMMER:Class;

    [Embed(source='../../_resources/level2/spring.png')]
    private static const SPRING:Class;

    [Embed(source='../../_resources/level2/winter.png')]
    private static const WINTER:Class;

    [Embed(source='../../_resources/level2/seasons.png')]
    private static const SEASONS:Class;

    [Embed(source='../../_resources/level2/small/8.png')]
    private static const FALL_SMALL:Class;

    [Embed(source='../../_resources/level2/small/6.png')]
    private static const SUMMER_SMALL:Class;

    [Embed(source='../../_resources/level2/small/2.png')]
    private static const SPRING_SMALL:Class;

    [Embed(source='../../_resources/level2/small/4.png')]
    private static const WINTER_SMALL:Class;




    //ñïðàéòû äëÿ âðåìåí ãîäà

    private var _fall:Sprite = new Sprite();

    private var _spring:Sprite = new Sprite();

    private var _summer:Sprite = new Sprite();

    private var _winter:Sprite = new Sprite();

    private var _fall_small:Sprite = new Sprite();

    private var _spring_small:Sprite = new Sprite();

    private var _summer_small:Sprite = new Sprite();

    private var _winter_small:Sprite = new Sprite();


    private var ANGLES_TO_IMAGES:Array = [[Math.PI,_winter, Math.PI/2],
        [Math.PI/2,_spring, Math.PI/2],
        [Math.PI*2, _summer, Math.PI/2],
        [Math.PI*3/2, _fall, Math.PI/2]];


    private var ANGLES_TO_SMALL_IMAGES:Array = [[Math.PI,_winter_small, Math.PI/2],
        [Math.PI/2,_spring_small, Math.PI/2],
        [Math.PI*2, _summer_small, Math.PI/2],
        [Math.PI*3/2, _fall_small, Math.PI/2]];

    public function SecondLevel() {
        SettingsHolder.instance.sizeOfCog=10;
        _fall.addChild(new FALL);
        _summer.addChild(new SUMMER);
        _winter.addChild(new WINTER);
        _spring.addChild(new SPRING);

        _fall_small.addChild(new FALL_SMALL);
        _summer_small.addChild(new SUMMER_SMALL);
        _winter_small.addChild(new WINTER_SMALL);
        _spring_small.addChild(new SPRING_SMALL);


        _fall_small.x=_summer_small.x =_winter_small.x = _spring_small.x = 340-73;
        _fall_small.y=_summer_small.y =_winter_small.y = _spring_small.y = 325-33;


    }

    public function initSettings():void {
    }

    public function get level():int {
        return 2;
    }

    public function get icon_help():Class {
        return ICON_HELP;
    }

    public function get icon_statement():Class {
        return ICON_STATEMENT;
    }

    public function get correctRatio():Number {
        return 28/365.2425;
    }

    public function getFormattedPrecision(precision:Number):String {
        var string:String = printf("%.10f",precision);
        var resultString:String = string.substr(0, string.indexOf(".")+1);
        for(var i:int=string.indexOf(".")+1; i<string.length; i++){
            if(string.charAt(i)=='9'){
                resultString+="9";
            }else{
                return resultString+"%";
            }
        }
        return resultString+"%";
    }

    public function getFormattedError(error:Number):String {
        var string:String = printf("%.10f",error);
        var resultString:String = string.substr(0, string.indexOf(".")+3);
        for(var i:int=string.indexOf(".")+3; i<string.length; i++){
            if(string.charAt(i)=='0'){
                resultString+="0";
            }else{
                return resultString+string.charAt(i)+"%";
            }
        }
        return resultString+"%";
    }

    public function truncate(relTransmissionError:Number):Number {
        return relTransmissionError;
    }


    public function undoTruncate(relTransmissionError:Number):Number {
        return relTransmissionError;
    }


    public function updateProductSprite():void {
        clearProductSprite();
        drawTwoImageFromArray(TransmissionMechanism.instance.lastDrivenSimpleGear.alpha, ANGLES_TO_IMAGES);
        if(TransmissionMechanism.instance.isFinished() && TransmissionMechanism.instance.relTransmissionError<1){
            drawTwoImageFromArray(TransmissionMechanism.instance.lastDrivenSimpleGear.alpha, ANGLES_TO_SMALL_IMAGES);
        }
        drawArrows(340,170,546,259);
    }

    protected override function drawArrows(bigCenterX:int,bigCenterY:int,smallCenterX:int,smallCenterY:int):void {
        var holst:Sprite = new Sprite();
        productSprite.addChild(holst);
        holst.graphics.lineStyle(1, 0x000000);

        var minuteArrow:Sprite = new MinuteArrow();
        productSprite.addChild(minuteArrow);
        minuteArrow.x = bigCenterX;
        minuteArrow.y = bigCenterY;
        rotateAroundCenter(minuteArrow, TransmissionMechanism.instance.leadingSimpleGear.alpha);

        if (TransmissionMechanism.instance.isFinished()) {
            var hourArrow:Sprite = new HourArrow();
            productSprite.addChild(hourArrow);
            hourArrow.x = bigCenterX;
            hourArrow.y = bigCenterY;
            rotateAroundCenter(hourArrow, TransmissionMechanism.instance.leadingSimpleGear.other.alpha);

            drawArrow(smallCenterX, smallCenterY, SMALL_HOUR_ARROW_LENGTH, TransmissionMechanism.instance.leadingSimpleGear.other.alpha, holst);
            drawArrow(smallCenterX, smallCenterY, SMALL_MINUTE_ARROW_LENGTH, TransmissionMechanism.instance.leadingSimpleGear.alpha, holst);
        } else {
            drawArrow(smallCenterX, smallCenterY, SMALL_HOUR_ARROW_LENGTH, TransmissionMechanism.instance.lastDrivenSimpleGear.alpha, holst);
        }
    }

    public function get direction():int {
        return SettingsHolder.DOWN_TO_UP;
    }

    public function resetListener():void {
    }
}
}
