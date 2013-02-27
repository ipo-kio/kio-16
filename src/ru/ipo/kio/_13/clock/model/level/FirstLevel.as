/**
 * ����������� �������� ��� ������� ������
 * @author: Vasiliy
 * @date: 21.02.13
 */
package ru.ipo.kio._13.clock.model.level {
import flash.display.Sprite;

import ru.ipo.kio._13.clock.model.SettingsHolder;

import ru.ipo.kio._13.clock.model.TransmissionMechanism;

import ru.ipo.kio._13.clock.utils.printf;

public class FirstLevel extends SilhouettesProductDrawer implements ITaskLevel {

    [Embed(source='../../_resources/Level_1-Statement-1.jpg')]
    private static var ICON_STATEMENT:Class;

    [Embed(source='../../_resources/Level_1-Help-1.jpg')]
    private static var ICON_HELP:Class;

    //�������� ������

    [Embed(source='../../_resources/level1/city1.png')]
    private static const DAY:Class;

    [Embed(source='../../_resources/level1/city2.png')]
    private static const EVENING:Class;

    [Embed(source='../../_resources/level1/city3.png')]
    private static const NIGHT:Class;

    [Embed(source='../../_resources/level1/city4.png')]
    private static const EARLY_MORNING:Class;

    [Embed(source='../../_resources/level1/city5.png')]
    private static const MORNING:Class;

    [Embed(source='../../_resources/level1/city6.png')]
    private static const EARLY_DAY:Class;

    //������� ��� �������

    private var _day:Sprite = new Sprite();

    private var _evening:Sprite = new Sprite();

    private var _night:Sprite = new Sprite();

    private var _early_morning:Sprite = new Sprite();

    private var _morning:Sprite = new Sprite();

    private var _early_day:Sprite = new Sprite();

    //������ �������� ���� � ������� ������ �� ��������, ��������������� �� �������� � ���������� �� ����� ��������
    //��� ���������� ��� ������ ������ �� ��� ������� (����, ����)

    private var ANGLES_TO_IMAGES:Array = new Array();


    public function FirstLevel() {
        SettingsHolder.instance.sizeOfCog=13;
        fillImageArrayForBigClock();
        _day.addChild(new DAY);
        _evening.addChild(new EVENING);
        _night.addChild(new NIGHT);
        _early_morning.addChild(new EARLY_MORNING);
        _morning.addChild(new MORNING);
        _early_day.addChild(new EARLY_DAY);
    }

    private function fillImageArrayForBigClock():void {
        var alpha:Number = Math.PI;
        for (var day:int = 0; day < 7; day++) {
            alpha -= Math.PI * 2 / 7;
            if (alpha <= 0) {
                alpha += Math.PI * 2;
            }

            for (var threeHours:Number = 0; threeHours < 8; threeHours++) {
                var step:Number = (Math.PI * 2 / 7) / 8;
                var beta:Number = alpha - threeHours * step;
                if (beta <= 0) {
                    beta += Math.PI * 2;
                }
                if (threeHours == 2) {
                    ANGLES_TO_IMAGES.push([beta, _early_morning, step]);
                } else if (threeHours == 3) {
                    ANGLES_TO_IMAGES.push([beta, _morning, step]);
                } else if (threeHours == 4) {
                    ANGLES_TO_IMAGES.push([beta, _early_day, step]);
                } else if (threeHours == 5) {
                    ANGLES_TO_IMAGES.push([beta, _day, step]);
                } else if (threeHours == 6) {
                    ANGLES_TO_IMAGES.push([beta, _evening, 2 * step]);
                } else if (threeHours == 0) {
                    ANGLES_TO_IMAGES.push([beta, _night, step * 2]);
                }
            }
        }
    }

    public function get level():int {
        return 1;
    }

    public function get icon_help():Class {
        return ICON_HELP;
    }

    public function get icon_statement():Class {
        return ICON_STATEMENT;
    }

    public function get correctRatio():Number {
        return 14/1;
    }

    public function getFormattedPrecision(precision:Number):String {
        if(precision>99.995){
            return "100%";
        }
        if(precision>99.99){
            return "> 99,99%";
        }
        return  printf("%.2f",precision)+"%";
    }

    public function getFormattedError(error:Number):String {
        if(error<0.005){
            return "0%";
        }
        if(error<0.001){
            return "< 0,01%";
        }
        return  printf("%.2f",error)+"%";
    }

    public function truncate(relTransmissionError:Number):Number {
        return Math.round(relTransmissionError*1000);
    }

    public function undoTruncate(relTransmissionError:Number):Number {
        return relTransmissionError/1000;
    }


    public function updateProductSprite():void {
        clearProductSprite();
        drawTwoImageFromArray(TransmissionMechanism.instance.leadingSimpleGear.alpha, ANGLES_TO_IMAGES);
        drawArrows(340,170,590,180);
        var amountOfSilhouettes:int = people.length * (100 - TransmissionMechanism.instance.relTransmissionError)/100;
        addSilhouettes(amountOfSilhouettes);
    }

    public function get direction():int {
        return SettingsHolder.UP_TO_DOWN;
    }

    public function resetListener():void {
    }
}
}
