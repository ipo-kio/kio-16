/**
 * Специфичные операции для второго уровня
 * @author: Vasiliy
 * @date: 21.02.13
 */
package ru.ipo.kio._13.clock.model.level {
import flash.display.Sprite;

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
        for(var i:int=string.indexOf(",")+1; i<string.length; i++){
            if(string.charAt(i)=='9'){
                resultString+="9";
            }else{
                return resultString+"%";
            }
        }
        return resultString+"%";
    }


    public function updateProductSprite():void {
        clearProductSprite();
        var alpha:Number = TransmissionMechanism.instance.getLastInChain().lowerGear.alpha;
        for(var i:int=0; i<ANGLES_TO_IMAGES.length; i++){
            if(alpha<ANGLES_TO_IMAGES[i][0]&&
                    alpha>ANGLES_TO_IMAGES[i][0]-ANGLES_TO_IMAGES[i][2]){
                var diff:Number = (alpha-(ANGLES_TO_IMAGES[i][0]-ANGLES_TO_IMAGES[i][2]))/(ANGLES_TO_IMAGES[i][2]);
                var firstImage:Sprite=ANGLES_TO_IMAGES[i][1];
                var secondImage:Sprite=(i == ANGLES_TO_IMAGES.length-1)?ANGLES_TO_IMAGES[0][1]:ANGLES_TO_IMAGES[i+1][1];
                secondImage.alpha=1-diff;
                firstImage.alpha=1;
                productSprite.addChild(firstImage);
                productSprite.addChild(secondImage);
                break;
            }
        }

        drawArrows();
    }

    protected override function drawArrows():void {
        var holst:Sprite = new Sprite();
        productSprite.addChild(holst);
        holst.graphics.lineStyle(1, 0x000000);

        var hourArrow:Sprite = new HourArrow();
        productSprite.addChild(hourArrow);
        hourArrow.x = 340;
        hourArrow.y = 170;
        rotateAroundCenter(hourArrow, TransmissionMechanism.instance.firstGear.upperGear.alpha);

        if (TransmissionMechanism.instance.isFinished()) {
            var minuteArrow:Sprite = new MinuteArrow();
            productSprite.addChild(minuteArrow);
            minuteArrow.x = 340;
            minuteArrow.y = 170;
            rotateAroundCenter(minuteArrow, TransmissionMechanism.instance.firstGear.lowerGear.alpha);

            drawArrow(546, 259, 30, TransmissionMechanism.instance.firstGear.lowerGear.alpha, holst);
            drawArrow(546, 259, 20, TransmissionMechanism.instance.firstGear.upperGear.alpha, holst);
        } else {
            drawArrow(546, 259, 30, TransmissionMechanism.instance.getLastInChain().alpha, holst);
        }
    }
}
}
