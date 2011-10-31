package ru.ipo.kio._11_students.CrossedCountry {
/**
 * ...
 * @author Anna
 */

import flash.display.*;
import flash.events.*;
import flash.text.*;

import ru.ipo.kio.api.controls.*;

public class description extends Sprite {
    public var but:Sprite = new Sprite();
    public var deleteLastPoint:Boolean = false;
    public var b:button = new button();
    public var b2:button = new button();
    public var butHero:button = new button();
    public var format:TextFormat = new TextFormat();
    public var t0:TextField = new TextField();
    public var t1:TextField = new TextField();
    public var t2:TextField = new TextField();
    public var t3:TextField = new TextField();
    public var tEr:TextField = new TextField();
    public var tErTrue:Boolean = false;


    [Embed(source="Button_01.png")]
    public static const BIm1:Class;
    public var im1:Bitmap = new BIm1();

    [Embed(source="Button_02.png")]
    public static const BIm2:Class;
    public var im2:Bitmap = new BIm2();

    [Embed(source="Button_03.png")]
    public static const BIm3:Class;
    public var im3:Bitmap = new BIm3();

    [Embed(source='ds_greece.ttf',embedAsCFF = "false",fontName = "Greece", mimeType = "application/x-font-truetype")]
    private static var greece_font:Class;

    public var DelLast:GraphicsButton = new GraphicsButton("Удалить последний шаг", im1.bitmapData, im2.bitmapData, im3.bitmapData, "Greece", 10, 10);

    public var DelSel:GraphicsButton = new GraphicsButton("Удалить точку", im1.bitmapData, im2.bitmapData, im3.bitmapData, "Greece", 10, 10);

    public function description() {
        uint1();
        uint2();

    }

    private function uint1(e:Event = null):void {

        DelLast.x = 650;
        DelLast.y = 200;
        addChild(DelLast);

        DelSel.x = 650;
        DelSel.y = 300;
        addChild(DelSel);

        t0.embedFonts = true;
        t1.embedFonts = true;
        t2.embedFonts = true;
        t3.embedFonts = true;

        t0.text = "Результат";
        t1.text = "Длина";
        t2.text = "Время";

        t3.text = "";

        //format.font = "_sans";
        //format.size = 15;
        t0.setTextFormat(new TextFormat("Greece", 15));
        t2.setTextFormat(new TextFormat("Greece", 15));
        t1.setTextFormat(new TextFormat("Greece", 15));
        t3.setTextFormat(new TextFormat("Greece", 15));

        t0.x = 670;
        t0.y = 20;
        t1.x = 650;
        t1.y = 40;
        t2.x = 650;
        t2.y = 60;

        t3.x = 650;
        t3.y = 420;

        tEr.x = 700;
        tEr.y = 330;
        tEr.wordWrap = true;
        addChild(t0);
        addChild(t1);
        addChild(t2);
        addChild(t3);
    }

    private function uint2(e:Event = null):void {

        b.x = 700;
        b.y = 200;
        //addChild(b);

        b2.x = 700;
        b2.y = 270;

        //addChild(b2);

        butHero.x = 700;
        butHero.y = 100;

        //addChild(butHero);


        var label:TextField = new TextField();
        var label2:TextField = new TextField();
        var labelHero:TextField = new TextField();


        format.font = "_sans";
        format.size = 15;
        label.setTextFormat(format);
        label.wordWrap = true;
        label.multiline;
        label.text = "Удалить последний шаг";


        b.addChild(label);

        label.autoSize = "left";
        label.selectable = false;


        label2.setTextFormat(format);
        label2.wordWrap = true;
        label2.multiline;
        label2.text = "Удалить точку";
        label2.autoSize = "left";
        label2.selectable = false;

        b2.addChild(label2);

        labelHero.setTextFormat(format);
        labelHero.wordWrap = true;
        labelHero.multiline;
        labelHero.text = "Запустить героя";
        labelHero.autoSize = "left";
        labelHero.selectable = false;

        butHero.addChild(labelHero);
    }

    public function RemError():void {
        if (tErTrue) {
            removeChild(tEr);
            tErTrue = false;
        }
    }

    public function AdError():void {
        if (!tErTrue) {
            addChild(tEr);
            tErTrue = true;
        }
    }


}

}