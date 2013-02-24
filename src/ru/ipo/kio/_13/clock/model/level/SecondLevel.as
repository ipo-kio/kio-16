/**
 * Специфичные операции для второго уровня
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

    [Embed(source='../../_resources/icon_statement_2.jpg')]
    private static var ICON_STATEMENT:Class;

    [Embed(source='../../_resources/icon_help_2.jpg')]
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


    //спрайты для времен года

    private var _fall:Sprite = new Sprite();

    private var _spring:Sprite = new Sprite();

    private var _summer:Sprite = new Sprite();

    private var _winter:Sprite = new Sprite();


    private var ANGLES_TO_IMAGES:Array = [[Math.PI,_winter, Math.PI/2],
        [Math.PI/2,_spring, Math.PI/2],
        [Math.PI*2, _summer, Math.PI/2],
        [Math.PI*3/2, _fall, Math.PI/2]];

    public function SecondLevel() {
        SettingsHolder.instance.sizeOfCog=10;
        _fall.addChild(new FALL);
        _summer.addChild(new SUMMER);
        _winter.addChild(new WINTER);
        _spring.addChild(new SPRING);
    }

    public function initSettings():void {
    }

    public function get level():int {
        return 2;
    }

    public function get icon_help():Class {
        return new ICON_HELP;
    }

    public function get icon_statement():Class {
        return new ICON_STATEMENT;
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
}
}
