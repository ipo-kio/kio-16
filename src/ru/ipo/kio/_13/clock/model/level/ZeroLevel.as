/**
 * Специфицные операции для нулеовго уровня
 * @author: Vasiliy
 * @date: 21.02.13
 */
package ru.ipo.kio._13.clock.model.level {
import flash.display.Sprite;

import ru.ipo.kio._13.clock.model.TransmissionMechanism;
import ru.ipo.kio._13.clock.utils.printf;

public class ZeroLevel extends BasicProductDrawer implements ITaskLevel {

    [Embed(source='../../_resources/icon_statement_2.jpg')]
    private static var ICON_STATEMENT:Class;

    [Embed(source='../../_resources/icon_help_2.jpg')]
    private static var ICON_HELP:Class;


    //картинки города

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

    //спрайты для городов

    private var _day:Sprite = new Sprite();

    private var _evening:Sprite = new Sprite();

    private var _night:Sprite = new Sprite();

    private var _early_morning:Sprite = new Sprite();

    private var _morning:Sprite = new Sprite();

    private var _early_day:Sprite = new Sprite();

      //три служебных поля для того, чтобы знать какая половина дня сейчас
   private var iteration:int = 0;
   private var first:Boolean=false;
   private var second:Boolean=false;

   //массив содержит углы в порядке обхода их стрелкой, соответствующие им картинки и расстояние до новой картинки
    //это необходимо для логики обхода за два оборота (день, ночь)
    
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
    }

    public function get level():int {
        return 0;
    }

    public function get icon_help():Class {
        return new ICON_HELP;
    }

    public function get icon_statement():Class {
        return new ICON_STATEMENT;
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



    public function updateProductSprite():void{
        clearProductSprite();
        var alpha:Number = TransmissionMechanism.instance.firstGear.upperGear.alpha;
        calculateIteration(alpha);
        var alpha1:Number = alpha+iteration*Math.PI*2;
        for(var i:int=0; i<ANGLES_TO_IMAGES.length; i++){
            if(alpha1<ANGLES_TO_IMAGES[i][0]&&
               alpha1>ANGLES_TO_IMAGES[i][0]-ANGLES_TO_IMAGES[i][2]){
               var diff:Number = (alpha1-(ANGLES_TO_IMAGES[i][0]-ANGLES_TO_IMAGES[i][2]))/(ANGLES_TO_IMAGES[i][2]);
                var firstImage:Sprite=ANGLES_TO_IMAGES[i][1];
                var secondImage:Sprite=(i == ANGLES_TO_IMAGES.length-1)?ANGLES_TO_IMAGES[0][1]:ANGLES_TO_IMAGES[i+1][1];
                secondImage.alpha=1-diff;
                productSprite.addChild(firstImage);
                productSprite.addChild(secondImage);
                break;
            }
        }
        drawArrows();
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

}
}
