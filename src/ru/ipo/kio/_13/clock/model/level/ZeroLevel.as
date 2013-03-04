/**
 * ����������� �������� ��� �������� ������
 * @author: Vasiliy
 * @date: 21.02.13
 */
package ru.ipo.kio._13.clock.model.level {


import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;

import ru.ipo.kio._13.clock.model.SettingsHolder;

import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.utils.printf;
import ru.ipo.kio._13.clock.view.gui.Bird;

public class ZeroLevel extends SilhouettesProductDrawer implements ITaskLevel {

    [Embed(source='../../_resources/Level_0-Statement-1.jpg')]
    private static var ICON_STATEMENT:Class;

    [Embed(source='../../_resources/Level_0-Help-1.jpg')]
    private static var ICON_HELP:Class;


    private var _bird:Bird = new Bird();
   
    
    //�������� ������

    [Embed(source='../../_resources/level0/1.png')]
    private static const DAY:Class;

    [Embed(source='../../_resources/level0/2.png')]
    private static const EVENING:Class;

    [Embed(source='../../_resources/level0/3.png')]
    private static const NIGHT:Class;

    [Embed(source='../../_resources/level0/4.png')]
    private static const EARLY_MORNING:Class;

    [Embed(source='../../_resources/level0/5.png')]
    private static const MORNING:Class;

    [Embed(source='../../_resources/level0/6.png')]
    private static const EARLY_DAY:Class;

    //������� ��� �������

    private var _day:Sprite = new Sprite();

    private var _evening:Sprite = new Sprite();

    private var _night:Sprite = new Sprite();

    private var _early_morning:Sprite = new Sprite();

    private var _morning:Sprite = new Sprite();

    private var _early_day:Sprite = new Sprite();

      //��� ��������� ���� ��� ����, ����� ����� ����� �������� ��� ������
   private var iteration:int = 0;
   private var first:Boolean=false;
   private var second:Boolean=false;

   //������ �������� ���� � ������� ������ �� ��������, ��������������� �� �������� � ���������� �� ����� ��������
    //��� ���������� ��� ������ ������ �� ��� ������� (����, ����)
    
   private const ANGLES_TO_IMAGES:Array = [[Math.PI*7/2,_morning, Math.PI],
                                          [Math.PI*5/2,_early_day, Math.PI/2],
                                          [Math.PI*4, _day, Math.PI/2],
                                          [Math.PI*3/2, _evening, Math.PI],
                                          [Math.PI/2,_night, Math.PI/2],
                                          [Math.PI*2,_early_morning,Math.PI/2]];

 
    
    public function ZeroLevel() {
        _day.addChild(new DAY);
        _evening.addChild(new EVENING);
        _night.addChild(new NIGHT);
        _early_morning.addChild(new EARLY_MORNING);
        _morning.addChild(new MORNING);
        _early_day.addChild(new EARLY_DAY);

        _bird.x = 340;
        _bird.y = 325;

        
    }



    private function addAction(sp:Sprite, num:int):void {
        sp.addEventListener(MouseEvent.MOUSE_DOWN, function (e:Event):void {
            sp.startDrag()
        })
        sp.addEventListener(MouseEvent.MOUSE_UP, function (e:Event):void {
            sp.stopDrag();
            trace("_people" + num + ".x=" + sp.x + ";");
            trace("_people" + num + ".y=" + sp.y + ";");
        })
    }

    public function get level():int {
        return 0;
    }

    public function get icon_help():Class {
        return ICON_HELP;
    }

    public function get icon_statement():Class {
        return ICON_STATEMENT;
    }

    public function get correctRatio():Number {
        return 12/1;
    }

    public function getFormattedPrecision(precision:Number):String {
        if(precision>99.5){
            return "100%";
        }
        if(precision>99){
            return "> 99%";
        }
        return  printf("%.0f",precision)+"%";
    }

    public function getFormattedError(error:Number):String {
        return  printf("%.5f",error)+"%";
//        if(error<0.5){
//            return "0%";
//        }
//        if(error<1){
//            return "< 1%";
//        }
//        return  printf("%.0f",error)+"%";
    }

    public function truncate(relTransmissionError:Number):Number {
        return relTransmissionError;
//        return Math.round(relTransmissionError*10);
    }

    public function undoTruncate(relTransmissionError:Number):Number {
        return relTransmissionError;
//        return relTransmissionError/10;
    }


    public function updateProductSprite():void{
        clearProductSprite();
        var alpha:Number = TransmissionMechanism.instance.leadingSimpleGear.alpha;
        calculateIteration(alpha);
        drawTwoImageFromArray(alpha+iteration*Math.PI*2, ANGLES_TO_IMAGES);
        drawArrows(340,170,590,180);
        var amountOfSilhouettes:int = people.length * (100 - TransmissionMechanism.instance.relTransmissionError)/100;
        addSilhouettes(amountOfSilhouettes);
        productSprite.addChild(_bird);
        if(TransmissionMechanism.instance.isFinished() && alpha>Math.PI-Math.PI/32 && alpha<Math.PI+Math.PI/32){
            if(!_bird.looked){
                _bird.looked=true;
                _bird.play();
            }
        }else{
            _bird.looked=false;
        }
    }

    

    private function calculateIteration(alpha:Number):void {
        if (alpha < 3 * Math.PI / 2 && alpha > Math.PI / 2) {
            if (!first) {
                first = true;
                second = false;
                iteration = (iteration + 1) % 2;
            }
        } else {
            if (first && !second) {
                first = false;
                second = true;
            }
        }
    }

    public function get direction():int {
        return SettingsHolder.UP_TO_DOWN;
    }


    public function resetListener():void {
        _bird.looked=true;
    }
}
}
