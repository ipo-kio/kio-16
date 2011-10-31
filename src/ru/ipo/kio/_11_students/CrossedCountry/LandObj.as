package ru.ipo.kio._11_students.CrossedCountry {
import flash.display.*;
import flash.events.*;
import flash.geom.Matrix;
import flash.text.TextFormat;
import flash.utils.*;

public class LandObj extends Sprite {
    private var bmpImage:BitmapData;
    public var mShape:Sprite;

    public var ObjA:Array;
    public var delay:Number;

    public var pic:Bitmap;

    [Embed(source="Background.jpg")]
    public static const INPUT_BG:Class;

    public var checkCapy:Boolean = true;
    private var interval:uint;

    public var alt:MovieClip = new MovieClip();
    public var eventX:Number;
    public var eventY:Number;
    private var drawB:Boolean = false;

    public function LandObj(ObjX:Number, ObjY:Number, ObjNum:Number, ObjArray:Array, tx:Number, ty:Number) {

        delay = 10000;
        mShape = new Sprite();

        pic = new INPUT_BG();
        bmpImage = pic.bitmapData;
        //bmpImage.draw(bmpImage);

        var matrix:Matrix = new Matrix();
        matrix.translate(tx, ty);
        bmpImage.draw(bmpImage, matrix);

        //mShape.addChild(pic);

        mShape.x = ObjX;
        mShape.y = ObjY;

        ObjA = ObjArray;

        mShape.graphics.lineStyle();
        mShape.graphics.beginBitmapFill(bmpImage, matrix);
        for (var i:Number = 0; i < ((ObjNum * 2) - 2); i = i + 2) {
            mShape.graphics.lineTo(ObjA[i], ObjA[i + 1]);
        }
        mShape.graphics.endFill();

        addChild(mShape);

    }

    public function ObjArrXY():Array {
        var Arr:Array = new Array();

        Arr.push(mShape.x);
        Arr.push(mShape.y);

        for (var i:int = 0; i < ObjA.length - 1; i = i + 2) {
            Arr.push(ObjA[i] + mShape.x);
            Arr.push(ObjA[i + 1] + mShape.y);
        }
        return Arr;
    }


    private function setupEvents():void {
        mShape.addEventListener(MouseEvent.MOUSE_MOVE, eventHandler);

    }

    public function eventHandler(e:MouseEvent):void {
        if (mShape.hitTestPoint(Main.instance.mouseX, Main.instance.mouseY)) {
            eventX = Main.instance.mouseX;
            eventY = Main.instance.mouseY;
            if (drawB) removeDrawC();

            if (checkCapy) {

                interval = setInterval(drawC, delay);
                trace("попал на объект " + ObjA[ObjA.length - 1]);

            }

        }


    }

    private function drawC():void {
        clearInterval(interval);

        var format:TextFormat = new TextFormat();
        format.size = 10;

        var target:DisplayObject = mShape.parent;


    }

    private function updatePosition():void {
        var target:DisplayObjectContainer = mShape.parent;
        alt.x = eventX - (100 / 2);
        alt.y = eventY - (50 + 5);

    }

    private function removeDrawC():void {
        removeChild(alt);
        drawB = false;
    }


}


}