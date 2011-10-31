package ru.ipo.kio._11_students.CrossedCountry {
import flash.display.Sprite;
import flash.events.TimerEvent;
import flash.utils.Timer;

/**
 * ...
 * @author Anna Anikina
 */
public class hero extends Sprite {
    public var h:Sprite;
    public var Arr:Array;
    public var i:int = 1;
    public var speed:Number = 0.01;
    public var HX:Number = 0;
    public var HY:Number = 0;
    public var tim:Timer = new Timer(200, 0); // 500 mseconds
    public var timMove:Timer = new Timer(10, 0);
    public var ImageArr:Array = new Array();
    public var imageIndex:int = 0;
    public var Obj:int = 1;
    private var lastObj:int = 0;
    private var l:landscape;

    //[Embed(systemFont = "Arial", fontName = "asdf", embedAsCff = "false", mimeType = "application/x-font")]
    public static const c:Class;

    public var ArrayImgInd:Array = new Array(1, 0, 4, 2, 3, 4, 3, 3, 1, 3, 2, 0, 0, 3, 1, 0, 0, 4, 1, 1, 0, 4, 2, 1, 4, 0, 3); // массив картинок анимации

    // клубок - песок номер 0

    [Embed(source = "hero/Clue_01.png")]
    public static const Clue1:Class;
    public var bmp1_1:* = new Clue1;

    [Embed(source = "hero/Clue_02.png")]
    public static const Clue2:Class;
    public var bmp1_2:* = new Clue2;

    [Embed(source = "hero/Clue_03.png")]
    public static const Clue3:Class;
    public var bmp1_3:* = new Clue3;

    [Embed(source = "hero/Clue_04.png")]
    public static const Clue4:Class;
    public var bmp1_4:* = new Clue4;

    // бабочка - горы номер 1

    [Embed(source = "hero/Baterfly_01.png")]
    public static const Butterfly1:Class;
    public var bmp2_1:* = new Butterfly1;

    [Embed(source = "hero/Baterfly_02.png")]
    public static const Butterfly2:Class;
    public var bmp2_2:* = new Butterfly2;

    [Embed(source = "hero/Baterfly_03.png")]
    public static const Butterfly3:Class;
    public var bmp2_3:* = new Butterfly3;

    // рыба - вода номер 2

    [Embed(source = "hero/Fish_01.png")]
    public static const Fish1:Class;
    public var bmp3_1:* = new Fish1;

    [Embed(source = "hero/Fish_02.png")]
    public static const Fish2:Class;
    public var bmp3_2:* = new Fish2;

    [Embed(source = "hero/Fish_03.png")]
    public static const Fish3:Class;
    public var bmp3_3:* = new Fish3;

    [Embed(source = "hero/Fish_04.png")]
    public static const Fish4:Class;
    public var bmp3_4:* = new Fish4;

    // Улитка - стены номер 3

    [Embed(source = "hero/Snail_01.png")]
    public static const Snail1:Class;
    public var bmp4_1:* = new Snail1;

    [Embed(source = "hero/Snail_02.png")]
    public static const Snail2:Class;
    public var bmp4_2:* = new Snail2;

    [Embed(source = "hero/Snail_03.png")]
    public static const Snail3:Class;
    public var bmp4_3:* = new Snail3;

    // Змея - лес номер 4

    [Embed(source = "hero/Snake_01.png")]
    public static const Snake1:Class;
    public var bmp5_1:* = new Snake1;

    [Embed(source = "hero/Snake_02.png")]
    public static const Snake2:Class;
    public var bmp5_2:* = new Snake2;

    [Embed(source = "hero/Snake_03.png")]
    public static const Snake3:Class;
    public var bmp5_3:* = new Snake3;

    [Embed(source = "hero/Snake_04.png")]
    public static const Snake4:Class;
    public var bmp5_4:* = new Snake4;

    private var Arr1:Array = new Array(bmp1_1, bmp1_2, bmp1_3, bmp1_4);
    private var Arr2:Array = new Array(bmp2_1, bmp2_2, bmp2_3);
    private var Arr3:Array = new Array(bmp3_1, bmp3_2, bmp3_3, bmp3_4);
    private var Arr4:Array = new Array(bmp4_1, bmp4_2, bmp4_3);
    private var Arr5:Array = new Array(bmp5_1, bmp5_2, bmp5_3, bmp5_4);


    public function hero(hExist:Boolean, directionArr:Array, land:landscape) {

        ImageArr.push(Arr1, Arr2, Arr3, Arr4, Arr5);

        h = new Sprite();
        l = land;
        Arr = directionArr;
        //tim.addEventListener(Event.ACTIVATE, onTick);
        tim.addEventListener(TimerEvent.TIMER, onTick);
        timMove.addEventListener(TimerEvent.TIMER, MoveHero);
        tim.start();
        timMove.start();
        HX = Arr[i];
        HY = Arr[i + 1];
        i = i + 3;
        h.x = HX;
        h.y = HY;
        addChild(h);
        h.addChild(ImageArr[ArrayImgInd[Obj]][imageIndex % ImageArr[ArrayImgInd[Obj]].length]);

        // уменьшение размера
        h.height = h.height / 4;
        h.width = h.width / 4;
    }

    public function onTick(e:TimerEvent):void {
        h.removeChild(ImageArr[ArrayImgInd[Obj]][imageIndex % ImageArr[ArrayImgInd[Obj]].length]);
        imageIndex++;
        h.addChild(ImageArr[ArrayImgInd[Obj]][imageIndex % ImageArr[ArrayImgInd[Obj]].length]);


        trace("tick " + e.target.currentCount);
    }

    public function MoveHero(e:TimerEvent):void {

        var XLine:Number = 0; // выравнивание координат: чтобы герой двигался по линии
        var YLine:Number = 0;

        speed = 0.0025;

        if (Arr[i] > HX) {
            if (Arr[i + 1] > HY) {
                //движение в 4 четверти
                HX = HX + speed * (Arr[i]);
                HY = lineY();

                h.rotation = 90 + Math.atan((Arr[i + 1] - HY) / (Arr[i] - HX)) * 57;
                //	XLine = -10;
                YLine = -10;
            }
            else {
                if (Arr[i + 1] == HY) {
                    // движение по оси х вправо
                    HX = HX + speed * (Arr[i]);

                    h.rotation = 90;

                    YLine = -10;

                }
                else {
                    //движение в 1 четверти
                    HX = HX + speed * (Arr[i]);
                    HY = lineY();

                    h.rotation = Math.atan((Arr[i] - HX) / ( HY - Arr[i + 1])) * 57;

                    XLine = - 5;
                    YLine = - 5;
                }
            }

        }
        else {
            if (Arr[i] == HX) {
                //speed =  dist()/1000;
                if (Arr[i + 1] > HY) {
                    //движение по оси y вниз

                    HY = HY + speed * (Arr[i + 1]);
                    h.rotation = 180;

                    XLine = 10;

                }
                else {
                    if (Arr[i + 1] < HY) {
                        //движение по оси y вверх

                        HY = HY - speed * (Arr[i + 1]);

                        h.rotation = 0;

                        XLine = - 5;

                    }

                }
            }
            else {
                if (Arr[i + 1] > HY) {
                    //движение в 3 четверти
                    HX = HX - speed * (Arr[i]);
                    HY = lineY();

                    h.rotation = 180 + Math.atan((HX - Arr[i]) / ( Arr[i + 1] - HY)) * 57;

                    XLine = 5;
                    YLine = 5;
                }
                else {
                    if (Arr[i + 1] == HY) {
                        // движение по оси х влево
                        HX = HX - speed * (Arr[i]);

                        h.rotation = -90;


                        YLine = 5;
                    }
                    else {
                        //движение в 2 четверти
                        HX = HX - speed * (Arr[i]);
                        HY = lineY();

                        h.rotation = - Math.atan((HX - Arr[i]) / (HY - Arr[i + 1])) * 57;

                        XLine = 5;

                        YLine = 5;

                    }
                }
            }
        }
        lastObj = Obj;
        trace(lastObj, Obj);
        Obj = l.HitObj(HX, HY);

        if ((ArrayImgInd[lastObj] != ArrayImgInd[Obj])) {
            trace("сравнение");
            h.removeChild(ImageArr[ArrayImgInd[lastObj]][imageIndex % ImageArr[ArrayImgInd[lastObj]].length]);
            imageIndex = 0;
            h.addChild(ImageArr[ArrayImgInd[Obj]][imageIndex % ImageArr[ArrayImgInd[Obj]].length]);


            // уменьшение размера

        }
        trace("obj = " + Obj);

        h.x = HX + XLine;
        h.y = HY + YLine;

        XLine = 0;
        YLine = 0;

        if (Math.abs(HX - Arr[i]) < 3 && (Math.abs(HY - Arr[i + 1]) < 3)) {
            nextpoint();
            HX = Arr[i];
            HY = Arr[i + 1];
            h.x = HX;
            h.y = HY;
            i = i + 3;
            if (i > Arr.length) {
                timMove.reset();
                tim.reset();
                removeChild(h);
            }
        }

        trace(h.x, h.y, HX, HY, speed, Arr[i], Arr[i + 1]);
        //trace("dist" + dist());

    }

    public function nextpoint():void {
        trace("nextpoint");
    }

    public function dist():Number {
        var d:Number;
        d = Math.sqrt(Math.pow(Arr[i] - Arr[i - 3], 2) + Math.pow(Arr[i + 1] - Arr[i - 2], 2));
        return d;
    }

    public function lineY():Number {
        return ((HX - Arr[i - 3]) * (Arr[i + 1] - Arr[i - 2]) / (Arr[i] - Arr[i - 3]) + Arr[i - 2]);
    }

    public function lineX():Number {
        return ((HY - Arr[i - 2]) * (Arr[i] - Arr[i - 3]) / (Arr[i + 1] - Arr[i - 2]) + Arr[i - 3]);
    }
}

}